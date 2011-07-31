Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab1GaRk0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 13:40:26 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:61350 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab1GaRkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 13:40:20 -0400
Date: Sun, 31 Jul 2011 13:37:58 -0400 (EDT)
From: Peter Foley <pefoley2@verizon.net>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Peter Foley <pefoley2@verizon.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        mmarek@suse.cz
Subject: Re: kbuild: prevent make from deleting _shipped files
In-reply-to: <CACqU3MX=MVd8v2wKaFsNuXB2WsWq2jLsGfAdDEW9atoWbWE7Mg@mail.gmail.com>
Message-id: <alpine.LNX.2.00.1107311333320.53256@linux>
References: <alpine.LNX.2.00.1107311134490.30666@linux>
 <CACqU3MX7f2oNpDf6W124tfROfKq4PFsyvxiq=VtPJfv-gqUrww@mail.gmail.com>
 <CACqU3MU9BBsXjevz617v7YOBm+9RR1Wm49gi0jvs95yneQ2Yrg@mail.gmail.com>
 <alpine.LNX.2.00.1107311300190.16802@linux>
 <CACqU3MX=MVd8v2wKaFsNuXB2WsWq2jLsGfAdDEW9atoWbWE7Mg@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="0-844082869-1312133883=:53256"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-844082869-1312133883=:53256
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sun, 31 Jul 2011, Arnaud Lacombe wrote:

> Hi,
> 
> On Sun, Jul 31, 2011 at 1:08 PM, Peter Foley <pefoley2@verizon.net> wrote:
> > On Sun, 31 Jul 2011, Arnaud Lacombe wrote:
> >
> >> Hi,
> >>
> >> On Sun, Jul 31, 2011 at 12:21 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> >> > Hi,
> >> >
> >> > On Sun, Jul 31, 2011 at 11:37 AM, Peter Foley <pefoley2@verizon.net> wrote:
> >> >> commit 7373f4f (kbuild: add implicit rules for parser generation)
> >> >> created a implicit rule chain (%.c: %.c_shipped: %.y). This causes make to delete the _shipped files
> >> >> because it considers them intermediate files. Mark the _shipped files PRECIOUS
> >> >> to prevent make from deleting them.
> >> >>
> >> >> Signed-off-by: Peter Foley <pefoley2@verizon.net>
> >> > What make are you using, and what command triggers the issue ?
> >> >
> >> > Those rules should only be visible on parser regeneration (ie.
> >> > REGENERATE_PARSERS defined). make 3.82 does not seem to trigger the
> >> > issue:
> >> >
> >> > % make -v
> >> > GNU Make 3.82
> >> >
> >> > % make REGENERATE_PARSERS=y defconfig
> >> >  HOSTCC  scripts/basic/fixdep
> >> >  HOSTCC  scripts/kconfig/conf.o
> >> >  SHIPPED scripts/kconfig/zconf.tab.c
> >> >  SHIPPED scripts/kconfig/zconf.lex.c
> >> >  SHIPPED scripts/kconfig/zconf.hash.c
> >> >  HOSTCC  scripts/kconfig/zconf.tab.o
> >> >  HOSTLD  scripts/kconfig/conf
> >> > *** Default configuration is based on 'x86_64_defconfig'
> >> > [...]
> >> >
> >> > The shipped file are still there:
> >> >
> >> > % ls scripts/kconfig/*_shipped
> >> > scripts/kconfig/zconf.hash.c_shipped
> >> > scripts/kconfig/zconf.lex.c_shipped
> >> > scripts/kconfig/zconf.tab.c_shipped
> >> >
> >> a bare make-3.81 from ftp.gnu.org built on a Fedora 14 behave the same.
> >>
> >> I definitively needs enlightenment on this one :)
> >>
> >> Thanks,
> >>  - Arnaud
> >
> > The problem only appears when the parsers are actually rebuilt.
> > rm scripts/kconfig/*_shipped
> ^^^^^
> 
> This is why. You do not (or at least no longer) need to remove the
> *_shipped files before regenerating them.
> 
>  - Arnaud

Ok, I deleted the _shipped files as a easy way to force regeneration but 
touching the source files works just as well.
Please disregard this patch.


Thanks,

Peter
--0-844082869-1312133883=:53256--
