Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab2C1Jvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 05:51:32 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:49231 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2C1Jvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 05:51:31 -0400
Date: Wed, 28 Mar 2012 11:51:25 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@amd64.org>, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] tools: Add a toplevel Makefile
Message-ID: <20120328095125.GA16369@aftab>
References: <1332513788-9726-1-git-send-email-bp@amd64.org>
 <20120324074412.GE20145@gmail.com>
 <20120326122632.GC32090@aftab>
 <20120326151432.GA8527@gmail.com>
 <20120326154132.GJ32090@aftab>
 <20120328072528.GA22885@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328072528.GA22885@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 09:25:28AM +0200, Ingo Molnar wrote:
> 
> * Borislav Petkov <bp@amd64.org> wrote:
> 
> > On Mon, Mar 26, 2012 at 05:14:32PM +0200, Ingo Molnar wrote:
> > > 
> > > * Borislav Petkov <bp@amd64.org> wrote:
> > > 
> > > > On Sat, Mar 24, 2012 at 08:44:12AM +0100, Ingo Molnar wrote:
> > > > > Could this also be accessible via 'make tools' in the toplevel 
> > > > > Makefile?
> > > > > 
> > > > > I'd love to be able to type:
> > > > > 
> > > > >   make -j tools perf install
> > > > 
> > > > Well,
> > > > 
> > > > you could do
> > > > 
> > > > $ make -j -C tools perf
> > > 
> > > Arguably I could also type:
> > > 
> > >   cd tools/perf; make -j install
> > > 
> > > :-)
> > > 
> > > So I just wanted to bring this up, that integrating it into the 
> > > top level Makefile might make sense. Or not.
> > 
> > Right,
> > 
> > so from dealing with make in the last days, I can say that it's not a
> > fun walk in the park :). The problem is having multiple targets like the
> > following:
> > 
> > $ make -j tools perf install
> > 
> > I have to be able to differentiate in the Makefile which of the targets
> > is a directory ("tools"), which is the actual tool name to build
> > ("perf") and which is a special target ("install") which relates to the
> > tool name coming before it on the command line and is not the "install"
> > target of the main Makefile.
> > 
> > And it becomes nasty very fast if you reorder them
> > 
> > $ make -j install perf tools
> > 
> > where all that sequential info doesn't mean anything anymore.
> > 
> > So, the question is, what we actually want?
> > 
> > $ make -j tools perf install
> > 
> > is pretty cryptic wrt to which target we're actually building and having
> > the -C switch makes stuff a bit clearer IMHO:
> > 
> > $ make -j -C tools perf install
> > 
> > Also, having "install" as the last target means IMO to build the tool
> > before it and then install it.
> > 
> > In the end of the day, probably the most important thing is what is
> > the use case for tools/ which makes most sense. I definitely think the
> > 'help' target is a step in that direction. Being able to do
> > 
> > $ make -C tools
> > 
> > and it give you a short description is pretty helpful.
> > 
> > How about we have:
> > 
> > make tools-<toolname> install
> > 
> > or
> > 
> > make tools/perf install
> > 
> > from the toplevel kernel directory? Would that make more sense from a
> > usability perspective?
> 
> I have no strong preference currently. I think since it affects 
> kbuild it would be nice to know the opinion of the kbuild folks 
> (Cc:-ed): how should the integration of tools/ proceed?

Btw,

I'm currently thinking I want to give the make tools/{perf,help,...}
approach a try because it is clear that it is a subdir of the kernel src
tree and it probably could support all the targets we thought about.

Let me play around with it a bit...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
