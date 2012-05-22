Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816Ab2EVDjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 23:39:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60168 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759752Ab2EVDjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 23:39:41 -0400
Date: Mon, 21 May 2012 20:39:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: James Borum <james.borum@gmail.com>
cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: v3.4 will not compile
In-Reply-To: <CAGFGw3m_aTYv7hGYVQAajoQJ5nD7jE8iO9VdjFtQZcA72kKPew@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205212038100.13522@chino.kir.corp.google.com>
References: <CAGFGw3m_aTYv7hGYVQAajoQJ5nD7jE8iO9VdjFtQZcA72kKPew@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012, James Borum wrote:

> fs/built-in.o: In function `gfs2_lock':
> file.c:(.text+0x3d7689): undefined reference to `dlm_posix_lock'
> file.c:(.text+0x3d76c8): undefined reference to `dlm_posix_unlock'
> file.c:(.text+0x3d76e8): undefined reference to `dlm_posix_get'
> fs/built-in.o: In function `gdlm_cancel':
> lock_dlm.c:(.text+0x3e9e75): undefined reference to `dlm_unlock'
> fs/built-in.o: In function `gdlm_lock':
> lock_dlm.c:(.text+0x3ea082): undefined reference to `dlm_lock'
> fs/built-in.o: In function `gdlm_unmount':
> lock_dlm.c:(.text+0x3ea60e): undefined reference to `dlm_release_lockspace'
> fs/built-in.o: In function `control_unlock':
> lock_dlm.c:(.text+0x3ea7dd): undefined reference to `dlm_unlock'
> fs/built-in.o: In function `sync_lock':
> lock_dlm.c:(.text+0x3ea920): undefined reference to `dlm_lock'
> fs/built-in.o: In function `gdlm_put_lock':
> lock_dlm.c:(.text+0x3eb1fc): undefined reference to `dlm_unlock'
> fs/built-in.o: In function `gdlm_mount':
> lock_dlm.c:(.text+0x3eb5ad): undefined reference to `dlm_new_lockspace'
> lock_dlm.c:(.text+0x3eb869): undefined reference to `dlm_unlock'
> lock_dlm.c:(.text+0x3eb8d1): undefined reference to `dlm_release_lockspace'
> make: *** [.tmp_vmlinux1] Error 1

I'm suspecting you have CONFIG_DLM=m while CONFIG_GFS2_FS=y.  Seems like 
we'll need to require CONFIG_DLM to be built-in in such a configuration?

Signed-off-by: David Rientjes <rientjes@google.com>
---
diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -26,7 +26,7 @@ config GFS2_FS
 config GFS2_FS_LOCKING_DLM
 	bool "GFS2 DLM locking"
 	depends on (GFS2_FS!=n) && NET && INET && (IPV6 || IPV6=n) && \
-		HOTPLUG && DLM && CONFIGFS_FS && SYSFS
+		HOTPLUG && (DLM=y) && CONFIGFS_FS && SYSFS
 	help
 	  Multiple node locking module for GFS2
 
