Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935445Ab1JEWB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 18:01:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:34779 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935355Ab1JEWB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 18:01:58 -0400
Date: Thu, 6 Oct 2011 00:01:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Adrian Bunk <bunk@stusta.de>
cc: Andrew Lutomirski <luto@mit.edu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm00@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [3.1 patch] x86: default to vsyscall=native
In-Reply-To: <20111005214047.GE14406@localhost.pp.htv.fi>
Message-ID: <alpine.LFD.2.02.1110052346080.18778@ionos>
References: <20111005214047.GE14406@localhost.pp.htv.fi>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Oct 2011, Adrian Bunk wrote:

> After upgrading a kernel the existing userspace should just work
> (assuming it did work before ;-) ), but when I upgraded my kernel
> from 3.0.4 to 3.1.0-rc8 a UML instance didn't come up properly.
> 
> dmesg said:
>   linux-2.6.30.1[3800] vsyscall fault (exploit attempt?) ip:ffffffffff600000 cs:33 sp:7fbfb9c498 ax:ffffffffff600000 si:0 di:606790
>   linux-2.6.30.1[3856] vsyscall fault (exploit attempt?) ip:ffffffffff600000 cs:33 sp:7fbfb13168 ax:ffffffffff600000 si:0 di:606790
> 
> Looking throught the changelog I ended up at commit 3ae36655
> ("x86-64: Rework vsyscall emulation and add vsyscall= parameter").
> 
> Linus suggested in https://lkml.org/lkml/2011/8/9/376 to default to 
> vsyscall=native.
> 
> That sounds reasonable to me, and fixes the problem for me.

NAK.

We have way too long listened to people who insisted that we keep all
known security holes open by default for the sake of backwards
compatibility.

Default wants to be restricted and not the other way round. Forcing
people to loosen restrictions makes them aware of the problem. Not
doing so keeps them in the illusion that stuff is just safe to use.

We might need better dmesg output, e.g.

   printk_once("you might run something which requires
   		vsyscall=native, but be aware that you are
		opening a security hole. See Documentation/....")

That's fine, but making the defaults insecure is just ass backwards.

Thanks,

	tglx
