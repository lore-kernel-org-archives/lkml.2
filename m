Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab0JPR06 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 13:26:58 -0400
Received: from canuck.infradead.org ([134.117.69.58]:35102 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab0JPR05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 13:26:57 -0400
Subject: Re: [PATCH 03/19] fs: Convert nr_inodes and nr_unused to per-cpu
 counters
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1287224852.2799.130.camel@edumazet-laptop>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
	 <1287216853-17634-4-git-send-email-david@fromorbit.com>
	 <1287217776.2799.69.camel@edumazet-laptop>  <20101016100441.GP4681@dastard>
	 <1287224852.2799.130.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 16 Oct 2010 19:26:48 +0200
Message-ID: <1287250008.1998.123.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-16 at 12:27 +0200, Eric Dumazet wrote:
> 
> In cases you mention, you want a precise count (aka
> percpu_counter_sum_positive()), not the approximate one (aka
> percpu_counter_read_positive()).
> 
> The only difference is then the possible/online cpu loop difference.
> 
In either case, SGI is screwed, doing millions of for_each_*_cpu() loops
per second isn't going to work for them.

fwiw, for_each_*_cpu() takes longer than a single jiffy tick on those
machines.
