Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934295Ab1ESScs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:32:48 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59790 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934356Ab1ESScn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:32:43 -0400
X-Sasl-enc: jtqQV6W8ZF9oWpmxhn0I2WefcS3RDM2METZuWclGqjR+ 1305829962
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:31:27 2011
Message-Id: <20110519183127.022606335@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:30:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Beulich <jbeulich@novell.com>, Sam Ravnborg <sam@ravnborg.org>,
        Michal Marek <mmarek@suse.cz>, John Kacur <jkacur@redhat.com>
Subject: [14/24] fixes for using make 3.82
In-Reply-To: <20110519182446.GA23751@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1366
Lines: 45

From: Jan Beulich <JBeulich@novell.com>

commit 3c955b407a084810f57260d61548cc92c14bc627 upstream.

It doesn't like pattern and explicit rules to be on the same line,
and it seems to be more picky when matching file (or really directory)
names with different numbers of trailing slashes.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Andrew Benton <b3nton@gmail.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: John Kacur <jkacur@redhat.com>
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


