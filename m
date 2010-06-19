Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab0FSFEc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 01:04:32 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:33697 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab0FSFEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 01:04:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Uc6l32WDMTTYbQvzRq82QQMtEgIpiv5orKP4PFC+t226fkph41aIoSInn0YJ9i4Sjv
         eJSyL9fEqsMQgj5FBGKFrhboaB0QmStygJLZYXKT4wKwfSqSBzuzQDZPodchjABJHTLb
         EjPN8ws+DeTavRXqox6fawJao1/ZYGk/0xC5U=
Message-ID: <4C1C4FDE.2090101@gmail.com>
Date: Fri, 18 Jun 2010 22:04:30 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
       zippel@linux-m68k.org, linux-fsdevel@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH 5/6]kernel:module.c variable 'nowarn' set but not used
References: <1276288869-16815-1-git-send-email-justinmattock@gmail.com>	<1276288869-16815-6-git-send-email-justinmattock@gmail.com> <AANLkTilZLOGXpZxHUklA8iHMj8HsJap2BvWMrWMmeyu3@mail.gmail.com>
In-Reply-To: <AANLkTilZLOGXpZxHUklA8iHMj8HsJap2BvWMrWMmeyu3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Also wrong, you removed the creation of the links in sysfs.
>
> The assignment to nowarn was there to avoid another compiler warning,
> as sysfs_create_link() is marked __must_check.

I also went back to this one and made the following changes.. let me 
know if it's wrong etc..

 From 4f45beed80627d2bb32fb021bb6d22d88089557b Mon Sep 17 00:00:00 2001
From: Justin P. Mattock <justinmattock@gmail.com>
Date: Fri, 18 Jun 2010 22:01:07 -0700
Subject: [PATCH 5/5] module.c
  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
  kernel/module.c |    3 +--
  1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 8c6b428..48fc5c8 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1340,11 +1340,10 @@ static void add_usage_links(struct module *mod)
  {
  #ifdef CONFIG_MODULE_UNLOAD
  	struct module_use *use;
-	int nowarn;

  	mutex_lock(&module_mutex);
  	list_for_each_entry(use, &mod->target_list, target_list) {
-		nowarn = sysfs_create_link(use->target->holders_dir,
+		sysfs_create_link(use->target->holders_dir,
  					   &mod->mkobj.kobj, mod->name);
  	}
  	mutex_unlock(&module_mutex);
-- 
1.7.1.rc1.21.gf3bd6

if it looks good, then I can resend it out.

Justin P. Mattock
