Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab0DPWs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 18:48:28 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:36223 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932669Ab0DPWs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 18:48:26 -0400
Date: Sat, 17 Apr 2010 00:48:20 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 02/10] vmscan: move priority variable into scan_control
Message-ID: <20100416224820.GE20640@cmpxchg.org>
References: <1271352103-2280-1-git-send-email-mel@csn.ul.ie> <1271352103-2280-3-git-send-email-mel@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271352103-2280-3-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 06:21:35PM +0100, Mel Gorman wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> Now very lots function in vmscan have `priority' argument. It consume
> stack slightly. To move it on struct scan_control reduce stack.

I don't like this much because it obfuscates value communication.

Functions no longer have obvious arguments and return values, as it's all
passed hidden in that struct.

Do you think it's worth it?  I would much rather see that thing die than
expand on it...
