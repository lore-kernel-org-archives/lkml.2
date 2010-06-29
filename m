Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab0F2Knk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:43:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56478 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab0F2Knj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:43:39 -0400
Subject: Re: [PATCH] avoid race condition in pick_next_task_fair in 
 kernel/sched_fair.c
From: Peter Zijlstra <peterz@infradead.org>
To: shenghui <crosslonelyover@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Greg KH <greg@kroah.com>
In-Reply-To: <AANLkTin49UHeVhfS-iFwWvPIg29HPhXaP3DorBAa-a0I@mail.gmail.com>
References: <AANLkTin49UHeVhfS-iFwWvPIg29HPhXaP3DorBAa-a0I@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 29 Jun 2010 12:43:35 +0200
Message-ID: <1277808215.1868.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-29 at 15:10 +0800, shenghui wrote:
> I think some lock on the metadata can fix this issue, but we may
> change plenty of code to add support for lock. I think the easist
> way is just substacting nr_running before dequing tasks. 

But all that is fully serialized by the rq->lock.. so I'm really not
seeing how this can happen.


