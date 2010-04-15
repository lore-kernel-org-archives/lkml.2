Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab0DOO51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 10:57:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33267 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab0DOO5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 10:57:25 -0400
To: Dave Chinner <david@fromorbit.com>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
From: Andi Kleen <andi@firstfloor.org>
References: <20100413202021.GZ13327@think> <20100414014041.GD2493@dastard>
	<20100414155233.D153.A69D9226@jp.fujitsu.com>
	<20100414072830.GK2493@dastard> <20100414085132.GJ25756@csn.ul.ie>
	<20100415013436.GO2493@dastard>
Date: Thu, 15 Apr 2010 16:57:20 +0200
In-Reply-To: <20100415013436.GO2493@dastard> (Dave Chinner's message of "Thu, 15 Apr 2010 11:34:36 +1000")
Message-ID: <87y6go931r.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:
>
> How about this? For now, we stop direct reclaim from doing writeback
> only on order zero allocations, but allow it for higher order
> allocations. That will prevent the majority of situations where

And also stop it always with 4K stacks.

> direct reclaim blows the stack and interferes with background
> writeout, but won't cause lumpy reclaim to change behaviour.
> This reduces the scope of impact and hence testing and validation
> the needs to be done.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
