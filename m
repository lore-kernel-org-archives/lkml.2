Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab2CXWdL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 18:33:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990Ab2CXWdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 18:33:09 -0400
Date: Sat, 24 Mar 2012 23:33:07 +0100
From: Michal Marek <mmarek@suse.cz>
To: Bernhard Walle <bernhard@bwalle.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, lacombar@gmail.com,
        linux-kernel@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>, zippel@linux-m68k.org
Subject: Re: [PATCH] scripts/Kbuild.include: Fix portability problem of "echo
 -e"
Message-ID: <20120324223307.GC8947@sepie.suse.cz>
References: <1330277718-2667-1-git-send-email-bernhard@bwalle.de>
 <20120226174805.GA562@merkur.ravnborg.org>
 <4F4A7126.6020009@bwalle.de>
 <20120226210551.GA659@merkur.ravnborg.org>
 <4F677074.90906@bwalle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F677074.90906@bwalle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 06:44:20PM +0100, Bernhard Walle wrote:
> Am 26.02.12 22:05, schrieb Sam Ravnborg:
> > On Sun, Feb 26, 2012 at 06:51:34PM +0100, Bernhard Walle wrote:
> >> Am 26.02.12 18:48, schrieb Sam Ravnborg:
> >>>>> --- a/scripts/Kbuild.include
> >>>>> +++ b/scripts/Kbuild.include
> >>>>> @@ -104,7 +104,7 @@ as-option = $(call try-run,\
> >>>>>  # Usage: cflags-y += $(call as-instr,instr,option1,option2)
> >>>>>  
> >>>>>  as-instr = $(call try-run,\
> >>>>> -	/bin/echo -e "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))
> >>>>> +	printf "%b\n" "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))
> >>>>>  
> >>>>>  # cc-option
> >>>>>  # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
> >>> Roman Zippel removed use of printf in this patch: beda9f3a13bbb22cde92a45f230a02ef2afef6a9
> >>>
> >>> I cannot remember why - but it would be good if you could dig up
> >>> why - just so we do not hit an old issue again.
> >>
> >> Well, he used printf "$(1)", that's different from printf "%b\n" "$(1)"
> >> since format strings inside $(1) would be interpreted.
> > Makes good sense.
> 
> Can we merge that for 3.4? Who is responsible, i.e. whose tree?

I merged it to kbuild.git#kbuild now.

Michal
