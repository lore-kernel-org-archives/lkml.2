Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1BINOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 08:14:54 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:60776 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597Ab1BINOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 08:14:53 -0500
X-ASG-Debug-ID: 1297257291-01de280c5395b90001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D52938C.30907@fusionio.com>
Date: Wed, 9 Feb 2011 14:15:56 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Justin TerAvest <teravest@google.com>
CC: "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "ctalbott@google.com" <ctalbott@google.com>,
        "mrubin@google.com" <mrubin@google.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "guijianfeng@cn.fujitsu.com" <guijianfeng@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Don't wait if queue already has requests.
References: <1297192697-29978-1-git-send-email-teravest@google.com>
X-ASG-Orig-Subj: Re: [PATCH] Don't wait if queue already has requests.
In-Reply-To: <1297192697-29978-1-git-send-email-teravest@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1297257291
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.54833
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-08 20:18, Justin TerAvest wrote:
> Commit 7667aa0630407bc07dc38dcc79d29cc0a65553c1 added logic to wait for
> the last queue of the group to become busy (have at least one request),
> so that the group does not lose out for not being continuously
> backlogged. The commit did not check for the condition that the last
> queue already has some requests. As a result, if the queue already has
> requests, wait_busy is set. Later on, cfq_select_queue() checks the
> flag, and decides that since the queue has a request now and wait_busy
> is set, the queue is expired.  This results in early expiration of the
> queue.
> 
> This patch fixes the problem by adding a check to see if queue already
> has requests. If it does, wait_busy is not set. As a result, time slices
> do not expire early.
> 
> The queues with more than one request are usually buffered writers.
> Testing shows improvement in isolation between buffered writers.

Thanks for catching this in due time, I'll queue it up for 2.6.38 and
mark it for stable backport.

-- 
Jens Axboe

