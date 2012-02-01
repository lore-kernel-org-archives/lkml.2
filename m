Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab2BASlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 13:41:40 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:45698 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab2BASli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 13:41:38 -0500
Date: Wed, 1 Feb 2012 10:40:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, Chris Metcalf <cmetcalf@tilera.com>,
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
Message-ID: <20120201184045.GG2382@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com>
 <1327591185.2446.102.camel@twins>
 <CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com>
 <1328117722.2446.262.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328117722.2446.262.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020118-6148-0000-0000-00000313EAD8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 06:35:22PM +0100, Peter Zijlstra wrote:
> On Sun, 2012-01-29 at 10:25 +0200, Gilad Ben-Yossef wrote:
> > 
> > If this is of interest, I keep a list tracking global IPI and global
> > task schedulers sources in the core kernel here:
> > https://github.com/gby/linux/wiki. 
> 
> You can add synchronize_.*_expedited() to the list, it does its best to
> bash the entire machine in order to try and make RCU grace periods
> happen fast.

I have duly added "Make synchronize_sched_expedited() avoid IPIing idle
CPUs" to http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html.

This should not be hard once I have built up some trust in the new
RCU idle-detection code.  It would also automatically apply to
Frederic's dyntick-idle userspace work.

							Thanx, Paul

