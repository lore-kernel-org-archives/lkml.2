Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab1G2PYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 11:24:50 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:28554 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751299Ab1G2PYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 11:24:49 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: pA3ZsxUVM1nbDjI2I0G6b4ESUHDS.TE2zYKNU2E6A8M4V1V
 aVr6n7I7LZZ5mHIcZASgQh7Q.5E9wwZ0AjeHPjrmXtAolQUqeeb.dLugVy9X
 tcME08Uz4lBV3hfak63CVE0Y9gm.V15HgCzP2CIET9ojObBytD0Ns4WG91Ii
 THzWGHGFP5QMcke9es_X7XiN6G9aFnksmxcNWXCVLXwqsfmI3r7BXUa5Qgej
 Lh.IzVUilAMpKgonhMB2YKBUGB4N6.DugoHqHSkPuNDzI._pXybAi7FTv7mZ
 Lg_A5T6xyupDBqge9Fy_krlNy35e26tyX5giAIzHY.NnfOlmb
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 29 Jul 2011 10:24:45 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v3.1-rc0
In-Reply-To: <alpine.DEB.2.00.1107281514080.29344@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1107291023000.16178@router.home>
References: <alpine.DEB.2.00.1107221108190.2996@tiger> <CAOJsxLHniS9Hx+ep_i2qbE_Oo6PnkNCK5dNARW5egg9Bso4Ovg@mail.gmail.com> <alpine.DEB.2.00.1107281514080.29344@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jul 2011, David Rientjes wrote:

> On Thu, 28 Jul 2011, Pekka Enberg wrote:
>
> > Christoph, your debugging fix has been in linux-next for few days now
> > and no problem have been reported. I'm considering sending the series
> > to Linus. What do you think?
> >
>
> I ran slub/lockless through some stress testing and it seems to be quite
> stable on my testing cluster.  There is about a 2.3% performance
> improvement with the lockless slowpath on the netperf benchmark with
> various thread counts on my 16-core 64GB Opterons, so I'd recommend it to
> be merged into 3.1.

Great. Could you also test the next stage of patches (not yet even in
Pekka's tree) where we add a per cpu cache of partial allocated slab
pages? This decreases the per node lock contention further. I can repost
the set if the old one does not work for you. Shows significant
improvement here as well.



