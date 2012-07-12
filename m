Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934177Ab2GLRIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:08:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47226 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932725Ab2GLRH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:07:58 -0400
Date: Thu, 12 Jul 2012 10:07:52 -0700
From: Tejun Heo <tj@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        joshhunt00@gmail.com, axboe@kernel.dk, rni@google.com,
        vgoyal@redhat.com, vwadekar@nvidia.com, herbert@gondor.hengli.com.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org, swhiteho@redhat.com,
        bpm@sgi.com, elder@kernel.org, xfs@oss.sgi.com, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH 2/6] workqueue: factor out worker_pool from global_cwq
Message-ID: <20120712170752.GC20167@google.com>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
 <1341859315-17759-3-git-send-email-tj@kernel.org>
 <87ehok8bmb.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ehok8bmb.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Namhyung.

Sorry about the delay.

On Tue, Jul 10, 2012 at 01:48:44PM +0900, Namhyung Kim wrote:
> > +	struct list_head	idle_list;	/* X: list of idle workers */
> > +	struct timer_list	idle_timer;	/* L: worker idle timeout */
> > +	struct timer_list	mayday_timer;	/* L: SOS timer for dworkers */
> 
> What is 'dworkers'?

My stupid finger pressing 'd' when I never meant to. :)

> > -	/* workers are chained either in the idle_list or busy_hash */
> > -	struct list_head	idle_list;	/* X: list of idle workers */
> > +	/* workers are chained either in busy_head or pool idle_list */
> 
> s/busy_head/busy_hash/ ?

Will fix.

Thanks.

-- 
tejun
