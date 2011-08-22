Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab1HVLlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 07:41:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab1HVLk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 07:40:57 -0400
Date: Mon, 22 Aug 2011 13:14:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
        roland@hack.frob.com, torvalds@linux-foundation.org
Subject: Re: +
	prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
	.patch added to -mm tree
Message-ID: <20110822111402.GA13248@redhat.com>
References: <1313691091.1107.9.camel@mop> <20110818184857.GA12094@redhat.com> <1313717521.991.4.camel@mop> <20110819122503.GA8411@redhat.com> <CAPXgP11KC2fTWBVYo6CBXe924YAyTGhx9=UTBDf4cP5Acuo0NA@mail.gmail.com> <20110819131339.GB8411@redhat.com> <1313763653.1119.12.camel@mop> <20110819145815.GA15420@redhat.com> <20110820153331.GA22577@redhat.com> <1313951606.16175.7.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313951606.16175.7.camel@mop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, Kay Sievers wrote:
>
> version 5:
> - add back check for &init_task

Reviewed-by: Oleg Nesterov <oleg@redhat.com>





Just one note, to avoid the "doesn't look correct" questions.

> @@ -987,6 +987,9 @@ static int copy_signal(unsigned long clo
>  	sig->oom_score_adj = current->signal->oom_score_adj;
>  	sig->oom_score_adj_min = current->signal->oom_score_adj_min;
>
> +	sig->has_child_subreaper = current->signal->has_child_subreaper ||
> +				   current->signal->is_child_subreaper;

This assumes that current == parent. But this is not true with
CLONE_PARENT. If a task does prctl(REAPER) + clone(CLONE_PARENT)
->has_child_subreaper == T is not exactly right.

But I think this is fine and we do not care, a "wrong"
->has_child_subreaper is harmless and it can't be 100% correct in
any case.

I believe the patch is correct.

Oleg.

