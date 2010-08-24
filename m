Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934190Ab0HXX31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:29:27 -0400
Received: from kroah.org ([198.145.64.141]:40568 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932977Ab0HXW7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:59:35 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:18 2010
Message-Id: <20100824224218.085556900@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:42:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Beulich <jbeulich@novell.com>, Sam Ravnborg <sam@ravnborg.org>,
        Michal Marek <mmarek@suse.cz>
Subject: [70/91] fixes for using make 3.82
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

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
@@ -141,7 +141,7 @@ fw-shipped-$(CONFIG_YAM) += yam/1200.bin
 fw-shipped-all := $(fw-shipped-y) $(fw-shipped-m) $(fw-shipped-)
 
 # Directories which we _might_ need to create, so we have a rule for them.
-firmware-dirs := $(sort $(patsubst %,$(objtree)/$(obj)/%/,$(dir $(fw-external-y) $(fw-shipped-all))))
+firmware-dirs := $(sort $(addprefix $(objtree)/$(obj)/,$(dir $(fw-external-y) $(fw-shipped-all))))
 
 quiet_cmd_mkdir = MKDIR   $(patsubst $(objtree)/%,%,$@)
       cmd_mkdir = mkdir -p $@
--- a/scripts/mkmakefile
+++ b/scripts/mkmakefile
@@ -44,7 +44,9 @@ all:
 
 Makefile:;
 
-\$(all) %/: all
+\$(all): all
 	@:
 
+%/: all
+	@:
 EOF


