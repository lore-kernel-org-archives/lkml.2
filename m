Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab0I1P7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 11:59:22 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:53001 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab0I1P7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 11:59:21 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Sep 2010 11:59:20 EDT
Date: Tue, 28 Sep 2010 15:52:37 +0000 (UTC)
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: Chris Metcalf <cmetcalf@tilera.com>
cc: Arnd Bergmann <arnd@arndb.de>, linasvepstas@gmail.com,
        linux-kernel@vger.kernel.org, libc-ports@sourceware.org,
        andrew@codesourcery.com
Subject: Re: asm-generic/unistd.h and glibc use of NR_ipc
In-Reply-To: <4CA1E809.5010103@tilera.com>
Message-ID: <Pine.LNX.4.64.1009281537400.22692@digraph.polyomino.org.uk>
References: <AANLkTi=33kimswSJ1tYsnG-PVs6Z4dVBtnqq65GN8Vxw@mail.gmail.com>
 <201009281040.09728.arnd@arndb.de> <4CA1E809.5010103@tilera.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010, Chris Metcalf wrote:

>  (Adding libc-ports to the cc list.)
> 
> On 9/28/2010 4:40 AM, Arnd Bergmann wrote:
> > Chris Metcalf is using the generic unistd.h file on the tile architecture
> > and has a glibc port that should be easily portable to all future
> > architectures. There are a few of them getting ready to be merged
> > now (c6x, lm32, nios2, and some people have contacted me privately
> > for architectures I cannot name).

(Removing libc-alpha as my comments aren't relevant to that list.)

Two of the three seem rather surprising to me as regards glibc ports being 
ready to merge - maybe kernel ports are ready, however, it isn't clear to 
me what (kernel or glibc) the original comment was referring to.

C6X has no MMU so a glibc port isn't a possibility.  There are indeed 
uClibc and GCC ports we will be contributing in due course - but the 
linker support for shared objects is still in development (I contributed 
the static linking binutils support upstream earlier this year) and is 
required for building anything for uClinux userspace for this platform.

As for Nios II, we have a fully functional glibc port at CodeSourcery.  
It is I believe all our own work so there are no legal obstacles to our 
contributing it to the FSF - but upstream contribution would not really be 
useful without the GCC and binutils ports, and those ports (to which we 
added PIC and TLS support among other things) are based on code from 
Altera which is not covered by an FSF copyright assignment, so while the 
code is available we have no current plans for Nios II upstream 
contribution.

http://www.codesourcery.com/sgpp/portal/datasheet?target_arch=Nios+II&target_os=GNU%2FLinux

-- 
Joseph S. Myers
joseph@codesourcery.com
