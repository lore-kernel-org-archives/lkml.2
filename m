Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab2AJMeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 07:34:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453Ab2AJMeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 07:34:20 -0500
Message-ID: <4F0C3044.7050307@redhat.com>
Date: Tue, 10 Jan 2012 14:34:12 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: stephan.baerwolf@tu-ilmenau.de
CC: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: KVM guest-kernel panics double fault
References: <4EFBC973.1040905@tu-ilmenau.de> <4EFC3B17.1040601@redhat.com> <4F09001D.1050701@tu-ilmenau.de> <4F096E26.4090201@redhat.com> <4F0C0EBB.3090506@tu-ilmenau.de> <4F0C1369.9070607@redhat.com> <4F0C2C4E.3000703@tu-ilmenau.de>
In-Reply-To: <4F0C2C4E.3000703@tu-ilmenau.de>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2012 02:17 PM, Stephan Bärwolf wrote:
> Hi, me again.
>
> Thank you for your instructions, I will send the patch right after this
> mail.
>
> On 01/10/12 11:31, Avi Kivity wrote:
> >> I prepare/adapt everything to the mentioned styles/policy.
> >> (I'll insert 2 additional ops for getting "cpuid" and "id of vcpu"...)
> > What do you mean by "id of vcpu"?
> I mean the number of the corresponding vcpu.
> (So mostly "vcpu->vcpu_id" ...)
> It is necessary for "pr_err_ratelimited"-complains, if cpuid-vendor is
> unknown ...
> ("Jan 10 12:14:55 thinkrat kernel: [ 4476.484359] kvm: 15680: cpu0
> unknown vendor - assuming intel")

It isn't worthwhile - just don't print the vcpu number (the task ID
contains enough information, and anyway this should be rare to the point
of never ever happening)

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

