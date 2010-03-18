Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab0CRGtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 02:49:50 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:42305 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab0CRGtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 02:49:49 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Mar 2010 02:49:48 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=h1mN5x12jpV1yn4mQ0PuiajwlhLeV566/DDtBNmh29m6wx0SogjFpes8IGRx8b6eWp
         D0wKdIPQLukNaZVQmf/miAlbOkSCVW2wBwERBPxDqzuNhn37FWmimBZYjxXxKhauilEt
         /bGDlnLyZjd8orsgf1x3al9XkshtXvXHOgPIk=
MIME-Version: 1.0
In-Reply-To: <4BA14F35.5050007@gmail.com>
References: <dd18b0c31003161804i5275304cl13256077080946c4@mail.gmail.com>
	 <7e0fb38c1003171314v6d1ab81fv6ac7a9556dfddd1@mail.gmail.com>
	 <4BA14F35.5050007@gmail.com>
Date: Wed, 17 Mar 2010 23:42:21 -0700
Message-ID: <dd18b0c31003172342t5747a9bbh271372dc9d16357c@mail.gmail.com>
Subject: Re: new: loads of audit messgs
From: Justin Mattock <justinmattock@gmail.com>
To: Eric Paris <eparis@parisplace.org>
Cc: tresys <refpolicy@oss1.tresys.com>, SE-Linux <selinux@tycho.nsa.gov>,
       Joe Perches <joe@perches.com>, libc-help@sourceware.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o.k. here's the bisect result of why/what is happening with nscd and
the avc's that seem to be missing or partly there:

ef0658f3de484bf9b173639cd47544584e01efa5 is the first bad commit

with the latest HEAD if I do a git revert ef0658f then the audit
messages are showing themselves for nscd.

I can attach dmesg of the good/bad if needed(might be too big in size to send)

here's what I see with a good boot and a bad boot:


bad:


[    7.284796] generic-usb 0003:05AC:820A.0005: input: USB HID v1.11
Keyboard [HID 05ac:820a] on usb-0000:00:06.0-1.2/input0
[    7.352310] usb 4-1.3: new full speed USB device using ohci_hcd and address 5
[    7.465655] input: HID 05ac:820b as
/devices/pci0000:00/0000:00:06.0/usb4/4-1/4-1.3/4-1.3:1.0/input/input9
[    7.495826] generic-usb 0003:05AC:820B.0006: input: USB HID v1.11
Mouse [HID 05ac:820b] on usb-0000:00:06.0-1.3/input0
[    8.174301] type=1107 audit(1268891709.174:3): user pid=1270 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg=''
[    8.190628] type=1107 audit(1268891709.190:4): user pid=1270 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg=''
[    8.191284] type=1107 audit(1268891709.191:5): user pid=1270 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg=''
[    8.419552] ip_tables: (C) 2000-2006 Netfilter Core Team
[    8.444388] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    8.444784] CONFIG_NF_CT_ACCT is deprecated and will be removed
soon. Please use
[    8.444787] nf_conntrack.acct=1 kernel parameter, acct=1
nf_conntrack module option or
[    8.444789] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[    8.651874] type=1107 audit(1268891709.651:6): user pid=1270 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg=''
[    8.652623] type=1107 audit(1268891709.652:7): user pid=1270 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg=''
[    9.627717] type=1107 audit(1268891710.627:8): user pid=1270 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg=''
[    9.628468] type=1107 audit(1268891710.628:9): user pid=1270 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg=''
[   14.367538] type=1107 audit(1268891715.367:10): user pid=1270 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg=''
[   17.533134] type=1107 audit(1268891718.533:11): user pid=1270 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg=''
[   17.544443] type=1100 audit(1268891718.544:12): user pid=1349 uid=0
auid=4294967295 ses=4294967295
subj=system_u:system_r:local_login_t:s0-s0:c0.c255 msg=''
[   17.547677] type=1101 audit(1268891718.547:13): user pid=1349 uid=0
auid=4294967295 ses=4294967295
subj=system_u:system_r:local_login_t:s0-s0:c0.c255 msg=''
[   17.573083] type=1006 audit(1268891718.572:14): login pid=1349
uid=0 old auid=4294967295 new auid=1000 old ses=4294967295 new ses=1
[   17.626760] type=2300 audit(1268891718.626:15): user pid=1349 uid=0
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255
msg=''
[   17.639043] type=1107 audit(1268891718.638:16): user pid=1270 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg=''
[   17.756669] type=1105 audit(1268891718.756:17): user pid=1349 uid=0
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255
msg=''
[   17.757523] type=1107 audit(1268891718.757:18): user pid=1270 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg=''
[   17.778843] type=1103 audit(1268891718.778:19): user pid=1349 uid=0
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255
msg=''
[   17.778988] type=1112 audit(1268891718.778:20): user pid=1349 uid=0
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255
msg=''
[   17.784500] type=1107 audit(1268891718.784:21): user pid=1270 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg=''
[   17.905611] type=1107 audit(1268891718.905:22): user pid=1270 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg=''



