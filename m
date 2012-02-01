Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab2BAUO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 15:14:28 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:46505 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab2BAUO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 15:14:26 -0500
Date: Wed, 1 Feb 2012 12:13:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
Message-ID: <20120201201336.GI2382@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com>
 <1327591185.2446.102.camel@twins>
 <CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com>
 <1328117722.2446.262.camel@twins>
 <20120201184045.GG2382@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1202011404500.2074@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202011404500.2074@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020120-2398-0000-0000-000003DD3D8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 02:06:07PM -0600, Christoph Lameter wrote:
> On Wed, 1 Feb 2012, Paul E. McKenney wrote:
> 
> > On Wed, Feb 01, 2012 at 06:35:22PM +0100, Peter Zijlstra wrote:
> > > On Sun, 2012-01-29 at 10:25 +0200, Gilad Ben-Yossef wrote:
> > > >
> > > > If this is of interest, I keep a list tracking global IPI and global
> > > > task schedulers sources in the core kernel here:
> > > > https://github.com/gby/linux/wiki.
> > >
> > > You can add synchronize_.*_expedited() to the list, it does its best to
> > > bash the entire machine in order to try and make RCU grace periods
> > > happen fast.
> >
> > I have duly added "Make synchronize_sched_expedited() avoid IPIing idle
> > CPUs" to http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html.
> >
> > This should not be hard once I have built up some trust in the new
> > RCU idle-detection code.  It would also automatically apply to
> > Frederic's dyntick-idle userspace work.
> 
> Could we also apply the same approach to processors busy doing
> computational work? In that case the OS is also not needed. Interrupting
> these activities is impacting on performance and latency.

Yep, that is in fact what Frederic's dyntick-idle userspace work does.

							Thanx, Paul

