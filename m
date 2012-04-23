Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab2DWFKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 01:10:47 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:40926 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab2DWFKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 01:10:46 -0400
Date: Mon, 23 Apr 2012 07:10:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>
Subject: Re: [RFC] move link of vmlinux to a script
Message-ID: <20120423051041.GA6709@merkur.ravnborg.org>
References: <20120422212220.GA6537@merkur.ravnborg.org> <CACqU3MU7MS7MjpyiSx-tUJ6c3rSexUB5=vTGy6gPv_OJevuOqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACqU3MU7MS7MjpyiSx-tUJ6c3rSexUB5=vTGy6gPv_OJevuOqw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaud.

Thanks for the comments.

> > +# Link of vmlinux
> > +# $1 - optional extra .o files
> > +# $2 output file
> > +vmlinux_link()
> > +{
> > +       local lds=${srctree}/arch/${SRCARCH}/kernel/vmlinux.lds
> > +echo srcarch=${SRCARCH} CF=${CFLAGS_vmlinux}
> debugging leftover ?
yes - will be deleted.

> > +
> > +       local aflags="${KBUILD_AFLAGS} ${AFLAGS_KERNEL} ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS} ${modkern_aflags}"
> might be worse splitting that line.

I may be able to drop several of the variables,
otherwise yes.

> > +mksysmap()
> > +{
> > +       $NM -n $1 | \
> > +               grep -v '\( [aNUw] \)\|\(__crc_\)\|\( \$[adt]\)' > $2
> > +}
> > +
> you don't seem to consistently use #{FOO} vs. $FOO.

For arguments I use $FOO for the rest ${FOO}
I will fix this up to be consistent.

> > +# Update version
> > +info GEN .version
> > +if [ ! -r .version ]; then
> why '-r' specifically ? '-e' might be just enough.

I was so before - this part is a copy from the kernel.
And there is already enough changes..

> > +# final build of init/
> > +${MAKE} -f ${srctree}/scripts/Makefile.build obj=init
> > +
> are spaces allowed in `srctree' ? if so, this will break here.
Good catch.
Sticking "" around should do the trick? I will try to do so.
I should also try if it works with spaces - I think not.


> > +kallsymso=""
> > +kallsyms_vmlinux=""
> > +
> > +if [ "${CONFIG_KALLSYMS}" != "" ]; then
> > +
> [ -n "${CONFIG_KALLSYMS}" ] would work too, as well as the other
> places where you use the [ "${FOO}" != "" ] syntax.

Much more readable - will change.

	Sam
