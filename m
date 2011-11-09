Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965737Ab1KJDp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:45:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965430Ab1KJDpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:45:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:02 2011
Message-Id: <20111109213202.817730007@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Michal Marek <mmarek@suse.cz>
Subject: [203/264] kbuild: Fix help text not displayed in choice option.
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

commit 3f198dfee49d2e9c30583c62b0c79286c78c7b44 upstream.

Help text under choice menu is never displayed because it does not have
symbol name associated with it, however many kconfigs have help text
under choice, assuming that it will be displayed when user selects help.
for example in Kconfig if we have:
choice
        prompt "Choice"
        ---help---
           HELP TEXT ...

config A
        bool "A"

config B
        bool "B"

endchoice

Without this patch "HELP TEXT" is not displayed when user selects help
option when "Choice" is highlighted from menuconfig or xconfig or
gconfig.

This patch changes the logic in menu_get_ext_help to display help for
cases which dont have symbol names like choice.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Reviewed-by: Stuart Menefy <stuart.menefy@st.com>
Reviewed-by: Arnaud Lacombe <lacombar@gmail.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 scripts/kconfig/menu.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -597,11 +597,10 @@ void menu_get_ext_help(struct menu *menu
 	struct symbol *sym = menu->sym;
 
 	if (menu_has_help(menu)) {
-		if (sym->name) {
+		if (sym->name)
 			str_printf(help, "%s%s:\n\n", CONFIG_, sym->name);
-			str_append(help, _(menu_get_help(menu)));
-			str_append(help, "\n");
-		}
+		str_append(help, _(menu_get_help(menu)));
+		str_append(help, "\n");
 	} else {
 		str_append(help, nohelp_text);
 	}


