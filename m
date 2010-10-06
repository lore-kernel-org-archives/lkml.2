Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759132Ab0JFPAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 11:00:42 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:58374 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536Ab0JFPAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 11:00:41 -0400
Date: Thu, 7 Oct 2010 00:00:35 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Matt Fleming <matt@console-pimps.org>, Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 4/7] ARM: oprofile: Move non-ARM code into separate init/exit
Message-ID: <20101006150035.GB3754@linux-sh.org>
References: <cover.1286222593.git.matt@console-pimps.org> <74092b0d162aafc21e408033cec6146e227363b5.1286222593.git.matt@console-pimps.org> <20101006133309.GP13563@erda.amd.com> <20101006144921.GQ13563@erda.amd.com> <20101006145311.GA3754@linux-sh.org> <20101006145903.GR13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006145903.GR13563@erda.amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 04:59:03PM +0200, Robert Richter wrote:
> On 06.10.10 10:53:11, Paul Mundt wrote:
> > On Wed, Oct 06, 2010 at 04:49:21PM +0200, Robert Richter wrote:
> > > On 06.10.10 15:33:09, Robert Richter wrote:
> > > > On 04.10.10 16:44:22, Matt Fleming wrote:
> > > > > -void __exit oprofile_arch_exit(void)
> > > > > +int __init oprofile_arch_init(struct oprofile_operations *ops)
> > > > > +{
> > > > 
> > > > We should do here a:
> > > > 
> > > > 	memset(ops, 0, sizeof(*ops));
> > > 
> > > Matt,
> > > 
> > > an alternative would be to move this to oprofile_perf_init() and
> > > modify ops->backtrace afterwards, but then we will lose the function's
> > > tail call. Not sure that is better. Paul, what do you think?
> > > 
> > I'm a bit confused as to why we just don't do:
> > 
> > ---
> > 
> > diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
> > index b336cd9..76d97a5 100644
> > --- a/drivers/oprofile/oprof.c
> > +++ b/drivers/oprofile/oprof.c
> > @@ -252,6 +252,8 @@ static int __init oprofile_init(void)
> >  {
> >  	int err;
> >  
> > +	memset(&oprofile_ops, 0, sizeof(struct oprofile_operations));
> > +
> 
> Yes, this looks much better. Thanks Paul.
> 
> 
In which case, if you want to take it:

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
