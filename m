Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab2BFRWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:22:39 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:25198 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab2BFRWi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:22:38 -0500
MIME-Version: 1.0
Message-ID: <69f22464-d460-450c-a81b-77bda8cc7568@default>
Date: Mon, 6 Feb 2012 09:22:26 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Wilk <konrad.wilk@oracle.com>, Jan Beulich <JBeulich@suse.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: RE: [PATCH] xen/tmem: cleanup
References: <4F2C06A00200007800071071@nat28.tlf.novell.com>
 <d86f0be9-1530-47bd-b3fd-8c251e563b25@default>
 <4F2F998202000078000714CD@nat28.tlf.novell.com>
 <e871af1b-8003-4d3d-8fde-ea40545ff9fe@default>
 <4F3012B602000078000716AB@nat28.tlf.novell.com>
 <20120206170224.GD23240@phenom.dumpdata.com>
In-Reply-To: <20120206170224.GD23240@phenom.dumpdata.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4F300C55.00C4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk
> Subject: Re: [PATCH] xen/tmem: cleanup
> 
> On Mon, Feb 06, 2012 at 04:49:42PM +0000, Jan Beulich wrote:
> > >>> On 06.02.12 at 17:37, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> > >>  From: Jan Beulich [mailto:JBeulich@suse.com]
> > >> Sent: Monday, February 06, 2012 1:13 AM
> > >> To: Dan Magenheimer
> > >> Cc: Jeremy Fitzhardinge; xen-devel@lists.xensource.com; Konrad Wilk;
> > > linux-kernel@vger.kernel.org
> > >> Subject: RE: [PATCH] xen/tmem: cleanup
> > >>
> > >> >>> On 04.02.12 at 17:42, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> > >> >>  From: Jan Beulich [mailto:JBeulich@suse.com]
> > >> >> Subject: [PATCH] xen/tmem: cleanup
> > >> >>
> > >> >> Use 'bool' for boolean variables. Do proper section placement.
> > >> >> Eliminate an unnecessary export.
> > >> >>
> > >> >> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> > >> >> Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
> > >> >>
> > >> >> -int tmem_enabled __read_mostly;
> > >> >> -EXPORT_SYMBOL(tmem_enabled);
> > >> >> +bool __read_mostly tmem_enabled = false;
> > >> >
> > >> > tmem_enabled is used in xen/drivers/xen-selfballoon.c
> > >>
> > >> Which can't be built as a module, and hence the symbol doesn't need
> > >> exporting. This patch (of course, I'm tempted to say) survived build
> > >> testing.
> > >
> > > Yes, correct.  BUT... I think only the reason xen-selfballoon.c
> > > can't be built as a module is because the MM variable vm_committed_as
> > > (or an access function) is not exported.  Ideally xen-selfballoon.c
> > > probably should be a module but putting a core MM change in
> > > the critical path of a Xen-only-related enhancement seemed
> > > a recipe for sure failure.
> >
> > No, this isn't the main reason (as you say further down, this could
> > easily be adjusted for) afaict. The main reason is that
> > register_xen_selfballooning() is being called from non-modular
> > code (xen-balloon.c), which could be made a module too, but in
> > turn has at least one reference that wouldn't be nice to become
> > an export (balloon_set_new_target()).

Jan, you're right, I had forgotten about that "chained" dependency.
Thanks and FWIW, on the entire original patch:

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
 
> It would be nice if all of it could become modules. That way HVM
> device driver domains could load the whole thing without having much
> built-in code in the kernel.
> 
> Is it possible to do that?

Konrad, my module expertise is very low, so I will leave that
to Jan or someone else to answer or look into.

Dan
