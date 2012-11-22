Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab2KVS6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:58:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab2KVS6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:09 -0500
Message-ID: <50AE62E9.3000602@zytor.com>
Date: Thu, 22 Nov 2012 09:37:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Daniel Kiper <daniel.kiper@oracle.com>, andrew.cooper3@citrix.com,
        jbeulich@suse.com, konrad.wilk@oracle.com, mingo@redhat.com,
        tglx@linutronix.de, x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH v2 01/11] kexec: introduce kexec_ops struct
References: <1353423893-23125-1-git-send-email-daniel.kiper@oracle.com> <1353423893-23125-2-git-send-email-daniel.kiper@oracle.com> <87lidwtego.fsf@xmission.com> <20121121105221.GA2925@host-192-168-1-59.local.net-space.pl> <87txshx28b.fsf@xmission.com>
In-Reply-To: <87txshx28b.fsf@xmission.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2012 04:15 AM, Eric W. Biederman wrote:
>
> Let me be clear.  kexec_ops as you have implemented it is absolutely
> unacceptable.
>
> Your kexec_ops is not an abstraction but a hack that enshrines in stone
> implementation details.
>

This is the kind of stuff that is absolutely endemic to the Xen 
endeavour, and which is why Xen is such a disease.  The design principle 
seems to have been "hey, let's go and replace random Linux kernel 
internals with our own stuff, and make them ABIs, so that they can never 
change.  Oh, and let's not bother documenting the constraints we're 
imposing, that might make the code manageable."

I actually talked to Ian Jackson at LCE, and mentioned among other 
things the bogosity of requiring a PUD page for three-level paging in 
Linux -- a bogosity which has spread from Xen into native.  It's a page 
wasted for no good reason, since it only contains 32 bytes worth of 
data, *inherently*.  Furthermore, contrary to popular belief, it is 
*not* pa page table per se.

Ian told me: "I didn't know we did that, and we shouldn't have to." 
Here we have suffered this overhead for at least six years, because *XEN 
FUCKED UP AND NOONE ELSE HAD ANY WAY OF KNOWING THAT*.

Now we know that it can "maybe"(!!!) be fixed, if we are willing to 
spend time working on a dying platform, whereas we have already suffered 
the damage during the height of its importance.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

