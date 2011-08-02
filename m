Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab1HBOK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 10:10:57 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:44482 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750972Ab1HBOKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 10:10:50 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: wzvU3sUVM1n8jRiMxKhjIWLXY33MnIGIm5hkcw8_s1qqhSr
 ejpFnggptFbi1OBlnqZkUT5lWNrPdLETjFrDF5p9uARJlSHpb6thMFUA.fBn
 XZtOsnki8yYuNfbiQyAlkMmhza8nCTBf3v5_sZu8SWFSJ8qbMBikQDktL39q
 NIwdu0VnwLcynYglC1X456ryljGB.k_g2mtJMXkbFKsUQ7Ej0k5C5RWAgxP.
 2rDhrlmNtyEzry6.k4xPvT6nL16lmMQRRJlYmQ9tm7iSGxXsMjjZz7OCDG_j
 9QupOBjGbK46U1UXBLo_VnT_m.DHzlVgoCE8Eyu2D.Rz9hbH.JX5YMFmTo28
 mQNNkKCmx3t7XUO_TBH1876jg
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 2 Aug 2011 09:10:46 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
        tj@kernel.org, Metathronius Galabant <m.galabant@googlemail.com>,
        Matt Mackall <mpm@selenic.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Adrian Drzewiecki <z@drze.net>, linux-kernel@vger.kernel.org
Subject: Re: [slub p3 0/7] SLUB: [RFC] Per cpu partial lists V3
In-Reply-To: <alpine.DEB.2.00.1108012112420.7373@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1108020909100.18524@router.home>
References: <20110801162823.755182213@linux.com> <alpine.DEB.2.00.1108012112420.7373@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Aug 2011, David Rientjes wrote:

>
> This applied nicely to Linus' tree so I've moved to testing atop that
> rather than slub/lockless on the same netperf testing environment as the
> slab vs. slub comparison.  The benchmarking completed without error and
> here are the results:
>
> 	threads		before		after
> 	 16		75509		75443  (-0.1%)
> 	 32		118121		117558 (-0.5%)
> 	 48		149997		149514 (-0.3%)
> 	 64		185216		186772 (+0.8%)
> 	 80		221195		222612 (+0.6%)
> 	 96		239732		241089 (+0.6%)
> 	112		261967		266643 (+1.8%)
> 	128		272946		281794 (+3.2%)
> 	144		279202		289421 (+3.7%)
> 	160		285745		297216 (+4.0%)
>
> So the patchset certainly looks helpful, especially if it improves other
> benchmarks as well.

The problem is that the partial approach has not been fine tuned yet for
these larger loads. And the proper knobs are not implemented yet.

> I'll review the patches individually, starting with the cleanup patches
> that can hopefully be pushed quickly while we discuss per-cpu partial
> lists further.

I am currently reworking the patches to operate on a linked list instead
of a very small array of pointers to page structs. That will allow much
larger per cpu partial lists and a dynamic configuration of the sizes.

