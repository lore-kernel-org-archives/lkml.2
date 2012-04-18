Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab2DRTC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 15:02:58 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:48719 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab2DRTCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 15:02:55 -0400
Date: Wed, 18 Apr 2012 19:03:53 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Beiderman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 29/43] userns: Convert stat to return values mapped
 from kuids and kgids
Message-ID: <20120418190353.GG5186@mail.hallyn.com>
References: <m11unyn70b.fsf@fess.ebiederm.org>
 <1333862139-31737-29-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333862139-31737-29-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Beiderman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> - Store uids and gids with kuid_t and kgid_t in struct kstat
> - Convert uid and gids to userspace usable values with
>   from_kuid and from_kgid
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  arch/arm/kernel/sys_oabi-compat.c |    4 ++--
>  arch/parisc/hpux/fs.c             |    4 ++--
>  arch/s390/kernel/compat_linux.c   |    4 ++--
>  arch/sparc/kernel/sys_sparc32.c   |    4 ++--
>  arch/x86/ia32/sys_ia32.c          |    4 ++--
>  fs/compat.c                       |    4 ++--
>  fs/stat.c                         |    8 ++++----
>  include/linux/stat.h              |    5 +++--
>  8 files changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
> index af0aaeb..3e94811 100644
> --- a/arch/arm/kernel/sys_oabi-compat.c
> +++ b/arch/arm/kernel/sys_oabi-compat.c
> @@ -124,8 +124,8 @@ static long cp_oldabi_stat64(struct kstat *stat,
>  	tmp.__st_ino = stat->ino;
>  	tmp.st_mode = stat->mode;
>  	tmp.st_nlink = stat->nlink;
> -	tmp.st_uid = stat->uid;
> -	tmp.st_gid = stat->gid;
> +	tmp.st_uid = from_kuid_munged(current_user_ns(), stat->uid);
> +	tmp.st_gid = from_kgid_munged(current_user_ns(), stat->gid);
>  	tmp.st_rdev = huge_encode_dev(stat->rdev);
>  	tmp.st_size = stat->size;
>  	tmp.st_blocks = stat->blocks;
> diff --git a/arch/parisc/hpux/fs.c b/arch/parisc/hpux/fs.c
> index 0dc8543..c71eb6c 100644
> --- a/arch/parisc/hpux/fs.c
> +++ b/arch/parisc/hpux/fs.c
> @@ -159,8 +159,8 @@ static int cp_hpux_stat(struct kstat *stat, struct hpux_stat64 __user *statbuf)
>  	tmp.st_ino = stat->ino;
>  	tmp.st_mode = stat->mode;
>  	tmp.st_nlink = stat->nlink;
> -	tmp.st_uid = stat->uid;
> -	tmp.st_gid = stat->gid;
> +	tmp.st_uid = from_kuid_munged(current_user_ns(), stat->uid);
> +	tmp.st_gid = from_kgid_munged(current_user_ns(), stat->gid);
>  	tmp.st_rdev = new_encode_dev(stat->rdev);
>  	tmp.st_size = stat->size;
>  	tmp.st_atime = stat->atime.tv_sec;
> diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
> index 5baac18..80ab23a 100644
> --- a/arch/s390/kernel/compat_linux.c
> +++ b/arch/s390/kernel/compat_linux.c
> @@ -546,8 +546,8 @@ static int cp_stat64(struct stat64_emu31 __user *ubuf, struct kstat *stat)
>  	tmp.__st_ino = (u32)stat->ino;
>  	tmp.st_mode = stat->mode;
>  	tmp.st_nlink = (unsigned int)stat->nlink;
> -	tmp.st_uid = stat->uid;
> -	tmp.st_gid = stat->gid;
> +	tmp.st_uid = from_kuid_munged(current_user_ns(), stat->uid);
> +	tmp.st_gid = from_kgid_munged(current_user_ns(), stat->gid);
>  	tmp.st_rdev = huge_encode_dev(stat->rdev);
>  	tmp.st_size = stat->size;
>  	tmp.st_blksize = (u32)stat->blksize;
> diff --git a/arch/sparc/kernel/sys_sparc32.c b/arch/sparc/kernel/sys_sparc32.c
> index 29c478f..f739233 100644
> --- a/arch/sparc/kernel/sys_sparc32.c
> +++ b/arch/sparc/kernel/sys_sparc32.c
> @@ -139,8 +139,8 @@ static int cp_compat_stat64(struct kstat *stat,
>  	err |= put_user(stat->ino, &statbuf->st_ino);
>  	err |= put_user(stat->mode, &statbuf->st_mode);
>  	err |= put_user(stat->nlink, &statbuf->st_nlink);
> -	err |= put_user(stat->uid, &statbuf->st_uid);
> -	err |= put_user(stat->gid, &statbuf->st_gid);
> +	err |= put_user(from_kuid_munged(current_user_ns(), stat->uid), &statbuf->st_uid);
> +	err |= put_user(from_kgid_munged(current_user_ns(), stat->gid), &statbuf->st_gid);
>  	err |= put_user(huge_encode_dev(stat->rdev), &statbuf->st_rdev);
>  	err |= put_user(0, (unsigned long __user *) &statbuf->__pad3[0]);
>  	err |= put_user(stat->size, &statbuf->st_size);
> diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
> index aec2202..d5c820a 100644
> --- a/arch/x86/ia32/sys_ia32.c
> +++ b/arch/x86/ia32/sys_ia32.c
> @@ -71,8 +71,8 @@ static int cp_stat64(struct stat64 __user *ubuf, struct kstat *stat)
>  {
>  	typeof(ubuf->st_uid) uid = 0;
>  	typeof(ubuf->st_gid) gid = 0;
> -	SET_UID(uid, stat->uid);
> -	SET_GID(gid, stat->gid);
> +	SET_UID(uid, from_kuid_munged(current_user_ns(), stat->uid));
> +	SET_GID(gid, from_kgid_munged(current_user_ns(), stat->gid));
>  	if (!access_ok(VERIFY_WRITE, ubuf, sizeof(struct stat64)) ||
>  	    __put_user(huge_encode_dev(stat->dev), &ubuf->st_dev) ||
>  	    __put_user(stat->ino, &ubuf->__st_ino) ||
> diff --git a/fs/compat.c b/fs/compat.c
> index f2944ac..0781e61 100644
> --- a/fs/compat.c
> +++ b/fs/compat.c
> @@ -144,8 +144,8 @@ static int cp_compat_stat(struct kstat *stat, struct compat_stat __user *ubuf)
>  	tmp.st_nlink = stat->nlink;
>  	if (tmp.st_nlink != stat->nlink)
>  		return -EOVERFLOW;
> -	SET_UID(tmp.st_uid, stat->uid);
> -	SET_GID(tmp.st_gid, stat->gid);
> +	SET_UID(tmp.st_uid, from_kuid_munged(current_user_ns(), stat->uid));
> +	SET_GID(tmp.st_gid, from_kgid_munged(current_user_ns(), stat->gid));
>  	tmp.st_rdev = old_encode_dev(stat->rdev);
>  	if ((u64) stat->size > MAX_NON_LFS)
>  		return -EOVERFLOW;
> diff --git a/fs/stat.c b/fs/stat.c
> index c733dc5..fca17f9 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -137,8 +137,8 @@ static int cp_old_stat(struct kstat *stat, struct __old_kernel_stat __user * sta
>  	tmp.st_nlink = stat->nlink;
>  	if (tmp.st_nlink != stat->nlink)
>  		return -EOVERFLOW;
> -	SET_UID(tmp.st_uid, stat->uid);
> -	SET_GID(tmp.st_gid, stat->gid);
> +	SET_UID(tmp.st_uid, from_kuid_munged(current_user_ns(), stat->uid));
> +	SET_GID(tmp.st_gid, from_kgid_munged(current_user_ns(), stat->gid));
>  	tmp.st_rdev = old_encode_dev(stat->rdev);
>  #if BITS_PER_LONG == 32
>  	if (stat->size > MAX_NON_LFS)
> @@ -215,8 +215,8 @@ static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
>  	tmp.st_nlink = stat->nlink;
>  	if (tmp.st_nlink != stat->nlink)
>  		return -EOVERFLOW;
> -	SET_UID(tmp.st_uid, stat->uid);
> -	SET_GID(tmp.st_gid, stat->gid);
> +	SET_UID(tmp.st_uid, from_kuid_munged(current_user_ns(), stat->uid));
> +	SET_GID(tmp.st_gid, from_kgid_munged(current_user_ns(), stat->gid));
>  #if BITS_PER_LONG == 32
>  	tmp.st_rdev = old_encode_dev(stat->rdev);
>  #else
> diff --git a/include/linux/stat.h b/include/linux/stat.h
> index 611c398..4613240 100644
> --- a/include/linux/stat.h
> +++ b/include/linux/stat.h
> @@ -58,14 +58,15 @@
>  
>  #include <linux/types.h>
>  #include <linux/time.h>
> +#include <linux/uidgid.h>
>  
>  struct kstat {
>  	u64		ino;
>  	dev_t		dev;
>  	umode_t		mode;
>  	unsigned int	nlink;
> -	uid_t		uid;
> -	gid_t		gid;
> +	kuid_t		uid;
> +	kgid_t		gid;
>  	dev_t		rdev;
>  	loff_t		size;
>  	struct timespec  atime;
> -- 
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
