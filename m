Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab1B1RcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 12:32:13 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:33569 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab1B1RcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 12:32:12 -0500
X-ASG-Debug-ID: 1298914330-03d6a50f0be4e90001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D6BDC18.7020205@fusionio.com>
Date: Mon, 28 Feb 2011 12:32:08 -0500
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "dk@in-telegence.net" <dk@in-telegence.net>,
        "tj@kernel.org" <tj@kernel.org>
Subject: Re: [PATCH] blk-thrttole: Do not use kblockd workqueue for throtl
 work
References: <1298908305-12032-1-git-send-email-vgoyal@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH] blk-thrttole: Do not use kblockd workqueue for throtl
 work
In-Reply-To: <1298908305-12032-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1298914330
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.56662
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-28 10:51, Vivek Goyal wrote:
> o Dominik Klein reported a system hang issue while doing some blkio throttling
>   testing.
> 
>   https://lkml.org/lkml/2011/2/24/173
> 
> o Some tracing revealed that CFQ was not dispatching any more jobs as queue
>   unplug was not happening. And queue unplug was not happening because unplug
>   work was not being called as there was one throttling work on same cpu
>   which as not finished yet. And throttling work had not finished as it
>   was tyring to dispatch a bio to CFQ but all the request descriptors were
>   consume to it was put to sleep.
> 
> o So basically it is a cyclic dependecny between CFQ unplug work and throtl
>   dispatch work. Tejun suggested that use separate workqueue for such cases..
> 
> o This patch uses a separate workqueue for throttle related work and does not
>   rely on kblockd workqueue anymore.

Not good, that's definitely a bug. I'll queue this up for 2.6.38.

-- 
Jens Axboe

