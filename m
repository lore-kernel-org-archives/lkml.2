Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081Ab0I1Qww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:52:52 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:44747 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849Ab0I1Qwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:52:50 -0400
Date: Tue, 28 Sep 2010 16:52:47 +0000 (UTC)
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: Mike Frysinger <vapier@gentoo.org>
cc: libc-ports@sourceware.org, Chris Metcalf <cmetcalf@tilera.com>,
        Arnd Bergmann <arnd@arndb.de>, linasvepstas@gmail.com,
        GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org
Subject: Re: asm-generic/unistd.h and glibc use of NR_ipc
In-Reply-To: <201009281242.57006.vapier@gentoo.org>
Message-ID: <Pine.LNX.4.64.1009281648040.22692@digraph.polyomino.org.uk>
References: <AANLkTi=33kimswSJ1tYsnG-PVs6Z4dVBtnqq65GN8Vxw@mail.gmail.com>
 <201009281040.09728.arnd@arndb.de> <4CA1E809.5010103@tilera.com>
 <201009281242.57006.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010, Mike Frysinger wrote:

> On Tuesday, September 28, 2010 09:05:13 Chris Metcalf wrote:
> > On 9/28/2010 4:40 AM, Arnd Bergmann wrote:
> > > Chris Metcalf is using the generic unistd.h file on the tile architecture
> > > and has a glibc port that should be easily portable to all future
> > > architectures. There are a few of them getting ready to be merged
> > > now (c6x, lm32, nios2, and some people have contacted me privately
> > > for architectures I cannot name).
> 
> c6x lacks a MMU, so i dont see how it could possibly use glibc.  same for 
> lm32.  nios2 at least has an optional MMU, so it'd be usable some of the time.  
> so no, i dont see a generic unistd.h glibc port being useful for them.

A generic port would be useful for new architectures with MMU - but the 
notion that "only rudimentary architecture support in glibc would be 
needed" is mistaken.  Note Chris's figures "another 30-odd files in 
sysdeps/unix/sysv/linux/tile to implement the non-NPTL part of our glibc 
support, plus 50-odd files in sysdeps/tile" - hardly rudimentary.  Those 
seem the right order of magnitude, if larger than the minimum; the Nios II 
port currently has 59 new files in sysdeps directories, most of which I 
expect would still be needed with the generic syscall ABI.

-- 
Joseph S. Myers
joseph@codesourcery.com
