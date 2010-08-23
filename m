Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab0HWNii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 09:38:38 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:37409 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752730Ab0HWNig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:38:36 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: mxjz8mwVM1mVl.cUcRZNdRHxYmmZSidSezii1MlmStShDXm
 smhZv5IR.3rftEetdW9gp3vpqwhAPxzagEtkZTMdM9cZtlLQ8jdADnl_wKDj
 SucHNC9a4W.8tS5okun6gbHSe5If65j3tkN94O.mGGMA21zhdajrgE6HK_S7
 WLHVBE3CRoMRPnMbx2.Z22IZMi9yJHkdN5gNoFc7o73F0.z2wAVeW5QMdp53
 h
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 23 Aug 2010 08:38:25 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 0/3] Reduce watermark-related problems with the per-cpu
 allocator V2
In-Reply-To: <20100823130127.GP19797@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1008230835220.5750@router.home>
References: <1282550442-15193-1-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1008230742300.4094@router.home> <20100823130127.GP19797@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010, Mel Gorman wrote:

> > The maximum time for which the livelock can exists is the vm stat
> > interval. By default the counters are brought up to date at least once per
> > second or if a certain delta was violated. Drifts are controlled by the
> > delta configuration.
> >
>
> While there is a maximum time (2 seconds I think) the drift can exist
> in, a machine under enough pressure can make a mess of the watermarks
> during that time. If it wasn't the case, these livelocks with 0 pages
> free wouldn't be happening.

So because we go way beyond the watermarks we reach a state in which a
livelock exists that does not go away when the counters are finally
updated?


