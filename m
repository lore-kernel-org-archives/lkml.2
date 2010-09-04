Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab0IDSWZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 14:22:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab0IDSWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 14:22:24 -0400
Date: Sat, 4 Sep 2010 14:22:13 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Hui Zhu <teawater@gmail.com>
Cc: Steven <mqyoung@gmail.com>, "gdb@sourceware.org" <gdb@sourceware.org>,
        linux-kernel@vger.kernel.org, Michael Snyder <msnyder@vmware.com>,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>
Subject: Re: Linux Kernel GDB tracepoint module 2010-8-30 release
Message-ID: <20100904182213.GD10118@redhat.com>
References: <AANLkTimjO7sBzR55XkPB7dmZvxXqc8PS4UDsgptXVt90@mail.gmail.com> <1283504768.2100.43.camel@steven> <y0md3suzzuj.fsf@fche.csb> <AANLkTinF+ZagFoLhEfpwpD+wgxq75Lrhnhp2mGLehSXJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinF+ZagFoLhEfpwpD+wgxq75Lrhnhp2mGLehSXJ@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -


Hui Zhu <teawater@gmail.com> wrote:

> I met a issue with build systemtap.  Build it need (install
> elfutils-devel, libebl-dev, libdw-dev and/or libebl-devel), but
> ubuntu looks don't have it.

It is there (apt-get builddep systemtap), but you can also use the
bundled-elfutils mode in the README, which uses a private source
tarball / build of elfutils.


> > #! /usr/bin/stap -g
> > probe kernel.function("vfs_readdir") {
> >  �println(%{ jiffies_64 %})
> >  �println($file$)
> > }
> 
> parse error: expected literal string or number
> 	saw: embedded-code at ./1.sh:3:14
>      source:      println(%{ jiffies_64 %})

This particular script needs to be run with "stap -g" (guru mode)
because it uses embedded-C to access the jiffies_64 value instead of
debuginfo.


> > #! /usr/bin/stap
> > probe kernel.statement("*@fs/readdir.c:29") {
> >  �println($res)
> > }
> >
> 
> semantic error: not accessible at this address: identifier '$res' at ./1.sh:3:14
>         source:      println($res)

That can happen if your line number is not quite right, or if you're
using a version of gcc prior to the VTA (better debuginfo for local
variables) code released in 4.5 (backported to 4.4 in Red Hat
distros).  (More recent versions of systemtap may also help.)

If OTOH gdb can access the variable there but systemtap can't, then we
have a bug (and I'd appreciate your time helping collect some extra
data to help fix it).


- FChE
