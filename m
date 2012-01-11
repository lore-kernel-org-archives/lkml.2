Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934148Ab2AKWZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 17:25:51 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60613 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670Ab2AKWZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 17:25:49 -0500
MIME-Version: 1.0
In-Reply-To: <20237.63802.982209.699996@quad.stoffel.home>
References: <20120109181023.7c81d0be@annuminas.surriel.com>
 <4F0B7D1F.7040802@gmail.com> <4F0BABE0.8080107@redhat.com>
 <CAHGf_=qtpA5VTw5W0zaAhB2WCX1+-k59szTnDLnqDJeg+q9Jsw@mail.gmail.com>
 <CAHGf_=odfZxYS+PcMfeJ2ddFm76+-KbOLNrjGBtoEdExdQmL3Q@mail.gmail.com>
 <20237.39051.575883.450826@quad.stoffel.home> <alpine.DEB.2.00.1201111305440.31239@router.home>
 <20237.63802.982209.699996@quad.stoffel.home>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 11 Jan 2012 17:25:27 -0500
Message-ID: <CAHGf_=qcoYGi=t7DLJsmhU07g2sWoCTVs9+FZ8EG7Y7+O9D-KQ@mail.gmail.com>
Subject: Re: [PATCH -mm] make swapin readahead skip over holes
To: John Stoffel <john@stoffel.org>
Cc: Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Christoph> The assumptions by Kosaki are quite conservative.
>
> Just checking
>
> Christoph> What if one did not get a disk from the garbage heap but
> Christoph> instead has a state of the art storage cluster or simply an
> Christoph> SSD (in particular relevant now since HDs are in short
> Christoph> supply given the situation in Asia)?
>
> I don't know, I was just trying to make sure he thinks about disks
> which are slower than he expects, since there are lots of them still
> out there.

If you have a rotate disk, a bottoleneck is almost always IOPS, not
disk bandwidth.
at least when the systems are under swap-in, I can't imagine the system is under
disk bandwidth neck. Therefore we can eat free lunch if and only if we
don't increase
number of IOs.

In opposite, if you have much rich IO devices, that's more simple. You
don't need
worry about a few MB/s swap IO.
