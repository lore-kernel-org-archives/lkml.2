Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab0GZH22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 03:28:28 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:39866 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab0GZH20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 03:28:26 -0400
Date: Mon, 26 Jul 2010 09:28:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tim Abbott <tabbott@ksplice.com>, Tim Bird <tim.bird@am.sony.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Michal Marek <mmarek@suse.cz>,
        Parisc List <linux-parisc@vger.kernel.org>
Subject: Re: Testing of function/data-sections on linux-2.6.35-rc4
Message-ID: <20100726072825.GC10061@merkur.ravnborg.org>
References: <201007181703.17022.vda.linux@googlemail.com> <20100723203543.GB27288@merkur.ravnborg.org> <201007260331.34372.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007260331.34372.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 03:31:34AM +0200, Denys Vlasenko wrote:
> Hi Sam,
> 
> On Friday 23 July 2010 22:35, Sam Ravnborg wrote:
> > > 
> > > Then, in order to also garbage-collect the sections, I added
> > > 
> > > LDFLAGS_vmlinux += --gc-sections
> > > 
> > > in top-level Makefile.
> > > 
> > > This requires the additional patch (linux-2.6.35-rc4-fsgs.patch)
> > > which adds KEEP(section) directives to kernel linker stripts.
> > > Otherwise, linker will discard some crucial sections.
> > > 
> > 
> > Changelog does not address why you need:
> > 
> >      -Map $@.ldmap
> > 
> > and what effect they have.
> 
> I didn't plan to push the last step (--gc-sections) to mainline yet.
> Thus the patch has debugging stuff in it.
> 
> 
> > And it is obvious that some archs should consolidate a little more from
> > asm-generic/vmlinux.lds.h.
> > But that said this patch looks much better than the initial versions posted.
> > 
> > How do you determine which sections needs the KEEP()?
> > Worth documenting for future when we add new sections.
> 
> No problem, I will be adding comments at every KEEP() why it's needed.

A general comment in vmlinux.lds.h and a careful explanation
in the changelog should be enough.

You should not comment each of the KEEP().

	Sam
