Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab1HDIh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 04:37:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab1HDIhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 04:37:23 -0400
Message-ID: <4E3A5A38.9080406@redhat.com>
Date: Thu, 04 Aug 2011 11:37:12 +0300
From: Dor Laor <dlaor@redhat.com>
Reply-To: dlaor@redhat.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Eric B Munson <emunson@mgebm.net>
CC: kvm@vger.kernel.org, kvm-ia64@vger.kernel.org, kvm-ppc@vger.kernel.org,
        avi@redhat.com, riel@redhat.com, glommer@redhat.com,
        linux-kernel@vger.kernel.org, aliguori@us.ibm.com, raharper@us.ibm.com,
        Glauber Costa <glommer@gmail.com>
Subject: Re: [RFC PATCH 0/3] Avoid soft lockup message when KVM is stopped
 by host
References: <1312381501-27746-1-git-send-email-emunson@mgebm.net>
In-Reply-To: <1312381501-27746-1-git-send-email-emunson@mgebm.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2011 05:24 PM, Eric B Munson wrote:
> This set is just a rough first pass at avoiding soft lockup warnings when a host
> pauses the execution of a guest.  A flag is set by the host in the shared page
> used for the pvclock when the host goes to stop the guest.  When the guest
> resumes and detects a soft lockup, this flag is checked and cleared and the soft
> lockup message is skipped.

While this will cover the case were the host stops a guest, there will 
be other plain cases where the host is just over committed and will 
cause a softlockup false positive on the guest.

Softlockup should use stolen time that makes use of the guest running 
info would cover both cases

>
> This currently breaks the build for non-x86 architectures but part of what I am
> looking for here is how to go about adding the function stubs for everything
> else.
>
> Eric B Munson (3):
>    Add flag to indicate that a vm was stopped by the host
>    Add functions to check if the host has stopped the vm
>    Add check for suspended vm in softlockup detector
>
>   arch/x86/include/asm/pvclock-abi.h |    1 +
>   arch/x86/include/asm/pvclock.h     |    3 +++
>   arch/x86/kernel/kvmclock.c         |   12 ++++++++++++
>   kernel/watchdog.c                  |   11 +++++++++++
>   4 files changed, 27 insertions(+), 0 deletions(-)
>

