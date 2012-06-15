Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab2FOQcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 12:32:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43334 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab2FOQcM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 12:32:12 -0400
Message-ID: <1339777914.2559.79.camel@twins>
Subject: Re: [PATCH V6 06/13] perf: Add Nehalem and Sandy Bridge uncore
 support
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, jolsa@redhat.com, eranian@google.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Date: Fri, 15 Jun 2012 18:31:54 +0200
In-Reply-To: <1339774107.2559.73.camel@twins>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
	 <1339741902-8449-7-git-send-email-zheng.z.yan@intel.com>
	 <1339774107.2559.73.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 17:28 +0200, Peter Zijlstra wrote:
> On Fri, 2012-06-15 at 14:31 +0800, Yan, Zheng wrote:
> > @@ -808,6 +994,14 @@ static int __init uncore_cpu_init(void)
> >         int ret, cpu;
> >  
> >         switch (boot_cpu_data.x86_model) {
> > +       case 26: /* Nehalem */
> > +       case 30:
> > +       case 37: /* Westmere */
> > +               msr_uncores = nhm_msr_uncores;
> > +               break;
> > +       case 42: /* Sandy Bridge */
> > +               msr_uncores = snb_msr_uncores;
> > +               break; 
> 
> What about WSP-EP (44)? Does it have an uncore similar to the regular
> WSM (37) or WSM-EX / Xeon-E7 (47) ?

I added the 44 and this seems to work.. that is, it didn't die due to
incorrect MSR access quite yet.
