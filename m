Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab2AXUhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 15:37:43 -0500
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:13425 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757030Ab2AXUhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 15:37:41 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAGQVH09tg128/2dsb2JhbABCrjSBBoFyAQEEAR0VASMjBQsIAxguFCUDIROHfAK4IxOIXhkBBgYGBgIEAwYBAwYJBgUHBYJNAgIDBQkOEYNPYwSVHIkriSU
Date: Tue, 24 Jan 2012 21:37:38 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maxim Uvarov <maxim.uvarov@oracle.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        Thomas.Mingarelli@hp.com, dann frazier <dannf@hp.com>
Subject: Re: [PATCH] hpwdt: clean up set_memory_x call for 32 bit
Message-ID: <20120124203738.GA27296@infomag.iguana.be>
References: <1326686570-19303-1-git-send-email-maxim.uvarov@oracle.com> <1326686570-19303-2-git-send-email-maxim.uvarov@oracle.com> <CA+55aFxzfCxwYUcRbSyf+U7nr5GPjH4Qfine_TcY6Oxj8WQrWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFxzfCxwYUcRbSyf+U7nr5GPjH4Qfine_TcY6Oxj8WQrWw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> So I don't know who is supposed to be handling this (Wim?), but the
> patch itself looks suspicious.

I asked Tom to look at Maxim's patch and see what it does. Tom was going to look at the patch and
I'm waiting on feedback from him first. (That's why I din't sent it upstream yet).

> On Sun, Jan 15, 2012 at 8:02 PM, Maxim Uvarov <maxim.uvarov@oracle.com> wrote:
> > -       set_memory_x((unsigned long)bios32_entrypoint, (2 * PAGE_SIZE));
> > +       set_memory_x((unsigned long)bios32_entrypoint & PAGE_MASK, 2);
> 
> If it wasn't page-aligned to begin with, then maybe it needs three pages now?
> 
> > -                               set_memory_x((unsigned long)cru_rom_addr, cru_length);
> > +                               set_memory_x((unsigned long)cru_rom_addr & PAGE_MASK, cru_length >> PAGE_SHIFT);
> 
> Same here. If we align the start address down, we should fix up the
> length. And should we not align the number of pages up?
> 
> In general, a "start/length" conversion to a "page/nr" model needs to be roughly
> 
>    len += start & ~PAGE_MASK;
>    start &= PAGE_MASK;
>    nr_pages = (len + PAGE_SIZE - 1) >> PAGE_SHIFT;
> 
> to do things right. But I don't know where those magic numbers come
> from. Maybe the "2" is already due to the code possibly traversing a
> page boundary, and has already been fixed up. Somebody who knows the
> driver and the requirements should take a look at this.

Valid comments indeed. Tom please take Linus comments with you when you look at the patch.

Dan: I put you in Cc: also so that you can have a look at it also.

Kind regards,
Wim.


