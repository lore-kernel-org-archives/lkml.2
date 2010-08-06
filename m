Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964839Ab0HFSEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:04:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964829Ab0HFSEG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:04:06 -0400
MIME-Version: 1.0
In-Reply-To: <4C5C4A23.6070006@zytor.com>
References: <201008052037.o75KbxSS022005@hera.kernel.org> <AANLkTimZF5U-AmD6200gnTuNzX5nUqVqEo_NmiH3rz5n@mail.gmail.com> 
	<4C5C4A23.6070006@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Aug 2010 10:56:00 -0700
Message-ID: <AANLkTikrCBdK6e75aZSv8AvKE31DdJnE53hGXR=uN9TE@mail.gmail.com>
Subject: Re: [GIT PULL] x86/asm for 2.6.36
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, stable@kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Avi Kivity <avi@redhat.com>,
        Brian Gerst <brgerst@gmail.com>, Glauber Costa <glommer@redhat.com>,
        Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Jeff Dike <jdike@addtoit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Palfrader <peter@palfrader.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zachary Amsden <zamsden@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 6, 2010 at 10:45 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> It's worth noting that in this particular case the code itself looks
> like this:
>
>        set_64bit((unsigned long *)&irte->low, irte_modified->low);
>        set_64bit((unsigned long *)&irte->high, irte_modified->high);
>
> ... where the existing cast is there because irte->low and irte->high
> are types __u64.  In other words, with the "more logical" u64 prototype
> the casts should just get removed.

Ok, right you are. I'll just remove the casts, since that makes the
code look better. Maybe it will cause warnings on some other plaform,
but I do agree that maybe the right thing to do is to just say
"set_64bit() should have taken a u64 * to begin with".

> On the other hand I should have seen this sooner, obviously.

Yeah, I didn't look at the code, I just reacted to "hmm, this results
in new warnings, not good".

             Linus
