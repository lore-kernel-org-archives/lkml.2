Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab2BAUGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 15:06:16 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:38012 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756722Ab2BAUGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 15:06:14 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: h1Qxum8VM1nngVj3zL9ehltE47Xt3aJ1LGQUc1vl835oI_c
 3nbRjvgqE2rRGRSmvni98loxaITou9FJ1aQRiQ4Pql9TJOSaOLvTGFp_kNKa
 qrGiEzPJiPbuNXEa_z1DAp6C9xbaEYYHWPNHfgnwwZsJgMb7SzTZIq7148n.
 psb2bxYYqrUk1AB7X720ZYK3x_.ENzd1I8zbAbUYZCNvtyQN4SG2gUIxMV85
 T22Ml9xxo5ZhTW.pUTU3hD84wX1uQHjjlIYJ7yhD4UTtI32diu5TunUduVSX
 oRGQOqyuc47r01O5_ClB41ePeJArrh.ORlzui7PuX8CIKlyvnzqaLrrJlzLW
 my17.akYxYSF1kILEb_dyUsRLDDP06vpKFgKik84L9yt5wN4vT0s2PV8GKPg
 mqxHLSRUhBQXsoxh47UEObuV4Qsk5pzFhSmKKSL1Nm3a3OVf6wBXCfd_M4CG
 1j.BYE.3tq01Llm51q53z1GpKDtDzJfxCZosFdyz9dWL3s3UU4gwa2mtSMoI
 K.LqiSOGLZjUJXY9A4tWeDjtyRNL6_t1MOwDB030Y3LFTxjLGKfDDHynl
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 1 Feb 2012 14:06:07 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
In-Reply-To: <20120201184045.GG2382@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1202011404500.2074@router.home>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com> <1327591185.2446.102.camel@twins> <CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com> <1328117722.2446.262.camel@twins> <20120201184045.GG2382@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Feb 2012, Paul E. McKenney wrote:

> On Wed, Feb 01, 2012 at 06:35:22PM +0100, Peter Zijlstra wrote:
> > On Sun, 2012-01-29 at 10:25 +0200, Gilad Ben-Yossef wrote:
> > >
> > > If this is of interest, I keep a list tracking global IPI and global
> > > task schedulers sources in the core kernel here:
> > > https://github.com/gby/linux/wiki.
> >
> > You can add synchronize_.*_expedited() to the list, it does its best to
> > bash the entire machine in order to try and make RCU grace periods
> > happen fast.
>
> I have duly added "Make synchronize_sched_expedited() avoid IPIing idle
> CPUs" to http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html.
>
> This should not be hard once I have built up some trust in the new
> RCU idle-detection code.  It would also automatically apply to
> Frederic's dyntick-idle userspace work.

Could we also apply the same approach to processors busy doing
computational work? In that case the OS is also not needed. Interrupting
these activities is impacting on performance and latency.

