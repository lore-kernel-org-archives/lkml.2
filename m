Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab0DNM3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 08:29:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52949 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750715Ab0DNM3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 08:29:21 -0400
Date: Wed, 14 Apr 2010 13:32:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Chris Mason <chris.mason@oracle.com>, Mel Gorman <mel@csn.ul.ie>,
       Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Message-ID: <20100414133229.134264f0@lxorguk.ukuu.org.uk>
In-Reply-To: <8739yy9qnf.fsf@basil.nowhere.org>
References: <1271117878-19274-1-git-send-email-david@fromorbit.com>
	<20100413095815.GU25756@csn.ul.ie>
	<20100413111902.GY2493@dastard>
	<20100413193428.GI25756@csn.ul.ie>
	<20100413202021.GZ13327@think>
	<877hoa9wlv.fsf@basil.nowhere.org>
	<20100414112015.GO13327@think>
	<8739yy9qnf.fsf@basil.nowhere.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The only part of the 4K stack code that's good is the separate
> interrupt stack, but that one should be just combined with a sane 8K 
> process stack.

The reality is that if you are blowing a 4K process stack you are
probably playing russian roulette on the current 8K x86-32 stack as well
because of the non IRQ split. So it needs fixing either way
