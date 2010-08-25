Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab0HYOZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 10:25:31 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:33238 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab0HYOZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 10:25:29 -0400
Subject: Re: [PATCH] workqueue: fix cwq->nr_active underflow
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4C74DE62.6040208@kernel.org>
References: <4C74D9E4.5070403@kernel.org>
	 <1282727501.3685.7.camel@jlt3.sipsolutions.net>
	 <4C74DE62.6040208@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 16:25:26 +0200
Message-ID: <1282746326.3667.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-25 at 11:12 +0200, Tejun Heo wrote:

> Yeap, without the fix patch applied, that should confirm that we're
> seeing the same failure, and with the patch applied, you can add a
> printk in the else part of !delayed check in cwq_dec_nr_in_flight().
> If the printk triggers and later rmmod dosen't trigger BUG_ON(), we
> can be fairly sure the problem is fixed.

Unfortunately, I haven't been able to trigger either code path today.
I'll happily believe that this was the problem though, and will just let
you know if I run into it again, I'm keeping the debug patch for now.
It's certainly a valid fix regardless of whether I can reproduce the
problem or not.

johannes

