Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936Ab2CNOvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 10:51:21 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62368 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab2CNOvS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 10:51:18 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <alpine.DEB.2.00.1203140908010.5485@router.home>
References: <CAOtvUMdVrjUHLx2jZ2xbpBoDBMCX8sdCASEkmXCtBrU-gQ3EhQ@mail.gmail.com>
	<alpine.DEB.2.00.1203140908010.5485@router.home>
Date: Wed, 14 Mar 2012 16:51:15 +0200
Message-ID: <CAOtvUMcPEbG0_CTazCgf0Tb4kinzP+nmhjWQL=Juok_Bxc-r5A@mail.gmail.com>
Subject: Re: [PATCH] mm: fix vmstat_update to keep scheduling itself on all cores
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 4:09 PM, Christoph Lameter <cl@linux.com> wrote:
> On Wed, 14 Mar 2012, Gilad Ben-Yossef wrote:
>
>> We set up per-cpu work structures for vmstat and schedule them on
>> each cpu when they go online only to re-schedule them on the general
>> work queue when they first run.
>
> schedule_delayed_work queues on the current cpu unless the
> WQ_UNBOUND flag is set. Which is not set for vmstat_work.

I've missed that. My bad. Sorry for the noise.

Gilad



-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
