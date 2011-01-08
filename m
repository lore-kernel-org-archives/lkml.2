Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab1AHUxs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 15:53:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49152 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1AHUxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 15:53:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC] kbuild: generic support for asm-generic
Date: Sat, 8 Jan 2011 21:53:31 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-kbuild" <linux-kbuild@vger.kernel.org>,
        linux arch <linux-arch@vger.kernel.org>,
        Guan Xuetao <guanxuetao@mprc.pku.edu.cn>,
        Michal Marek <mmarek@suse.cz>
References: <20110108130302.GA21698@merkur.ravnborg.org>
In-Reply-To: <20110108130302.GA21698@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101082153.31837.arnd@arndb.de>
X-Provags-ID: V02:K0:juGB2/kunBphPblnkvovphpADhYkirbab9/AiFvlWZ8
 d499zZmmeo09u7A+8Nsomn/ILQOXCDtgMBjz9KeN6QpL3OBR0i
 RbhAAy/1qb0ESf0dPd9YPfuO30icQD7emkoRjYYNEPqWR9XTNF
 wT+SEKYDm+fFE6afj1agitaJeElGIrUoaqXDLLQZ+tEGIG9I7W
 RHqBx2QjBC7fB3AKhkk1Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 January 2011, Sam Ravnborg wrote:
> Hi Arnd et all.
> 
> This is my second attempt to provide generic support for
> architectures that use existing headers from asm-generic.
> 
> With this kbuild will read the file: arch/$ARCH/include/asm-generic
> 
> For each file listed in this file a wrapper is generated in
> arch/$ARCH/inclue/generated/asm/
> 
> The patch include support so headers_install works.
> 
> The inspiration came from the unicore32 patchset,
> but I redid this to make it more general.
> 
> I will follow-up with two patches.
> One that implment the functionality.
> A second that convert two headers in x86 to use the
> new asm-generic stuff (only as an example).

Very nice patch!

This is something I'd certainly like to see upstream, and you made
a good point about keeping it seperate from the unicore32 submission.

One detail I don't like too much is that you now have two different
formats for specifying lists of headers to do something with.

Instead of the new arch/*/include/asm-generic file, how about listing
all files that are actually provided by the architecture as "header-y"
in arch/*/include/asm/Kbuild, and listing all files as something
else in include/asm-generic/Kbuild and include/asm-generic/Kbuild.asm?

	Arnd
