Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab2DFRjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 13:39:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57665 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab2DFRjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 13:39:19 -0400
Message-ID: <4F7F2A3D.3010700@kernel.dk>
Date: Fri, 06 Apr 2012 11:39:09 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]block: make auto block plug flush threshold per-disk based
References: <4F7F2765.3090003@kernel.org>
In-Reply-To: <4F7F2765.3090003@kernel.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-06 11:27, Shaohua Li wrote:
> We do auto block plug flush to reduce latency, the threshold is 16
> requests. This works well if the task is accessing one or two drives.
> The problem is if the task is accessing a raid 0 device and the raid
> disk number is big, say 8 or 16, 16/8 = 2 or 16/16=1, we will have
> heavy lock contention.
> 
> This patch makes the threshold per-disk based. The latency should be
> still ok accessing one or two drives. The setup with application
> accessing a lot of drives in the meantime uaually is big machine,
> avoiding lock contention is more important, because any contention
> will actually increase latency.

Thanks, applied. It should have been per-queue all along, so this
makes a lot of sense.

-- 
Jens Axboe

