Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab2A0JQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 04:16:53 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:53630 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab2A0JQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 04:16:51 -0500
Date: Fri, 27 Jan 2012 14:46:40 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Indan Zupancic <indan@nul.nu>, Youquan Song <youquan.song@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 1/2] sched: unified sched_powersavings sysfs
 tunable
Message-ID: <20120127091640.GB8897@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20120116161740.29759.4679.stgit@localhost>
 <20120116162241.29759.13220.stgit@localhost>
 <1327503446.2614.77.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1327503446.2614.77.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12012623-9264-0000-0000-000000B54B01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2012-01-25 15:57:26]:

> On Mon, 2012-01-16 at 21:52 +0530, Vaidyanathan Srinivasan wrote:
> > +enum powersavings_level {
> > +       POWERSAVINGS_DISABLED = 0,      /* Max performance */
> > +       POWERSAVINGS_DEFAULT,           /* Kernel default policy, automatic powersave */
> > +                                       /* vs performance tradeoff */
> > +       POWERSAVINGS_MAX                /* Favour power savings over peformance */
> >  }; 
> 
> I don't like that, I can get, OFF, AUTO, ON, but to overload that with
> different policies for AUTO and ON just reeks.

How about this:

enum powersavings_level {
       POWERSAVINGS_OFF = 0,           /* Max performance */
       POWERSAVINGS_AUTO,              /* Kernel default policy, automatic powersave */
                                       /* vs performance tradeoff */
       POWERSAVINGS_ON                 /* Max power savings */
}; 
 
Basically AUTO is where we have a 'policy' or heuristics, but simple
straight forward decisions for OFF and ON case. 

--Vaidy

