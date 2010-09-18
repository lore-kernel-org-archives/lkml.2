Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab0IRMmU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 08:42:20 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60745 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753827Ab0IRMmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 08:42:19 -0400
X-Sasl-enc: wBx+Ow6CyFgTffvrGhlGWPQMPPEK1TYM0C/0V+pOO1x7 1284813738
Date: Sat, 18 Sep 2010 09:42:14 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: New compat_alloc_user_space() GPLness and fglrx
Message-ID: <20100918124214.GA31802@khazad-dum.debian.net>
References: <20100918014232.GA17699@khazad-dum.debian.net>
 <201009181026.58002.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009181026.58002.arnd@arndb.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Sep 2010, Arnd Bergmann wrote:
> On Saturday 18 September 2010 03:42:32 Henrique de Moraes Holschuh wrote:
> > promotes compat_alloc_user_space() to EXPORT_SYMBOL_GPL, and moves it from
> > asm/compat.h to linux/compat.h.
> > 
> > This breaks AMD/ATI's proprietary fglrx GPU driver, which wants to use
> > compat_alloc_user_space(), and expects to find it in asm/compat.h.
> > 
> > Fixing this on the fglrx side is easy enough, one can simply audit the two
> > or three call sites in the fglrx glue and make sure they can use
> > arch_compat_alloc_user_space() safely.
> > 
> > But such a fix doesn't look right.  IMHO, either we don't want any non-GPL
> > module touching *_compat_alloc_user_space and compat_alloc_user_space, or it
> > would be better to let them use compat_alloc_user_space() in the interest of
> > overall security...
> 
> Right, don't use arch_compat_alloc_user_space(), that would be worse.
> 
> compat_alloc_user_space is still a horrible hack and shouldn't be used
> at all if possible. Just fix the code to either not require compat
> ioctl handling or split out the common code from the native ioctl
> function and pass it a kernel data structure, which you copy from user
> space in different ways depending on where you come from.

Well, that means ATI needs to mess with the insides of their binary
blob... Anyone knows of a channel to talk to them?  Someone must tell
them about this, I am just an unwilling user of fglrx (R600 support in
the open drivers is nowhere near what I need yet).

Meanwhile, what is the solution?  Keep using (the newly named)
arch_compat_alloc_user_space()?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
