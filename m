Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab1BGQoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 11:44:12 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:56481 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab1BGQoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 11:44:11 -0500
X-Greylist: delayed 1593 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Feb 2011 11:44:11 EST
Date: Mon, 7 Feb 2011 17:17:37 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 11/20] hpfs: move to drivers/staging
In-Reply-To: <1295993854-4971-12-git-send-email-arnd@arndb.de>
Message-ID: <alpine.DEB.1.10.1102071716420.31987@artax.karlin.mff.cuni.cz>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de> <1295993854-4971-12-git-send-email-arnd@arndb.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, I will solve it sometimes, but I am in a mental hospital now.

Mikulas

On Tue, 25 Jan 2011, Arnd Bergmann wrote:

> hpfs has not seen a single patch from its maintainer
> since the start of the git history, and the user base
> seems to be completely gone after the end of OS/2.
> 
> I have tried to keep the file system alive as much
> as possible through the BKL removal, but this its
> time seems to have come. If we can find an actual
> user who is willing to test patches, or even a
> maintainer that can work on the code, it can easily
> be moved back into the main tree.
> 
> If that does not happen, it will get removed from
> the kernel tree after a few releases in staging/.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
> Cc: linux-fsdevel@vger.kernel.org
> ---
>  MAINTAINERS                            |    2 +-
>  drivers/staging/Kconfig                |    2 ++
>  drivers/staging/Makefile               |    1 +
>  {fs => drivers/staging}/hpfs/Kconfig   |    3 +++
>  {fs => drivers/staging}/hpfs/Makefile  |    0
>  drivers/staging/hpfs/TODO              |    5 +++++
>  {fs => drivers/staging}/hpfs/alloc.c   |    0
>  {fs => drivers/staging}/hpfs/anode.c   |    0
>  {fs => drivers/staging}/hpfs/buffer.c  |    0
>  {fs => drivers/staging}/hpfs/dentry.c  |    0
>  {fs => drivers/staging}/hpfs/dir.c     |    0
>  {fs => drivers/staging}/hpfs/dnode.c   |    0
>  {fs => drivers/staging}/hpfs/ea.c      |    0
>  {fs => drivers/staging}/hpfs/file.c    |    0
>  {fs => drivers/staging}/hpfs/hpfs.h    |    0
>  {fs => drivers/staging}/hpfs/hpfs_fn.h |    0
>  {fs => drivers/staging}/hpfs/inode.c   |    0
>  {fs => drivers/staging}/hpfs/map.c     |    0
>  {fs => drivers/staging}/hpfs/name.c    |    0
>  {fs => drivers/staging}/hpfs/namei.c   |    0
>  {fs => drivers/staging}/hpfs/super.c   |    0
>  fs/Kconfig                             |    1 -
>  fs/Makefile                            |    1 -
>  23 files changed, 12 insertions(+), 3 deletions(-)
>  rename {fs => drivers/staging}/hpfs/Kconfig (85%)
>  rename {fs => drivers/staging}/hpfs/Makefile (100%)
>  create mode 100644 drivers/staging/hpfs/TODO
>  rename {fs => drivers/staging}/hpfs/alloc.c (100%)
>  rename {fs => drivers/staging}/hpfs/anode.c (100%)
>  rename {fs => drivers/staging}/hpfs/buffer.c (100%)
>  rename {fs => drivers/staging}/hpfs/dentry.c (100%)
>  rename {fs => drivers/staging}/hpfs/dir.c (100%)
>  rename {fs => drivers/staging}/hpfs/dnode.c (100%)
>  rename {fs => drivers/staging}/hpfs/ea.c (100%)
>  rename {fs => drivers/staging}/hpfs/file.c (100%)
>  rename {fs => drivers/staging}/hpfs/hpfs.h (100%)
>  rename {fs => drivers/staging}/hpfs/hpfs_fn.h (100%)
>  rename {fs => drivers/staging}/hpfs/inode.c (100%)
>  rename {fs => drivers/staging}/hpfs/map.c (100%)
>  rename {fs => drivers/staging}/hpfs/name.c (100%)
>  rename {fs => drivers/staging}/hpfs/namei.c (100%)
>  rename {fs => drivers/staging}/hpfs/super.c (100%)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 246ee22..fe5ca5f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3009,7 +3009,7 @@ HPFS FILESYSTEM
>  M:	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
>  W:	http://artax.karlin.mff.cuni.cz/~mikulas/vyplody/hpfs/index-e.cgi
>  S:	Maintained
> -F:	fs/hpfs/
> +F:	drivers/staging/hpfs/
>  
>  HSO 3G MODEM DRIVER
>  M:	Jan Dumon <j.dumon@option.com>
> diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
> index 6ac0418..9fc5aa6 100644
> --- a/drivers/staging/Kconfig
> +++ b/drivers/staging/Kconfig
> @@ -175,5 +175,7 @@ source "drivers/staging/cptm1217/Kconfig"
>  
>  source "drivers/staging/ste_rmi4/Kconfig"
>  
> +source "drivers/staging/hpfs/Kconfig"
> +
>  endif # !STAGING_EXCLUDE_BUILD
>  endif # STAGING
> diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
> index a834d2e..878f381 100644
> --- a/drivers/staging/Makefile
> +++ b/drivers/staging/Makefile
> @@ -68,3 +68,4 @@ obj-$(CONFIG_SND_INTEL_SST)		+= intel_sst/
>  obj-$(CONFIG_SPEAKUP)	+= speakup/
>  obj-$(CONFIG_TOUCHSCREEN_CLEARPAD_TM1217)	+= cptm1217/
>  obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4)	+= ste_rmi4/
> +obj-$(CONFIG_HPFS_FS)		+= hpfs/
> diff --git a/fs/hpfs/Kconfig b/drivers/staging/hpfs/Kconfig
> similarity index 85%
> rename from fs/hpfs/Kconfig
> rename to drivers/staging/hpfs/Kconfig
> index 73476c1..f979319 100644
> --- a/fs/hpfs/Kconfig
> +++ b/drivers/staging/hpfs/Kconfig
> @@ -11,5 +11,8 @@ config HPFS_FS
>  	  option in order to be able to read them. Read
>  	  <file:Documentation/filesystems/hpfs.txt>.
>  
> +	  The HPFS code is about to get removed from the kernel and is no
> +	  longer supported on SMP or PREEMPT kernels.
> +
>  	  To compile this file system support as a module, choose M here: the
>  	  module will be called hpfs.  If unsure, say N.
> diff --git a/fs/hpfs/Makefile b/drivers/staging/hpfs/Makefile
> similarity index 100%
> rename from fs/hpfs/Makefile
> rename to drivers/staging/hpfs/Makefile
> diff --git a/drivers/staging/hpfs/TODO b/drivers/staging/hpfs/TODO
> new file mode 100644
> index 0000000..576a01c
> --- /dev/null
> +++ b/drivers/staging/hpfs/TODO
> @@ -0,0 +1,5 @@
> +HPFS seems to have no remaining users, and it is getting
> +increasingly hard to maintain. It will be removed in one
> +of the next kernel releases unless someone puts effort
> +into fixing the locking. The new hpfs_lock that replaces
> +the BKL has not been tested.
> diff --git a/fs/hpfs/alloc.c b/drivers/staging/hpfs/alloc.c
> similarity index 100%
> rename from fs/hpfs/alloc.c
> rename to drivers/staging/hpfs/alloc.c
> diff --git a/fs/hpfs/anode.c b/drivers/staging/hpfs/anode.c
> similarity index 100%
> rename from fs/hpfs/anode.c
> rename to drivers/staging/hpfs/anode.c
> diff --git a/fs/hpfs/buffer.c b/drivers/staging/hpfs/buffer.c
> similarity index 100%
> rename from fs/hpfs/buffer.c
> rename to drivers/staging/hpfs/buffer.c
> diff --git a/fs/hpfs/dentry.c b/drivers/staging/hpfs/dentry.c
> similarity index 100%
> rename from fs/hpfs/dentry.c
> rename to drivers/staging/hpfs/dentry.c
> diff --git a/fs/hpfs/dir.c b/drivers/staging/hpfs/dir.c
> similarity index 100%
> rename from fs/hpfs/dir.c
> rename to drivers/staging/hpfs/dir.c
> diff --git a/fs/hpfs/dnode.c b/drivers/staging/hpfs/dnode.c
> similarity index 100%
> rename from fs/hpfs/dnode.c
> rename to drivers/staging/hpfs/dnode.c
> diff --git a/fs/hpfs/ea.c b/drivers/staging/hpfs/ea.c
> similarity index 100%
> rename from fs/hpfs/ea.c
> rename to drivers/staging/hpfs/ea.c
> diff --git a/fs/hpfs/file.c b/drivers/staging/hpfs/file.c
> similarity index 100%
> rename from fs/hpfs/file.c
> rename to drivers/staging/hpfs/file.c
> diff --git a/fs/hpfs/hpfs.h b/drivers/staging/hpfs/hpfs.h
> similarity index 100%
> rename from fs/hpfs/hpfs.h
> rename to drivers/staging/hpfs/hpfs.h
> diff --git a/fs/hpfs/hpfs_fn.h b/drivers/staging/hpfs/hpfs_fn.h
> similarity index 100%
> rename from fs/hpfs/hpfs_fn.h
> rename to drivers/staging/hpfs/hpfs_fn.h
> diff --git a/fs/hpfs/inode.c b/drivers/staging/hpfs/inode.c
> similarity index 100%
> rename from fs/hpfs/inode.c
> rename to drivers/staging/hpfs/inode.c
> diff --git a/fs/hpfs/map.c b/drivers/staging/hpfs/map.c
> similarity index 100%
> rename from fs/hpfs/map.c
> rename to drivers/staging/hpfs/map.c
> diff --git a/fs/hpfs/name.c b/drivers/staging/hpfs/name.c
> similarity index 100%
> rename from fs/hpfs/name.c
> rename to drivers/staging/hpfs/name.c
> diff --git a/fs/hpfs/namei.c b/drivers/staging/hpfs/namei.c
> similarity index 100%
> rename from fs/hpfs/namei.c
> rename to drivers/staging/hpfs/namei.c
> diff --git a/fs/hpfs/super.c b/drivers/staging/hpfs/super.c
> similarity index 100%
> rename from fs/hpfs/super.c
> rename to drivers/staging/hpfs/super.c
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 3db9caa..5a54574 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -184,7 +184,6 @@ source "fs/squashfs/Kconfig"
>  source "fs/freevxfs/Kconfig"
>  source "fs/minix/Kconfig"
>  source "fs/omfs/Kconfig"
> -source "fs/hpfs/Kconfig"
>  source "fs/qnx4/Kconfig"
>  source "fs/romfs/Kconfig"
>  source "fs/sysv/Kconfig"
> diff --git a/fs/Makefile b/fs/Makefile
> index a7f7cef..c920ca9 100644
> --- a/fs/Makefile
> +++ b/fs/Makefile
> @@ -90,7 +90,6 @@ obj-$(CONFIG_NLS)		+= nls/
>  obj-$(CONFIG_SYSV_FS)		+= sysv/
>  obj-$(CONFIG_CIFS)		+= cifs/
>  obj-$(CONFIG_NCP_FS)		+= ncpfs/
> -obj-$(CONFIG_HPFS_FS)		+= hpfs/
>  obj-$(CONFIG_NTFS_FS)		+= ntfs/
>  obj-$(CONFIG_UFS_FS)		+= ufs/
>  obj-$(CONFIG_EFS_FS)		+= efs/
> -- 
> 1.7.1
> 
