Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab2BAR6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:58:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50814 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2BAR63 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:58:29 -0500
Message-ID: <1328119072.2446.264.camel@twins>
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
From: Peter Zijlstra <peterz@infradead.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>, paulmck <paulmck@linux.vnet.ibm.com>
Date: Wed, 01 Feb 2012 18:57:52 +0100
In-Reply-To: <1328117722.2446.262.camel@twins>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com>
	 <1327591185.2446.102.camel@twins>
	 <CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com>
	 <1328117722.2446.262.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-01 at 18:35 +0100, Peter Zijlstra wrote:
> On Sun, 2012-01-29 at 10:25 +0200, Gilad Ben-Yossef wrote:
> > 
> > If this is of interest, I keep a list tracking global IPI and global
> > task schedulers sources in the core kernel here:
> > https://github.com/gby/linux/wiki. 
> 
> You can add synchronize_.*_expedited() to the list, it does its best to
> bash the entire machine in order to try and make RCU grace periods
> happen fast.

Also anything using stop_machine, such as module unload, cpu hot-unplug
and text_poke().
