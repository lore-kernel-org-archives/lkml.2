Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab2AJKbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:31:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab2AJKbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:31:14 -0500
Message-ID: <4F0C1369.9070607@redhat.com>
Date: Tue, 10 Jan 2012 12:31:05 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: stephan.baerwolf@tu-ilmenau.de
CC: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: KVM guest-kernel panics double fault
References: <4EFBC973.1040905@tu-ilmenau.de> <4EFC3B17.1040601@redhat.com> <4F09001D.1050701@tu-ilmenau.de> <4F096E26.4090201@redhat.com> <4F0C0EBB.3090506@tu-ilmenau.de>
In-Reply-To: <4F0C0EBB.3090506@tu-ilmenau.de>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2012 12:11 PM, Stephan Bärwolf wrote:
> Hello.
>
> Thank you for your lots of information, they helped very much -
> especially debugging...
>
> > The third parameter is actually ecx
> (ebx was actually a typing...  ...of course ecx!)
>
> > The emulator is written to be independent of the rest of kvm, using
> > emul_to_vcpu() undoes that.  If you need access to more vpcu internals,
> > add more function pointers to struct x86_emulate_ops.
> I prepare/adapt everything to the mentioned styles/policy.
> (I'll insert 2 additional ops for getting "cpuid" and "id of vcpu"...)

What do you mean by "id of vcpu"?

>
> > Please post patches separately, not as attachments to a single email. 
> > See Documentation/SubmittingPatches.
> One thing, which is not fully clear to me: Where exactly should I post
> the patches?
> Also to/in this mail/group as an empty mail (containing the patch as
> text-body) per patch?
> Or all (3 patches) at once?

One patch per email, with a cover letter.  Git can help you format and
send them:

  # format three patches, with a cover letter:
  $ git format-patch -3 --cover-letter -n -o patches
  # edit the cover letter:
  $ vi patches/0000-cover-letter-patch
  # post them:
  $ git send-email --to kvm@vger.kernel.org patches/*.patch



-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

