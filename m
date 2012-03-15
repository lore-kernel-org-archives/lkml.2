Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161406Ab2COUSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:18:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161119Ab2COUSr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:18:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4F608A15.9030609@snapgear.com>
References: <4F608A15.9030609@snapgear.com> <20120312233602.13888.27659.stgit@warthog.procyon.org.uk> <20120312233816.13888.142.stgit@warthog.procyon.org.uk>
To: Greg Ungerer <gerg@snapgear.com>
Cc: dhowells@redhat.com, paul.gortmaker@windriver.com, hpa@zytor.com,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de, linux-m68k@vger.kernel.org
Subject: Re: [PATCH 13/35] Disintegrate asm/system.h for M68K [ver #2]
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Thu, 15 Mar 2012 20:18:33 +0000
Message-ID: <7100.1331842713@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Ungerer <gerg@snapgear.com> wrote:

> This breaks compilation for m68k targets with:
> 
>   CC      net/ipv4/ip_input.o
> In file included from
> /home/gerg/new-wave.320/linux-3.x/arch/m68k/include/asm/system.h:3:0,
>                  from net/ipv4/ip_input.c:116:
> /home/gerg/new-wave.320/linux-3.x/arch/m68k/include/asm/cmpxchg.h: In function
> ‘__xchg’:
> /home/gerg/new-wave.320/linux-3.x/arch/m68k/include/asm/cmpxchg.h:33:3: error:
> implicit declaration of function ‘BUG’
> 
> The old system.h included linux/kernel.h which includes asm/bug.h.
> Just including asm/bug.h here in cmpxchg.h is not enough to fix it.
> If you include linux/kernel.h though it compiles cleanly.

Which targets, btw?

David
