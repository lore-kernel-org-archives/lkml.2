Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0DWOls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 10:41:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:60317 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033Ab0DWOlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 10:41:45 -0400
Subject: Re: [PATCH 7/8] KVM: x86: Allow marking an exception as reinjected
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20100423142702.GH31537@amd.com>
Date: Fri, 23 Apr 2010 16:41:41 +0200
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <3731206E-63C9-4A5C-9B20-E31D7559CEAF@suse.de>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com> <1271932394-13968-8-git-send-email-joerg.roedel@amd.com> <46B1F208-76A4-4C2F-9AE7-789264AB2D4B@suse.de> <20100423142702.GH31537@amd.com>
To: Joerg Roedel <joerg.roedel@amd.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 23.04.2010, at 16:27, Joerg Roedel wrote:

> On Fri, Apr 23, 2010 at 03:57:32PM +0200, Alexander Graf wrote:
>> 
>> On 22.04.2010, at 12:33, Joerg Roedel wrote:
>> 
>>> This patch adds logic to kvm/x86 which allows to mark an
>>> injected exception as reinjected. This allows to remove an
>>> ugly hack from svm_complete_interrupts that prevented
>>> exceptions from being reinjected at all in the nested case.
>>> The hack was necessary because an reinjected exception into
>>> the nested guest could cause a nested vmexit emulation. But
>>> reinjected exceptions must not intercept. The downside of
>>> the hack is that a exception that in injected could get
>>> lost.
>>> This patch fixes the problem and puts the code for it into
>>> generic x86 files because. Nested-VMX will likely have the
>>> same problem and could reuse the code.
>> 
>> So we always handle the reinjection from KVM code? Shouldn't the l1
>> hypervisor do this?
> 
> No. We only have the problem if we need to handle a nested intercept on
> the host level instead of reinjecting it. So the nested hypervisor
> couldn't be involved in the reinjection.

Hrm, makes sense. Not pretty.


Alex

