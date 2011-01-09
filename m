Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab1AII24 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 03:28:56 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:34795 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab1AII2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 03:28:54 -0500
Date: Sun, 9 Jan 2011 09:28:51 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux arch <linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Guan Xuetao <guanxuetao@mprc.pku.edu.cn>,
        Michal Marek <mmarek@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [RFC v2] kbuild: generic support for asm-generic
Message-ID: <20110109082851.GA10463@merkur.ravnborg.org>
References: <20110108130302.GA21698@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110108130302.GA21698@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 08, 2011 at 02:03:02PM +0100, Sam Ravnborg wrote:
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

Based on feedback from Stephen, Guang and Arnd here
is a new patchset supporting generic headers.

Changes since v2:
- Fix spelling miss in LINUXINCLUDE (Stephen)
- Properly delete file with mrproper (Guang)
- Fixed support for headers that are not exported (Guang)
- New way to list files used from the generic set (Arnd)

We now list which files are sued from the generic set in:
arch/$(ARCH)/include/asm/Kbuild like this:

    generic-y += termios.h

	Sam
