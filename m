Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab1AIT1g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 14:27:36 -0500
Received: from pqueuea.post.tele.dk ([193.162.153.9]:41068 "EHLO
	pqueuea.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab1AIT1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 14:27:34 -0500
Date: Sun, 9 Jan 2011 20:27:07 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux arch <linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Guan Xuetao <guanxuetao@mprc.pku.edu.cn>,
        Michal Marek <mmarek@suse.cz>
Subject: [RFC v3] kbuild: generic support for asm-generic
Message-ID: <20110109192707.GA12387@merkur.ravnborg.org>
References: <20110108130302.GA21698@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110108130302.GA21698@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal, Arnd et all.
 
This is my second attempt to provide generic support for
architectures that use existing headers from asm-generic.

@Michal - I consider this ready for you to review / apply.
I would prefer if this patch could be included in the current
merge window - allowing us to convert archs until next merge window.
As this touches the top-level Makefile in an area that is always
used I suggest to at least let i cook in -next for a few days first.

It was inspired by unicore32 - but I have requested Guang _not_
to convert unicore32 to avoid a dependency on this patch.

The patch description:

There is an increasing amount of header files
shared between individual architectures in asm-generic.
To avoid a lot of dummy wrapper files that just
include the corresponding file in asm-generic provide
some basic support in kbuild for this.

With the following patch an architecture can maintain
a list of files in the file arch/$(ARCH)/include/asm/Kbuild

To use a generic file just add:

        generic-y += <name-of-header-file.h>

For each file listed kbuild will generate the necessary
wrapper in arch/$(ARCH)/include/generated/asm.

When installing userspace headers a wrapper is likewise created.

The original inspiration for this came from the unicore32
patchset - although is used a different method.


Changes since v2:
- Fix spelling miss in LINUXINCLUDE (Stephen)
- Properly delete file with mrproper (Guang)
- Fixed support for headers that are not exported (Guang)
- New way to list files used from the generic set (Arnd)

Changes since v3:
- Dropped generic-export.y (from Arnd)
- added check if header is listed as generic but still is present
- fixed "make headers_check"
- updated documentation

I did not include an Reviewed-by / Acked-by from Arnd as
he had not seen the latest iteration in the full.

Diffstat for the patch:
 .gitignore                         |    1 +
 Documentation/kbuild/makefiles.txt |   36 ++++++++++++++++++++++++++++++++++++
 Makefile                           |   15 +++++++++++----
 scripts/Makefile.headersinst       |   18 +++++++++++++++---
 scripts/asm-generic.sh             |   33 +++++++++++++++++++++++++++++++++
 5 files changed, 96 insertions(+), 7 deletions(-)
 create mode 100644 scripts/asm-generic.sh

Sample diffstat when using generic-y for three files in x86:
 arch/x86/include/asm/Kbuild     |    6 ++++++
 arch/x86/include/asm/rtc.h      |    1 -
 arch/x86/include/asm/termbits.h |    1 -
 arch/x86/include/asm/termios.h  |    1 -
 4 files changed, 6 insertions(+), 3 deletions(-)
 delete mode 100644 arch/x86/include/asm/rtc.h
 delete mode 100644 arch/x86/include/asm/termbits.h
 delete mode 100644 arch/x86/include/asm/termios.h

	Sam
