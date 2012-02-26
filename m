Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab2BZVFy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 16:05:54 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:20646 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab2BZVFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 16:05:53 -0500
Date: Sun, 26 Feb 2012 22:05:51 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Bernhard Walle <bernhard@bwalle.de>
Cc: mmarek@suse.cz, lacombar@gmail.com, linux-kernel@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>, zippel@linux-m68k.org
Subject: Re: [PATCH] scripts/Kbuild.include: Fix portability problem of
	"echo -e"
Message-ID: <20120226210551.GA659@merkur.ravnborg.org>
References: <1330277718-2667-1-git-send-email-bernhard@bwalle.de> <20120226174805.GA562@merkur.ravnborg.org> <4F4A7126.6020009@bwalle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4A7126.6020009@bwalle.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 26, 2012 at 06:51:34PM +0100, Bernhard Walle wrote:
> Am 26.02.12 18:48, schrieb Sam Ravnborg:
> >> > --- a/scripts/Kbuild.include
> >> > +++ b/scripts/Kbuild.include
> >> > @@ -104,7 +104,7 @@ as-option = $(call try-run,\
> >> >  # Usage: cflags-y += $(call as-instr,instr,option1,option2)
> >> >  
> >> >  as-instr = $(call try-run,\
> >> > -	/bin/echo -e "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))
> >> > +	printf "%b\n" "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))
> >> >  
> >> >  # cc-option
> >> >  # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
> > Roman Zippel removed use of printf in this patch: beda9f3a13bbb22cde92a45f230a02ef2afef6a9
> > 
> > I cannot remember why - but it would be good if you could dig up
> > why - just so we do not hit an old issue again.
> 
> Well, he used printf "$(1)", that's different from printf "%b\n" "$(1)"
> since format strings inside $(1) would be interpreted.
Makes good sense.

> 
> But maybe Roman can comment on that? Cc'ing him.
Would be good to hear from Roman - but he has been MIA for some years now :-(

	Sam
