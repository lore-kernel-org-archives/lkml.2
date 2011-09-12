Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab1ILK2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 06:28:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:47737 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab1ILK2t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 06:28:49 -0400
Subject: Re: [PATCH 14/18] writeback: control dirty pause time
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 12 Sep 2011 12:28:05 +0200
In-Reply-To: <20110907020214.GA13755@localhost>
References: <20110904015305.367445271@intel.com>
	 <20110904020916.460538138@intel.com> <1315324285.14232.16.camel@twins>
	 <20110907020214.GA13755@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315823285.26517.27.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 10:02 +0800, Wu Fengguang wrote:
> > also, do the two other line segments connect on the transition
> > point?
> 
> I guess we can simply unify the other two formulas into one:
> 
>         } else if (period <= max_pause / 4 &&
>                  pages_dirtied >= current->nr_dirtied_pause) {
>                 current->nr_dirtied_pause = clamp_val(
> ==>                                     dirty_ratelimit * (max_pause / 2) / HZ,
>                                         pages_dirtied + pages_dirtied / 8,
>                                         pages_dirtied * 4);
>         } else if (pause >= max_pause) {
>                 current->nr_dirtied_pause = 1 | clamp_val(
> ==>                                     dirty_ratelimit * (max_pause / 2) / HZ,
>                                         pages_dirtied / 4,
>                                         pages_dirtied - pages_dirtied / 8);
>         } 


There's still the clamping, that combined with the various conditionals
make it very hard to tell if the functions are connected or jump around.
