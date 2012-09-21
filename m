Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab2IUEfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 00:35:34 -0400
Received: from ares07.inai.de ([5.9.24.206]:60556 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab2IUEfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 00:35:32 -0400
Date: Fri, 21 Sep 2012 06:35:30 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Tatyana Brokhman <tlinder@codeaurora.org>
cc: axboe@kernel.dk, Jeff Moyer <jmoyer@redhat.com>,
        linux-arm-msm@vger.kernel.org,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH 2/2] block: Adding ROW scheduling algorithm
In-Reply-To: <alpine.LNX.2.01.1209190718030.29967@nerf07.vanv.qr>
Message-ID: <alpine.LNX.2.01.1209210631060.13993@nerf07.vanv.qr>
References: <1344166241-18708-1-git-send-email-tlinder@codeaurora.org> <1344166241-18708-3-git-send-email-tlinder@codeaurora.org> <x49wr1cdlmg.fsf@segfault.boston.devel.redhat.com> <alpine.LNX.2.01.1209190718030.29967@nerf07.vanv.qr>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2012-09-19 07:29, Jan Engelhardt wrote:
>On Monday 2012-08-06 18:35, Jeff Moyer wrote:
>>Tatyana Brokhman writes:
>>
>>> This patch adds the implementation of a new scheduling algorithm - ROW.
>>> The policy of this algorithm is to prioritize READ requests over WRITE
>>> as much as possible without starving the WRITE requests.
>>
>>Perhaps you could start off by describing the workload, and describing
>>why the existing I/O schedulers do not perform well.

There seems to a bug with ROW. After about 43 hours of continued
operation, programs (./configure was what I ran at the time this
happened) first become slow, then got stuck in D state within a
minute. Ctrl-C/Z worked at first, soon not, then these messages
appeared in dmesg.

[319952.630605] row: forced dispatching is broken (nr_sorted=17), please report
this
[319952.631174] row: forced dispatching is broken (nr_sorted=17), please report
this
