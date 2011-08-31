Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab1HaXiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 19:38:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223Ab1HaXiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 19:38:21 -0400
Date: Wed, 31 Aug 2011 16:37:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <jweiner@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>,
        Balbir Singh <bsingharora@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [patch 1/2] mm: vmscan: fix force-scanning small targets
 without swap
Message-Id: <20110831163706.2b7ed5af.akpm@linux-foundation.org>
In-Reply-To: <20110829160839.GA22439@redhat.com>
References: <1313094715-31187-1-git-send-email-jweiner@redhat.com>
	<20110829160839.GA22439@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011 18:08:39 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> Andrew,
> 
> On Thu, Aug 11, 2011 at 10:31:54PM +0200, Johannes Weiner wrote:
> > Without swap, anonymous pages are not scanned.  As such, they should
> > not count when considering force-scanning a small target if there is
> > no swap.
> > 
> > Otherwise, targets are not force-scanned even when their effective
> > scan number is zero and the other conditions--kswapd/memcg--apply.
> 
> I forgot to mention, this patch is a fix for '246e87a memcg: fix
> get_scan_count() for small targets', which went upstream this merge
> window.
> 
> Probably makes sense to merge this one too before the release..?
> 

Ah, I didn't realise that.  Thanks.
