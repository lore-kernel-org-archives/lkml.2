Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935487Ab0KQUYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 15:24:38 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:37053 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935355Ab0KQUYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 15:24:37 -0500
Date: Wed, 17 Nov 2010 21:24:34 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: dirk.brandewie@gmail.com, Michal Marek <mmarek@suse.cz>,
        devicetree-discuss@lists.ozlabs.org, sodaville@linutronix.de,
        arjan@linux.intel.com, linuxppc-dev@lists.ozlabs.org,
        microblaze-uclinux@itee.uq.edu.au, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] of: Add support for linking device tree blobs into
	vmlinux
Message-ID: <20101117202434.GA20441@merkur.ravnborg.org>
References: <cover.1289943240.git.dirk.brandewie@gmail.com> <9129f0a21ea48fb2dcb89cea290e88f3e8c0d8a2.1289943240.git.dirk.brandewie@gmail.com> <20101117092751.GA19781@merkur.ravnborg.org> <20101117180723.GA7550@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117180723.GA7550@angua.secretlab.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +
> > > +DTC = $(objtree)/scripts/dtc/dtc
> > > +
> > > +quiet_cmd_dtc = DTC	$@
> > Please avoid tabs in the output - all other uses spaces. (There is a tab between DTC and $@)
> > 
> > > +      cmd_dtc = $(DTC) -O dtb -o $(obj)/$*.dtb -b 0 $(DTS_FLAGS) $(src)/dts/$*.dts
> > 
> > Looks strange. How about:
> >       cmd_dtc = $(DTC) -O dtb -o $@ -b 0 $(DTS_FLAGS) $<
> > 
> > Then you avoid the hardcoded path in the rule too.
> > 
> > 
> > > +
> > > +$(obj)/%.dtb: $(src)/dts/%.dts
> > > +	$(call if_changed,dtc)
> 
> The rule should be generic (not depend on the presence of a dts
> subdirectory.  Basically, the .dtb really should be generated in the
> same directory as the .dts file.  There is no reason for this rule to
> have special behaviour.
> 
> > 
> > This snippet belong in the file that uses this.
> > This is how we do for other rules like bzip etc.
> 
> This rule is intended to be generic and usable anywhere in the tree.
I understand this.
But only few people will recognize this so they see something like this:

obj-y := foo.dtb.o

And they look for a file named foo.dtb.S or foo.dtb.c.

If we spell it out then we have a better chance to allow
people to understand the relation ships between the files.


If we really want to hide this in scipts/Makefile.* then Makefile.build
is the logical places to do so.
Makefile.lib is supposed to be stuff that is relavent for more than
one Makefile in scripts/* but it has unfortunately also grown
some of the boot support stuff.

Today there is a single rule related to _shipped files.
We should not fill it up with additional rules - put them
Makefile.build if we really want to avoid them in boot/Makefile.

	Sam
