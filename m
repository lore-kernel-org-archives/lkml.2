Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab2HAC4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 22:56:30 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:35943 "EHLO
	homiemail-a52.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752871Ab2HAC43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 22:56:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:subject:content-type; q=dns; s=
	shealevy.com; b=JDMZdrRyWUL58c+UuzVHKxa3jwMSZiHgSFKQqtKJnqsqvL6w
	sKlLEN74x+dm5t2ox45UlOga4a3cBcPfTMrjfVvSo54VM0/f0vP9uilDqK3g3pOv
	6wZvWnTq3j75FfTDwZE7yUT1y/OYAl/mB13bVHzTy0U3wXOyLTeAOCEMntk=
Message-ID: <50189ADA.4050009@shealevy.com>
Date: Tue, 31 Jul 2012 22:56:26 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120703 Thunderbird/11.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: [PATCH] Fix firmware installation for images w/o subdirs
Content-Type: multipart/mixed;
 boundary="------------090903070902080200010400"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090903070902080200010400
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On some setups (probably due to too new a GNU Make), firmware
installation fails with
*** No rule to make target `lib/firmware/./', needed by 
`lib/firmware/<file>.fw'.  Stop.
when a file in the top-level firmware/ directory is needed.

Original patch idea by Denys Dmytriyenko, see
http://permalink.gmane.org/gmane.linux.embedded.yocto.meta-ti/27

Signed-off-by: Shea Levy <shea@shealevy.com>
---
  scripts/Makefile.fwinst | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)



--------------090903070902080200010400
Content-Type: text/x-patch;
 name="0001-Fix-firmware-installation-for-images-w-o-subdirs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Fix-firmware-installation-for-images-w-o-subdirs.patch"

diff --git a/scripts/Makefile.fwinst b/scripts/Makefile.fwinst
index 6bf8e87..4d908d1 100644
--- a/scripts/Makefile.fwinst
+++ b/scripts/Makefile.fwinst
@@ -27,7 +27,7 @@ endif
 installed-mod-fw := $(addprefix $(INSTALL_FW_PATH)/,$(mod-fw))
 
 installed-fw := $(addprefix $(INSTALL_FW_PATH)/,$(fw-shipped-all))
-installed-fw-dirs := $(sort $(dir $(installed-fw))) $(INSTALL_FW_PATH)/.
+installed-fw-dirs := $(sort $(dir $(installed-fw))) $(INSTALL_FW_PATH)/./
 
 # Workaround for make < 3.81, where .SECONDEXPANSION doesn't work.
 PHONY += $(INSTALL_FW_PATH)/$$(%) install-all-dirs


--------------090903070902080200010400--
