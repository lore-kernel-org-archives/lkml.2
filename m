Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab0D0PAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:00:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756163Ab0D0PAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:00:45 -0400
Date: Tue, 27 Apr 2010 12:00:16 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, stefanha@linux.vnet.ibm.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf tools: Fix libdw-dev package name in
	error message
Message-ID: <20100427150016.GC8565@ghostprotocols.net>
References: <1272292023-9869-1-git-send-email-stefanha@linux.vnet.ibm.com> <tip-f93830fbb06b67848c762f2177c06cc3cbb97deb@git.kernel.org> <5694.1272376100@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5694.1272376100@localhost>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Apr 27, 2010 at 09:48:20AM -0400, Valdis.Kletnieks@vt.edu escreveu:
> On Tue, 27 Apr 2010 12:59:19 -0000, tip-bot for Stefan Hajnoczi said:
> > Commit-ID:  f93830fbb06b67848c762f2177c06cc3cbb97deb
> > Gitweb:     http://git.kernel.org/tip/f93830fbb06b67848c762f2177c06cc3cbb97deb
> > Author:     Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> > AuthorDate: Mon, 26 Apr 2010 15:39:54 -0300
> > Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> > CommitDate: Mon, 26 Apr 2010 15:39:54 -0300
> > 
> > perf tools: Fix libdw-dev package name in error message
> > 
> > The headers required for DWARF support are provided by the libdw-dev
> > package in Debian-based distros.
> 
> Not all the world is Debian based.  As I mentioned before, the package needed
> is elfutils-devel on Redhat/Fedora systesm.  For those boxes, you're changing a
> 'elfutil-dev' that the user can guess is supposed to be -devel, to a package
> that doesn't exist on Redhat/Fedora.  And to compound it, if the user guesses
> that you meant libdwarf-devel, that still fails, because that does *not*
> provide the libdw.h header - that's still in elfutil-devel.

It works for Red Hat, the message is:

        msg := $(warning No libdw.h found or old libdw.h found, disables dwarf support. Please install elfutils-devel/libdw-dev);

And, as you say:

[acme@doppio git]$ rpm -ql elfutils-devel
/usr/include/dwarf.h
/usr/include/elfutils
/usr/include/elfutils/elf-knowledge.h
/usr/include/elfutils/libasm.h
/usr/include/elfutils/libdw.h
/usr/include/elfutils/libdwfl.h
/usr/include/elfutils/libebl.h
/usr/include/elfutils/version.h
/usr/lib64/libasm.so
/usr/lib64/libdw.so
/usr/lib64/libebl.a
[acme@doppio git]$

	If you have a better phrasing to avoid such misunderstandings,
please send a patch.

- Arnaldo
