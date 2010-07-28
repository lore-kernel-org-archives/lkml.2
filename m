Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab0G1PqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 11:46:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136Ab0G1PqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 11:46:23 -0400
MIME-Version: 1.0
In-Reply-To: <tip-113fc5a6e8c2288619ff7e8187a6f556b7e0d372@git.kernel.org>
References: <4C4F7277.8050306@zytor.com> <tip-113fc5a6e8c2288619ff7e8187a6f556b7e0d372@git.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Jul 2010 08:45:30 -0700
Message-ID: <AANLkTikAmaDPji-TVDarmG1yD=fwbffcsmEU=YEuP+8r@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86: Add memory modify constraints to xchg() and 
	cmpxchg()
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, glommer@redhat.com,
        alan@lxorguk.ukuu.org.uk, zamsden@redhat.com, stable@kernel.org,
        mtosatti@redhat.com, gregkh@suse.de, peter@palfrader.org,
        tglx@linutronix.de, avi@redhat.com
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 10:33 PM, tip-bot for H. Peter Anvin
<hpa@zytor.com> wrote:
>
> x86: Add memory modify constraints to xchg() and cmpxchg()

Ack. I assume this doesn't really change the code generated? At least
not with a gcc that honors the whole memory clobber thing properly?

I also suspect that we can/should get rid of the __xg() thing - it was
there just to make sure gcc didn't see the memory read as a single
word and tried to optimize it. With the "+m" it probably doesn't
matter any more (don't know if it ever did)

               Linus
