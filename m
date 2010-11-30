Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab0K3Rme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:42:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578Ab0K3Rmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:42:33 -0500
Message-ID: <4CF53784.2000701@redhat.com>
Date: Tue, 30 Nov 2010 19:42:28 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] KVM: SVM: Wrap access to intercept masks into functions
References: <1291136641-4874-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1291136641-4874-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2010 07:03 PM, Joerg Roedel wrote:
> Hi Avi, Hi Marcelo,
>
> this patchset wraps the access to the intercept vectors in the VMCB into
> specific functions. There are two reasons for this:
>
> 	1) In the nested-svm code the effective intercept masks are
> 	   calculated from the host and the guest intercept masks.
> 	   Whenever KVM changes the host intercept mask while the VCPU
> 	   is in guest-mode the effective intercept masks need to be
> 	   re-calculated. This is nicely wrapped into these functions
> 	   now and makes the code more robust.
>
> 	2) These changes make the implementation of the upcoming
> 	   vmcb-clean-bits feature easier and also more robust (which
> 	   was the main reason for writing this patchset).
>
> These patches were developed on-top of the patch-set I sent yesterday. I
> tested these patches with various guests (Windows-64, Linux 32,32e and
> 64 as well as with nested-svm).
>

Looks good.

One potential issue is that a series of set_intercept()s causes 
recalc_intercepts() to be called multiple times.  If it turns out to be 
a problem, we can fix it by having an intercepts dirty bit and 
recalculating during guest entry if the bit is set.

Since it's nested svm only, I doubt we'll see a problem in the short term.

-- 
error compiling committee.c: too many arguments to function

