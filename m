Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693Ab1JGJT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 05:19:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45689 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab1JGJT0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 05:19:26 -0400
From: "Premi, Sanjeev" <premi@ti.com>
To: Michal Marek <mmarek@suse.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 7 Oct 2011 14:49:16 +0530
Subject: RE: [PATCH] kconfig: fix warnings due to unused return values
Thread-Topic: [PATCH] kconfig: fix warnings due to unused return values
Thread-Index: AcyDcIZPRnsw6Z0USCa0BpE3qM2cWwBYGyHQ
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59302579AD86F@dbde02.ent.ti.com>
References: <1316691396-25447-1-git-send-email-premi@ti.com>
 <4E8C72B6.9030603@suse.cz>
In-Reply-To: <4E8C72B6.9030603@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Michal Marek [mailto:mmarek@suse.cz] 
> Sent: Wednesday, October 05, 2011 8:38 PM
> To: Premi, Sanjeev
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] kconfig: fix warnings due to unused return values
> 
> On 22.9.2011 13:36, Sanjeev Premi wrote:
> > The return value of wattrset() is being ignored in the
> > code and newer compilers complain about this e.g.
> > 
> > HOSTCC  scripts/kconfig/lxdialog/checklist.o
> > scripts/kconfig/lxdialog/checklist.c: In function print_item:
> > scripts/kconfig/lxdialog/checklist.c:40: warning: value 
> computed is not used
> > scripts/kconfig/lxdialog/checklist.c:46: warning: value 
> computed is not used
> > 
> > Let the compiler know that ignore is intentional.
> > 
> > Signed-off-by: Sanjeev Premi <premi@ti.com>
> > ---
> > 
> >   The patch was created against the last pull from git.kernel.org
> >   The 'pull' from github is taking more than few hours...
> > 
> >   Based on the time stamps at this url, I believe the patch should
> >   apply cleanly:
> >    
> https://github.com/torvalds/linux/tree/master/scripts/kconfig/lxdialog
> 
> The latest kconfig tree is at http://repo.or.cz/w/linux-kbuild.git,
> branch kconfig. You can pull it by
> 
> $ git fetch git://repo.or.cz/linux-kbuild.git kconfig:kconfig

Sure, I will pull it.