good:


[    7.413356] input: HID 05ac:820b as
/devices/pci0000:00/0000:00:06.0/usb4/4-1/4-1.3/4-1.3:1.0/input/input9
[    7.413467] generic-usb 0003:05AC:820B.0006: input: USB HID v1.11
Mouse [HID 05ac:820b] on usb-0000:00:06.0-1.3/input0
[    7.703644] type=1107 audit(1268893782.703:3): user pid=1297 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg='avc:  denied  { shmemhost } for
scontext=system_u:system_r:syslogd_t:s0
tcontext=system_u:system_r:initrc_t:s0 tclass
[    7.703649] : exe="/usr/sbin/nscd" sauid=0 hostname=? addr=? terminal=?'
[    7.719890] type=1107 audit(1268893782.719:4): user pid=1297 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg='avc:  denied  { shmempwd } for
scontext=system_u:system_r:syslogd_t:s0
tcontext=system_u:system_r:initrc_t:s0 tclass=nscd
[    7.719895] : exe="/usr/sbin/nscd" sauid=0 hostname=? addr=? terminal=?'
[    7.720580] type=1107 audit(1268893782.720:5): user pid=1297 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg='avc:  denied  { shmemgrp } for
scontext=system_u:system_r:syslogd_t:s0
tcontext=system_u:system_r:initrc_t:s0 tclass=nscd
[    7.720585] : exe="/usr/sbin/nscd" sauid=0 hostname=? addr=? terminal=?'
[    7.940048] ip_tables: (C) 2000-2006 Netfilter Core Team
[    7.957023] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    7.957423] CONFIG_NF_CT_ACCT is deprecated and will be removed
soon. Please use
[    7.957426] nf_conntrack.acct=1 kernel parameter, acct=1
nf_conntrack module option or
[    7.957429] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[    8.181014] type=1107 audit(1268893783.180:6): user pid=1297 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg='avc:  denied  { shmempwd } for
scontext=system_u:system_r:system_dbusd_t:s0-s0:c0.c255
tcontext=system_u:system_r:initrc_t:s0 tclass=nscd
[    8.181019] : exe="/usr/sbin/nscd" sauid=0 hostname=? addr=? terminal=?'
[    8.181709] type=1107 audit(1268893783.181:7): user pid=1297 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg='avc:  denied  { shmemgrp } for
scontext=system_u:system_r:system_dbusd_t:s0-s0:c0.c255
tcontext=system_u:system_r:initrc_t:s0 tclass=nscd
[    8.181714] : exe="/usr/sbin/nscd" sauid=0 hostname=? addr=? terminal=?'
[    9.210425] type=1107 audit(1268893784.210:8): user pid=1297 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg='avc:  denied  { shmempwd } for
scontext=system_u:system_r:crond_t:s0-s0:c0.c255
tcontext=system_u:system_r:initrc_t:s0 tclass=nscd
[    9.210430] : exe="/usr/sbin/nscd" sauid=0 hostname=? addr=? terminal=?'
[    9.211152] type=1107 audit(1268893784.210:9): user pid=1297 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg='avc:  denied  { shmemgrp } for
scontext=system_u:system_r:crond_t:s0-s0:c0.c255
tcontext=system_u:system_r:initrc_t:s0 tclass=nscd
[    9.211158] : exe="/usr/sbin/nscd" sauid=0 hostname=? addr=? terminal=?'
[   12.564898] type=1107 audit(1268893787.564:10): user pid=1297 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg='avc:  denied  { shmempwd } for
scontext=system_u:system_r:local_login_t:s0-s0:c0.c255
tcontext=system_u:system_r:initrc_t:s0 tclass=nscd
[   12.564903] : exe="/usr/sbin/nscd" sauid=0 hostname=? addr=? terminal=?'
[   15.853971] type=1107 audit(1268893790.853:11): user pid=1297 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg='avc:  denied  { shmempwd } for
scontext=system_u:system_r:chkpwd_t:s0-s0:c0.c255
tcontext=system_u:system_r:initrc_t:s0 tclass=nscd
[   15.853976] : exe="/usr/sbin/nscd" sauid=0 hostname=? addr=? terminal=?'
[   15.865393] type=1100 audit(1268893790.865:12): user pid=1378 uid=0
auid=4294967295 ses=4294967295
subj=system_u:system_r:local_login_t:s0-s0:c0.c255
msg='op=PAM:authentication acct="justin" exe="/bin/login" hostname=?
addr=? terminal=/dev/tty1 res=success'
[   15.868672] type=1101 audit(1268893790.868:13): user pid=1378 uid=0
auid=4294967295 ses=4294967295
subj=system_u:system_r:local_login_t:s0-s0:c0.c255
msg='op=PAM:accounting acct="justin" exe="/bin/login" hostname=?
addr=? terminal=/dev/tty1 res=success'
[   15.893990] type=1006 audit(1268893790.893:14): login pid=1378
uid=0 old auid=4294967295 new auid=1000 old ses=4294967295 new ses=1
[   15.955961] type=2300 audit(1268893790.955:15): user pid=1378 uid=0
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255
msg='pam: default-context=justin:staff_r:staff_t:s0
selected-context=justin:staff_r:staff_t:s0: exe="/bin/login"
hostname=? addr=? terminal=tty1 res=success'
[   15.968319] type=1107 audit(1268893790.968:16): user pid=1297 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg='avc:  denied  { getpwd } for
scontext=system_u:system_r:local_login_t:s0-s0:c0.c255
tcontext=system_u:system_r:initrc_t:s0 tclass=nscd
[   15.968324] : exe="/usr/sbin/nscd" sauid=0 hostname=? addr=? terminal=?'
[   16.085919] type=1105 audit(1268893791.085:17): user pid=1378 uid=0
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255
msg='op=PAM:session_open acct="justin" exe="/bin/login" hostname=?
addr=? terminal=/dev/tty1 res=success'
[   16.086793] type=1107 audit(1268893791.086:18): user pid=1297 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg='avc:  denied  { shmemgrp } for
scontext=system_u:system_r:local_login_t:s0-s0:c0.c255
tcontext=system_u:system_r:initrc_t:s0 tclass=nscd
[   16.086798] : exe="/usr/sbin/nscd" sauid=0 hostname=? addr=? terminal=?'
[   16.108104] type=1103 audit(1268893791.108:19): user pid=1378 uid=0
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255
msg='op=PAM:setcred acct="justin" exe="/bin/login" hostname=? addr=?
terminal=/dev/tty1 res=success'
[   16.108250] type=1112 audit(1268893791.108:20): user pid=1378 uid=0
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255
msg='op=login acct="justin" exe="/bin/login" hostname=? addr=?
terminal=/dev/tty1 res=success'
[   16.113829] type=1107 audit(1268893791.113:21): user pid=1297 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg='avc:  denied  { shmempwd } for
scontext=justin:staff_r:staff_t:s0
tcontext=system_u:system_r:initrc_t:s0 tclass=nscd
[   16.113834] : exe="/usr/sbin/nscd" sauid=0 hostname=? addr=? terminal=?'
[   16.234781] type=1107 audit(1268893791.234:22): user pid=1297 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg='avc:  denied  { shmemgrp } for
scontext=justin:staff_r:staff_t:s0
tcontext=system_u:system_r:initrc_t:s0 tclass=nscd
[   16.234786] : exe="/usr/sbin/nscd" sauid=0 hostname=? addr=? terminal=?'
[   18.651428] type=1107 audit(1268893793.651:23): user pid=1297 uid=0
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0
msg='avc:  denied  { shmemhost } for
scontext=justin:staff_r:xauth_t:s0
tcontext=system_u:system_r:initrc_t:s0 tclass=nscd
[   18.651430] : exe="/usr/sbin/nscd" sauid=0 hostname=? addr=? terminal=?'


maybe I need to adjust something in /etc/sysctl.conf for the print or
something.

added come CC's

-- 
Justin P. Mattock
