Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab2IFNz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:55:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64874 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab2IFNzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:55:25 -0400
Date: Thu, 6 Sep 2012 06:55:19 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Liang Li <liang.li@windriver.com>
Cc: Richard Purdie <richard.purdie@linuxfoundation.org>,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] perf: add SLANG_INC for slang.h
Message-ID: <20120906135519.GM8203@ghostprotocols.net>
References: <1345777839-15843-1-git-send-email-liang.li@windriver.com>
 <20120905205439.GD8203@ghostprotocols.net>
 <1346880183.21985.90.camel@ted>
 <20120905224122.GH8203@ghostprotocols.net>
 <20120906021121.GB16647@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120906021121.GB16647@localhost>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 06, 2012 at 10:11:22AM +0800, Liang Li escreveu:
> On 2012-09-06 06:41, Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
> > > Does:
> > > 
> > > SLANG_INC ?= -I=/usr/include/slang
> > > 
> > > work any better? Its hard to tell from the above error which bit of the
> > 
> > I'll try later
> > 
> > > syntax is failing. Which gcc version is it?
> > 
> > [acme@sandy linux]$ gcc -v
> > Using built-in specs.
> > Target: x86_64-redhat-linux
> > Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
> > --infodir=/usr/share/info
> > --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap
> > --enable-shared --enable-threads=posix --enable-checking=release
> > --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions
> > --enable-gnu-unique-object
> > --enable-languages=c,c++,objc,obj-c++,java,fortran,ada
> > --enable-java-awt=gtk --disable-dssi
> > --with-java-home=/usr/lib/jvm/java-1.5.0-gcj-1.5.0.0/jre
> > --enable-libgcj-multifile --enable-java-maintainer-mode
> > --with-ecj-jar=/usr/share/java/eclipse-ecj.jar
> > --disable-libjava-multilib --with-ppl --with-cloog --with-tune=generic
> > --with-arch_32=i686 --build=x86_64-redhat-linux
> > Thread model: posix
> > gcc version 4.4.6 20120305 (Red Hat 4.4.6-4) (GCC) 
> > [acme@sandy linux]$
> 
> Seems like there is no slang.h installed. Could you please check:
> 
> $ find /usr/include/ -name slang.h
> 
> On my FC17:
> 
> $ find /usr/include/ -name slang.h
> /usr/include/slang/slang.h
> /usr/include/slang.h
> $ rpm -qf /usr/include/slang.h
> slang-devel-2.2.4-3.fc17.x86_64
> $ rpm -qf /usr/include/slang/slang.h
> slang-devel-2.2.4-3.fc17.x86_64

[root@sandy ~]# find /usr/include/ -name slang.h
/usr/include/slang/slang.h
[root@sandy ~]# 
[root@sandy ~]# rpm -qf /usr/include/slang/slang.h
slang-devel-2.2.1-1.el6.x86_64
 
> ---
> 
> And does 'export SLANG_INC=<to location of the slang.h>' works any
> better? :)

Lemme process the other patches first, will try.

- arnaldo
