Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab1DUTbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:31:45 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47227 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719Ab1DUTbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:31:43 -0400
Message-ID: <4DB0861D.2000701@kernel.dk>
Date: Thu, 21 Apr 2011 21:31:41 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: unexport DISK_EVENT_MEDIA_CHANGE for legacy/fringe
  drivers
References: <20110421190031.GJ15988@htj.dyndns.org>
In-Reply-To: <20110421190031.GJ15988@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-21 21:00, Tejun Heo wrote:
> In-kernel disk event polling doesn't matter for legacy/fringe drivers
> and may lead to infinite event loop if ->check_events() implementation
> generates events on level condition instead of edge.
> 
> Now that block layer supports suppressing exporting unlisted events,
> simply leaving disk->events cleared allows these drivers to keep the
> internal revalidation behavior intact while avoiding weird
> interactions with userland event handler.

Seems like the good thing to do, I'll queue this up for 2.6.39.

-- 
Jens Axboe