> 
> > diff --git a/scripts/kconfig/lxdialog/checklist.c 
> b/scripts/kconfig/lxdialog/checklist.c
> > index a2eb80f..8407849 100644
> > --- a/scripts/kconfig/lxdialog/checklist.c
> > +++ b/scripts/kconfig/lxdialog/checklist.c
> > @@ -37,20 +37,20 @@ static void print_item(WINDOW * win, 
> int choice, int selected)
> >  	list_item[list_width - item_x] = '\0';
> >  
> >  	/* Clear 'residue' of last item */
> > -	wattrset(win, dlg.menubox.atr);
> > +	(void)wattrset(win, dlg.menubox.atr);
> >  	wmove(win, choice, 0);
> >  	for (i = 0; i < list_width; i++)
> >  		waddch(win, ' ');
> >  
> >  	wmove(win, choice, check_x);
> > -	wattrset(win, selected ? dlg.check_selected.atr
> > +	(void)wattrset(win, selected ? dlg.check_selected.atr
> 
> Uhm, not pretty.

Agree. But, of course, I am not too conversant with Kconfig code.
Just found these prints to be nagging after migrating to machines.

> What ncurses version are you using? Can you post the
> output of make V=1 menuconfig? It seems like wattrset is defined as a
> macro instead of a function call. FWIW, it does not print any warnings
> here with
> 
> $ rpm -qf /usr/include/ncurses
> ncurses-devel-5.8-2.6.x86_64
> and
> gcc version 4.6.1 20110801 [gcc-4_6-branch revision 177033] 
> (SUSE Linux)
> 
> on openSUSE Factory.
> 
> Michal
> 

I am on Ubuntu 10.04.1 LTS

premi #
premi # gcc --version
gcc (Ubuntu 4.4.3-4ubuntu5) 4.4.3
Copyright (C) 2009 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
premi #
premi #
premi # dpkg --get-selections | grep curses
lib32ncurses5                                   install
libcurses-perl                                  install
libcurses-ui-perl                               install
libncurses5                                     install
libncurses5-dev                                 install
libncursesw5                                    install
ncurses-base                                    install
ncurses-bin                                     install
premi #
premi # make V=1 menuconfig
make -f scripts/Makefile.build obj=scripts/basic
rm -f .tmp_quiet_recordmcount
mkdir -p include/linux include/config
make -f scripts/Makefile.build obj=scripts/kconfig menuconfig
/bin/sh /home/premi/linux-omap-2.6/scripts/kconfig/lxdialog/check-lxdialog.sh -check gcc -DCURSES_LOC="<ncurses.h>" -DLOCALE  -lncurses
  gcc -Wp,-MD,scripts/kconfig/lxdialog/.checklist.o.d -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer   -DCURSES_LOC="<ncurses.h>" -DLOCALE   -c -o scripts/kconfig/lxdialog/checklist.o scripts/kconfig/lxdialog/checklist.c
scripts/kconfig/lxdialog/checklist.c: In function âprint_itemâ:
scripts/kconfig/lxdialog/checklist.c:40: warning: value computed is not used
scripts/kconfig/lxdialog/checklist.c:46: warning: value computed is not used
scripts/kconfig/lxdialog/checklist.c:51: warning: value computed is not used
scripts/kconfig/lxdialog/checklist.c:53: warning: value computed is not used
scripts/kconfig/lxdialog/checklist.c: In function âprint_arrowsâ:
scripts/kconfig/lxdialog/checklist.c:71: warning: value computed is not used
scripts/kconfig/lxdialog/checklist.c:75: warning: value computed is not used
scripts/kconfig/lxdialog/checklist.c:86: warning: value computed is not used
scripts/kconfig/lxdialog/checklist.c:90: warning: value computed is not used
scripts/kconfig/lxdialog/checklist.c: In function âdialog_checklistâ:
scripts/kconfig/lxdialog/checklist.c:153: warning: value computed is not used
scripts/kconfig/lxdialog/checklist.c:157: warning: value computed is not used
scripts/kconfig/lxdialog/checklist.c:162: warning: value computed is not used
  gcc -Wp,-MD,scripts/kconfig/lxdialog/.inputbox.o.d -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer   -DCURSES_LOC="<ncurses.h>" -DLOCALE   -c -o scripts/kconfig/lxdialog/inputbox.o scripts/kconfig/lxdialog/inputbox.c
scripts/kconfig/lxdialog/inputbox.c: In function âdialog_inputboxâ:
scripts/kconfig/lxdialog/inputbox.c:74: warning: value computed is not used
scripts/kconfig/lxdialog/inputbox.c:78: warning: value computed is not used
scripts/kconfig/lxdialog/inputbox.c:83: warning: value computed is not used
scripts/kconfig/lxdialog/inputbox.c:98: warning: value computed is not used
scripts/kconfig/lxdialog/inputbox.c:131: warning: value computed is not used
scripts/kconfig/lxdialog/inputbox.c:151: warning: value computed is not used
  gcc -Wp,-MD,scripts/kconfig/lxdialog/.menubox.o.d -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer   -DCURSES_LOC="<ncurses.h>" -DLOCALE   -c -o scripts/kconfig/lxdialog/menubox.o scripts/kconfig/lxdialog/menubox.c
scripts/kconfig/lxdialog/menubox.c: In function âdo_print_itemâ:
scripts/kconfig/lxdialog/menubox.c:77: warning: value computed is not used
scripts/kconfig/lxdialog/menubox.c:88: warning: value computed is not used
scripts/kconfig/lxdialog/menubox.c:91: warning: value computed is not used
scripts/kconfig/lxdialog/menubox.c: In function âprint_arrowsâ:
scripts/kconfig/lxdialog/menubox.c:121: warning: value computed is not used
scripts/kconfig/lxdialog/menubox.c:125: warning: value computed is not used
scripts/kconfig/lxdialog/menubox.c:137: warning: value computed is not used
scripts/kconfig/lxdialog/menubox.c:141: warning: value computed is not used
scripts/kconfig/lxdialog/menubox.c: In function âdialog_menuâ:
scripts/kconfig/lxdialog/menubox.c:214: warning: value computed is not used
scripts/kconfig/lxdialog/menubox.c:218: warning: value computed is not used
scripts/kconfig/lxdialog/menubox.c:224: warning: value computed is not used
  gcc -Wp,-MD,scripts/kconfig/lxdialog/.textbox.o.d -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer   -DCURSES_LOC="<ncurses.h>" -DLOCALE   -c -o scripts/kconfig/lxdialog/textbox.o scripts/kconfig/lxdialog/textbox.c
scripts/kconfig/lxdialog/textbox.c: In function âdialog_textboxâ:
scripts/kconfig/lxdialog/textbox.c:98: warning: value computed is not used
scripts/kconfig/lxdialog/textbox.c:107: warning: value computed is not used
scripts/kconfig/lxdialog/textbox.c:111: warning: value computed is not used
scripts/kconfig/lxdialog/textbox.c: In function âprint_positionâ:
scripts/kconfig/lxdialog/textbox.c:386: warning: value computed is not used
  gcc -Wp,-MD,scripts/kconfig/lxdialog/.util.o.d -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer   -DCURSES_LOC="<ncurses.h>" -DLOCALE   -c -o scripts/kconfig/lxdialog/util.o scripts/kconfig/lxdialog/util.c
scripts/kconfig/lxdialog/util.c: In function âattr_clearâ:
scripts/kconfig/lxdialog/util.c:243: warning: value computed is not used
scripts/kconfig/lxdialog/util.c: In function âdialog_clearâ:
scripts/kconfig/lxdialog/util.c:259: warning: value computed is not used
scripts/kconfig/lxdialog/util.c: In function âprint_titleâ:
scripts/kconfig/lxdialog/util.c:316: warning: value computed is not used
scripts/kconfig/lxdialog/util.c: In function âprint_buttonâ:
scripts/kconfig/lxdialog/util.c:396: warning: value computed is not used
scripts/kconfig/lxdialog/util.c:401: warning: value computed is not used
scripts/kconfig/lxdialog/util.c:405: warning: value computed is not used
scripts/kconfig/lxdialog/util.c:408: warning: value computed is not used
scripts/kconfig/lxdialog/util.c:411: warning: value computed is not used
scripts/kconfig/lxdialog/util.c: In function âdraw_shadowâ:
scripts/kconfig/lxdialog/util.c:460: warning: value computed is not used
  gcc -Wp,-MD,scripts/kconfig/lxdialog/.yesno.o.d -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer   -DCURSES_LOC="<ncurses.h>" -DLOCALE   -c -o scripts/kconfig/lxdialog/yesno.o scripts/kconfig/lxdialog/yesno.c
scripts/kconfig/lxdialog/yesno.c: In function âdialog_yesnoâ:
scripts/kconfig/lxdialog/yesno.c:64: warning: value computed is not used
scripts/kconfig/lxdialog/yesno.c:68: warning: value computed is not used
scripts/kconfig/lxdialog/yesno.c:73: warning: value computed is not used
  gcc -Wp,-MD,scripts/kconfig/.mconf.o.d -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer   -DCURSES_LOC="<ncurses.h>" -DLOCALE   -c -o scripts/kconfig/mconf.o scripts/kconfig/mconf.c
  gcc  -o scripts/kconfig/mconf scripts/kconfig/mconf.o scripts/kconfig/zconf.tab.o scripts/kconfig/lxdialog/checklist.o scripts/kconfig/lxdialog/util.o scripts/kconfig/lxdialog/inputbox.o scripts/kconfig/lxdialog/textbox.o scripts/kconfig/lxdialog/yesno.o scripts/kconfig/lxdialog/menubox.o  -lncurses
scripts/kconfig/mconf Kconfig
