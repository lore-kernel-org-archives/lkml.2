Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab1BZAov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 19:44:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933088Ab1BZAom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 19:44:42 -0500
Message-ID: <4D684CF6.30002@suse.com>
Date: Fri, 25 Feb 2011 19:44:38 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH 2/2] kconfig: Use /proc/config.gz as a configuration source
References: <4D671556.80607@suse.com> <20110225060706.GA12723@merkur.ravnborg.org>
In-Reply-To: <20110225060706.GA12723@merkur.ravnborg.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch uses the type handlers to add /proc/config.gz as a configuration
 source when 'make oldconfig' is used with a missing .config

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -26,6 +26,7 @@ config DEFCONFIG_LIST
 	depends on !UML
 	option defconfig_list
 	default "/lib/modules/$UNAME_RELEASE/.config"
+	default "/proc/config.gz"
 	default "/etc/kernel-config"
 	default "/boot/config-$UNAME_RELEASE"
 	default "$ARCH_DEFCONFIG"

-- 
Jeff Mahoney
SUSE Labs
