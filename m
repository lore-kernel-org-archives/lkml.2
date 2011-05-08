Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab1EHWZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:25:17 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:56046 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab1EHWZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:25:13 -0400
From: Richard Weinberger <richard@nod.at>
To: Mattia Dongili <malattia@linux.it>
Subject: Re: [uml-devel] [PATCH 1/4] um: fix UML_LIB_PATH
Date: Mon, 9 May 2011 00:24:04 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
References: <1304891985-11569-1-git-send-email-richard@nod.at> <20110508221952.GA26304@kamineko.org>
In-Reply-To: <20110508221952.GA26304@kamineko.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105090024.05212.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 09 Mai 2011, 00:19:53 schrieb Mattia Dongili:
> On Sun, May 08, 2011 at 11:59:42PM +0200, Richard Weinberger wrote:
> > UML_LIB_PATH is hardcoded to /usr/lib/uml/,
> > on 64bit systems UML_LIB_PATH needs to be /usr/lib64/uml/.
> > 
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> > ---
> > 
> >  arch/um/drivers/xterm.c     |    2 +-
> >  arch/um/include/shared/os.h |    7 +++++++
> >  arch/um/os-Linux/main.c     |    2 +-
> >  3 files changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/um/drivers/xterm.c b/arch/um/drivers/xterm.c
> > index da2caa5..8ac7146 100644
> > --- a/arch/um/drivers/xterm.c
> > +++ b/arch/um/drivers/xterm.c
> > @@ -90,7 +90,7 @@ static int xterm_open(int input, int output, int
> > primary, void *d,
> > 
> >  	int pid, fd, new, err;
> >  	char title[256], file[] = "/tmp/xterm-pipeXXXXXX";
> >  	char *argv[] = { terminal_emulator, title_switch, title, exec_switch,
> > 
> > -			 "/usr/lib/uml/port-helper", "-uml-socket",
> > +			 OS_LIB_PATH "/uml/port-helper", "-uml-socket",
> > 
> >  			 file, NULL };
> >  	
> >  	if (access(argv[4], X_OK) < 0)
> > 
> > diff --git a/arch/um/include/shared/os.h b/arch/um/include/shared/os.h
> > index c4617ba..83c7c2e 100644
> > --- a/arch/um/include/shared/os.h
> > +++ b/arch/um/include/shared/os.h
> > @@ -29,6 +29,12 @@
> > 
> >  #define OS_ACC_R_OK    4       /* Test for read permission.  */
> >  #define OS_ACC_RW_OK   (OS_ACC_W_OK | OS_ACC_R_OK) /* Test for RW
> >  permission */
> > 
> > +#ifdef CONFIG_64BIT
> > +#define OS_LIB_PATH	"/usr/lib64/"
> > +#else
> > +#define OS_LIB_PATH	"/usr/lib/"
> > +#endif
> > +
> > 
> >  /*
> >  
> >   * types taken from stat_file() in hostfs_user.c
> >   * (if they are wrong here, they are wrong there...).
> > 
> > @@ -238,6 +244,7 @@ extern int raw(int fd);
> > 
> >  extern void setup_machinename(char *machine_out);
> >  extern void setup_hostinfo(char *buf, int len);
> >  extern void os_dump_core(void) __attribute__ ((noreturn));
> > 
> > +extern void um_early_printk(const char *s, unsigned int n);
> 
> this hunk seems unrelated to this change.

Good catch!

Thanks,
//richard
