Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab2DAJWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 05:22:46 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:60722 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab2DAJWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 05:22:44 -0400
Date: Sun, 1 Apr 2012 11:22:36 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Borislav Petkov <bp@amd64.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/4] tools: Add a toplevel Makefile
Message-ID: <20120401092236.GA15717@aftab>
References: <1333023957-22746-1-git-send-email-bp@amd64.org>
 <20120330052605.GA30508@merkur.ravnborg.org>
 <20120330161526.GE30876@aftab>
 <20120331084908.GA14149@gmail.com>
 <20120331184906.GA25809@merkur.ravnborg.org>
 <20120401084253.GB21108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120401084253.GB21108@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 10:42:53AM +0200, Ingo Molnar wrote:
> > Make will try to update the two targets "tools/perf" and "install"
> > in parallel. And it does not look easy to teach make that when you
> > specify the target "tools/*" then the install target should just
> > be ignored and passed down to the sub-make.
> > 
> > Anything that adds more complexity to the top-level Makefile should
> > be avoided if at all possible. It is un-maintainable as-is.
> > And the consistency issue is also important.
> > 
> > I know that if I do "make install" the kernel will be installed.
> > So one could argue that the same should apply to
> > the targets below tools/.
> > But then this should be for all targets and not just install.
> > If someone come up with a clean way to do so it is fine.
> > but the original proposal with "tinstall" just do not cut it.
> 
> 'tinstall' is definitely out, no argument about that.
> 
> Viable options are:
> 
>   tools/perf install
>   tools/perf_install
>   tools/perf-install
> 
> I'm fine with either one.

What Sam said - it is not that easy and probably cannot be done
without trickery to tell make that "install" becomes a sub-target when
"tools/<toolname>" is in front of it.

OTOH, "perf_install" is easily doable and the "perf-install" one with
the "-" could be misleading since all make targets have a "_" in their
names.

I'll redo the patchset with <toolname>_install targets since this is the
most straightforward option. In that case, if one wants to build and
install perf, she simply does

$ make tools/perf_install

and the same would work for the rest of the tools in there.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
