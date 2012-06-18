Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab2FRO0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 10:26:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47434 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2FRO0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 10:26:53 -0400
Message-ID: <4FDF3AAA.9020101@landley.net>
Date: Mon, 18 Jun 2012 09:26:50 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Why does ionice(1) ban the user to set back to 'none' class?
References: <20120618114841.GA4855@gmail.com>
In-Reply-To: <20120618114841.GA4855@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 06:48 AM, Zheng Liu wrote:
> Hi Jens,
> 
> I meet a problem when I use ionice(1) to adjust a process's io priority.
> I do the following operations:
> 
> $ ionice -p${pid}
> none: prio 0
> $ ionice -p${pid} -c2 -n4
> $ ionice -p${pid}
> best-effort: prio 4
> $ ionice -p${pid} -c0 -n0
> $ ionice -p${pid}
> best-effort: prio 0
> 
> So I cannot set scheduling class back to 'none'.  If I call ioprio_set(2)
> directly, it will be fine.  But if I use ionice(1), I cannot change it.  I
> read the docs about ionice in [1].  I notice this code:
> 
> switch (ioprio_class) {
> 	case IOPRIO_CLASS_NONE:
> 		ioprio_class = IOPRIO_CLASS_BE;
>                                ^^^^^^^^^^^^^^^^
>                                *It means that we cannot set back to none.*
> 		break;
> 	case IOPRIO_CLASS_RT:
> 	case IOPRIO_CLASS_BE:
> 		break;
> 	case IOPRIO_CLASS_IDLE:
> 		ioprio = 7;
> 		break;
> 	default:
> 		printf("bad prio class %d\n", ioprio_class);
> 		return 1;
> }
> 
> My question is why we need to ban the user to set back to 'none'.  Is there
> some reasons?  Thank you.

Since I'm CC'd, I'll explicitly say I haven't a clue why it does this.

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
