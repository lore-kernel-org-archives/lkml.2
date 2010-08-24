Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab0HXWrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:47:42 -0400
Received: from kroah.org ([198.145.64.141]:59799 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756296Ab0HXWri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:47:38 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:18:20 2010
Message-Id: <20100824221820.503195975@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:16:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Beulich <jbeulich@novell.com>, Sam Ravnborg <sam@ravnborg.org>,
        Michal Marek <mmarek@suse.cz>
Subject: [5/8] fixes for using make 3.82
In-Reply-To: <20100824224631.GA5458@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1318
Lines: 44

From: Jan Beulich <JBeulich@novell.com>

commit 3c955b407a084810f57260d61548cc92c14bc627 upstream.

It doesn't like pattern and explicit rules to be on the same line,
and it seems to be more picky when matching file (or really directory)
names with different numbers of trailing slashes.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Andrew Benton <b3nton@gmail.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 firmware/Makefile  |    2 +-
 scripts/mkmakefile |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -75,7 +75,7 @@ fw-shipped-$(CONFIG_VIDEO_CPIA2) += cpia
 fw-shipped-all := $(fw-shipped-y) $(fw-shipped-m) $(fw-shipped-)
 
 # Directories which we _might_ need to create, so we have a rule for them.
-firmware-dirs := $(sort $(patsubst %,$(objtree)/$(obj)/%/,$(dir $(fw-external-y) $(fw-shipped-all))))
+firmware-dirs := $(sort $(addprefix $(objtree)/$(obj)/,$(dir $(fw-external-y) $(fw-shipped-all))))
 
 quiet_cmd_mkdir = MKDIR   $(patsubst $(objtree)/%,%,$@)
       cmd_mkdir = mkdir -p $@
--- a/scripts/mkmakefile
+++ b/scripts/mkmakefile
@@ -42,7 +42,9 @@ all:
 
 Makefile:;
 
-\$(all) %/: all
+\$(all): all
 	@:
 
+%/: all
+	@:
 EOF


