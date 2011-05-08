Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab1EHWUC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:20:02 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:34403 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab1EHWUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:20:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-message-flag
         :x-operating-system:x-editor:x-disclaimer:user-agent;
        b=A5Jf0qiOBJJqwVpU5Z4aETGQxtakFBNLhcVMOYtHUwkz5516gd53L+F600QSf10vfb
         H7yE4uHH0jdkSqHGBf44XFUXTAKsioh+94/ZfZTQA3kZ0NX9TOissv4KRzexCtTWwvP4
         dG2/Hp0463/bXHtiPQKDuuOo75HvT9B34ONdE=
Date: Mon, 9 May 2011 07:19:53 +0900
From: Mattia Dongili <malattia@linux.it>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 1/4] um: fix UML_LIB_PATH
Message-ID: <20110508221952.GA26304@kamineko.org>
References: <1304891985-11569-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304891985-11569-1-git-send-email-richard@nod.at>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.39-rc4+ x86_64
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 08, 2011 at 11:59:42PM +0200, Richard Weinberger wrote:
> UML_LIB_PATH is hardcoded to /usr/lib/uml/,
> on 64bit systems UML_LIB_PATH needs to be /usr/lib64/uml/.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/um/drivers/xterm.c     |    2 +-
>  arch/um/include/shared/os.h |    7 +++++++
>  arch/um/os-Linux/main.c     |    2 +-
>  3 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/um/drivers/xterm.c b/arch/um/drivers/xterm.c
> index da2caa5..8ac7146 100644
> --- a/arch/um/drivers/xterm.c
> +++ b/arch/um/drivers/xterm.c
> @@ -90,7 +90,7 @@ static int xterm_open(int input, int output, int primary, void *d,
>  	int pid, fd, new, err;
>  	char title[256], file[] = "/tmp/xterm-pipeXXXXXX";
>  	char *argv[] = { terminal_emulator, title_switch, title, exec_switch,
> -			 "/usr/lib/uml/port-helper", "-uml-socket",
> +			 OS_LIB_PATH "/uml/port-helper", "-uml-socket",
>  			 file, NULL };
>  
>  	if (access(argv[4], X_OK) < 0)
> diff --git a/arch/um/include/shared/os.h b/arch/um/include/shared/os.h
> index c4617ba..83c7c2e 100644
> --- a/arch/um/include/shared/os.h
> +++ b/arch/um/include/shared/os.h
> @@ -29,6 +29,12 @@
>  #define OS_ACC_R_OK    4       /* Test for read permission.  */
>  #define OS_ACC_RW_OK   (OS_ACC_W_OK | OS_ACC_R_OK) /* Test for RW permission */
>  
> +#ifdef CONFIG_64BIT
> +#define OS_LIB_PATH	"/usr/lib64/"
> +#else
> +#define OS_LIB_PATH	"/usr/lib/"
> +#endif
> +
>  /*
>   * types taken from stat_file() in hostfs_user.c
>   * (if they are wrong here, they are wrong there...).
> @@ -238,6 +244,7 @@ extern int raw(int fd);
>  extern void setup_machinename(char *machine_out);
>  extern void setup_hostinfo(char *buf, int len);
>  extern void os_dump_core(void) __attribute__ ((noreturn));
> +extern void um_early_printk(const char *s, unsigned int n);

this hunk seems unrelated to this change.

Regards,
-- 
mattia
:wq!
