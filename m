Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab0IRI1K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 04:27:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56850 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab0IRI1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 04:27:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: New compat_alloc_user_space() GPLness and fglrx
Date: Sat, 18 Sep 2010 10:26:57 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-next-20100910+; KDE/4.5.1; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <20100918014232.GA17699@khazad-dum.debian.net>
In-Reply-To: <20100918014232.GA17699@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009181026.58002.arnd@arndb.de>
X-Provags-ID: V02:K0:kd9XduqW/YCctutNr7n/CwBsk6dl09ddP3kbHhPzbtA
 cucAQPa/lNJr9JCq5BzTuUG+z02NBbnwDjHPCY2vYYgF0Mpr6B
 DWYfcoAjYXfVCaN8oumWqf4QQZhOLo7cBlqQFYVPhQBUWxcy66
 sRRuSWi74/Wi0VR2W7b020YMiAOorpoax7By23NdvlCSyYttQ0
 k6Skr2z7Lo9GuCh39GW0Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 September 2010 03:42:32 Henrique de Moraes Holschuh wrote:
> promotes compat_alloc_user_space() to EXPORT_SYMBOL_GPL, and moves it from
> asm/compat.h to linux/compat.h.
> 
> This breaks AMD/ATI's proprietary fglrx GPU driver, which wants to use
> compat_alloc_user_space(), and expects to find it in asm/compat.h.
> 
> Fixing this on the fglrx side is easy enough, one can simply audit the two
> or three call sites in the fglrx glue and make sure they can use
> arch_compat_alloc_user_space() safely.
> 
> But such a fix doesn't look right.  IMHO, either we don't want any non-GPL
> module touching *_compat_alloc_user_space and compat_alloc_user_space, or it
> would be better to let them use compat_alloc_user_space() in the interest of
> overall security...

Right, don't use arch_compat_alloc_user_space(), that would be worse.

compat_alloc_user_space is still a horrible hack and shouldn't be used
at all if possible. Just fix the code to either not require compat
ioctl handling or split out the common code from the native ioctl
function and pass it a kernel data structure, which you copy from user
space in different ways depending on where you come from.

	Arnd
