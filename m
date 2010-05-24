Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab0EXRNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 13:13:40 -0400
Received: from relay3.sgi.com ([192.48.152.1]:37192 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757743Ab0EXRNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 13:13:39 -0400
Date: Mon, 24 May 2010 12:13:30 -0500
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tony Luck <tony.luck@intel.com>, Joe Perches <joe@perches.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Ben Woodard <woodard@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <bp@amd64.org>, "Young, Brent" <brent.young@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Russ Anderson <rja@sgi.com>
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100524171330.GC7145@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <4BF18995.6070008@redhat.com> <4BF2392A.9040409@jp.fujitsu.com> <4BF2C3D1.10009@redhat.com> <1274204560.17703.82.camel@Joe-Laptop.home> <20100518185305.GA23921@elte.hu> <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com> <20100518193022.GB30936@elte.hu> <20100518204204.GA23204@elte.hu> <AANLkTimPRvuoW5-OcPlPx5cvnCTJa7xhAQDSLrYziB4j@mail.gmail.com> <20100518220002.GA23739@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518220002.GA23739@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 12:00:02AM +0200, Ingo Molnar wrote:
> * Tony Luck <tony.luck@intel.com> wrote:
> 
> > [...] Getting from a machine check handler through some 
> > context switches (and page faults etc.) to a user level 
> > daemon before the error gets recorded looks to be really 
> > hard.
> 
> As Boris mentioned it too, critical policy action can and 
> will be done straight in the kernel.

That is how it is done in ia64.  The MCA interrupt 
handler does the low level handling.  It makes sure
all the cpus have rendezvoused, looks at the MCA record
to determine what happend and does whatever recovery 
steps are needed, such as kill the application.

It definitely needs to be handled in the kernel.

> 	Ingo

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
