Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab0FTIKd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 04:10:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34399 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078Ab0FTIK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 04:10:27 -0400
Date: Sun, 20 Jun 2010 10:10:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH] cfq-iosched: Fixed boot warning with BLK_CGROUP=y and
 CFQ_GROUP_IOSCHED=n
Message-ID: <20100620081016.GA5365@elte.hu>
References: <20100618143947.GA8431@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100618143947.GA8431@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4791]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vivek Goyal <vgoyal@redhat.com> wrote:

> Hi Jens,
> 
> Few days back Ingo noticed a CFQ boot time warning. This patch fixes it.

Hm, have you tested it? This bit:

> +++ linux-2.6/block/cfq.h	2010-06-18 09:41:23.256220395 -0400

> +static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg, uint64_t start_time, uint64_t io_start_time, bool direction, bool sync)
> +{
> +	cfq_blkiocg_update_completion_stats(blkg, start_time, io_start_time,
> +				direction, sync);
> +}

is an inline function calling itself.

	Ingo
