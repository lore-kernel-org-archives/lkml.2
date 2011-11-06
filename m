Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab1KFTKW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 14:10:22 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:47756 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab1KFTKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 14:10:21 -0500
Subject: Re: [PATCH v2 6/6] slub: only preallocate cpus_with_slabs if
 offstack
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Matt Mackall <mpm@selenic.com>, Sasha Levin <levinsasha928@gmail.com>
In-Reply-To: <alpine.DEB.2.00.1111020351350.23788@router.home>
References: <1319385413-29665-1-git-send-email-gilad@benyossef.com>
	 <1319385413-29665-7-git-send-email-gilad@benyossef.com>
	 <alpine.DEB.2.00.1110272304020.14619@router.home>
	 <CAOtvUMcHOysen7betBOwEJAjL-UVzvBfCf0fzmmBERFrivkOBA@mail.gmail.com>
	 <alpine.DEB.2.00.1111020351350.23788@router.home>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sun, 06 Nov 2011 21:10:18 +0200
Message-ID: <1320606618.1428.76.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Oct 2011, Gilad Ben-Yossef wrote:
> > I think if it is up to me, I recommend going the simpler  route that
> > does the allocation in flush_all using GFP_ATOMIC for
> > CPUMASK_OFFSTACK=y and sends an IPI to all CPUs if it fails, because
> > it is simpler code and in the end I believe it is also correct.

On Wed, 2011-11-02 at 03:52 -0500, Christoph Lameter wrote:
> I support that. Pekka?

Sure. I'm OK with that. Someone needs to run some tests to make sure
it's working with low memory conditions when GFP_ATOMIC allocations
fail, though.

			Pekka

