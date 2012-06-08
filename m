Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab2FHNNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:13:37 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40755 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2FHNNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:13:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAOvdn6UV1b89+wp4cfyj7ofU6T0=sdhNEoMZinPW=-AZWBOmSA@mail.gmail.com>
References: <CAOvdn6VWdOy1nNM+x3ogCCFXy8FExZjTJaV-s6SR7kbGu+REOA@mail.gmail.com>
	<20120607164034.GQ9472@phenom.dumpdata.com>
	<CAOvdn6WJ+Ub+LbhHKKQJi3AzsbCqX6-ksWhoxnZS5_OH=hkghQ@mail.gmail.com>
	<20120607174815.GU9472@phenom.dumpdata.com>
	<CAOvdn6VtmWyMo4SEAWT+ipJTHBTwPm+DZ1TXZT4q3UobFv=2DA@mail.gmail.com>
	<20120607180156.GX9472@phenom.dumpdata.com>
	<CAOvdn6UV1b89+wp4cfyj7ofU6T0=sdhNEoMZinPW=-AZWBOmSA@mail.gmail.com>
Date: Fri, 8 Jun 2012 09:13:34 -0400
X-Google-Sender-Auth: x2qQtogGon5tj5ZToeofwShnXm4
Message-ID: <CAOvdn6VNhi0O9fo7KUOV4Lrux=KBJ75hJOhhtozMPsp0FGB=Hg@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH] xen/hvc: Fix polling mode to work with kdb/kgdb
From: Ben Guthro <ben@guthro.net>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 4:07 PM, Ben Guthro <ben@guthro.net> wrote:

<snip>

> +#ifndef CONFIG_XEN
>        /*
>         * Wait for the other CPUs to be notified and be waiting for us:
>         */
>        while (kgdb_do_roundup && (atomic_read(&masters_in_kgdb) +
>                                atomic_read(&slaves_in_kgdb)) != online_cpus)
>                cpu_relax();
> +#endif
>
>        /*
>         * At this point the primary processor is completely


The cpu roundup seems to not be working as expected here.
While I get into the kgdb exception code on the master cpu - none of
the slave cpus ever get into the code that is counting them up.

Ignoring this CPU roundup is useful to get into the kdb code, but
probably not correct.

Does you have any thoughts as to why I might not be getting into this
code under Xen?
