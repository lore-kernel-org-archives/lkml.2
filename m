Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab1DCSlZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 14:41:25 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:26610 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753025Ab1DCSlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 14:41:24 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 1XoeyrkVM1nOQ5.43GRWH7dVyruCXtt1dmptGW2IrawD4by
 O3Cpcx2a4.1aUtrBEfEguFyDG8MK1yVkuy18oXlYRu0sogdHlaimTZMeiuFT
 lRm1lj3zX7vePo.aoUA5bQzg3tAuXWHjUCKZp36_oW5SseGHKWXIGdsUm3yW
 HeAs8NhcfHcph9d6ocrG8uF8jtp5lcTBn6GBVc4hPnKkvwjtbQN2rAjXNq.m
 qDgNbBw92zTubkOUT29JVQf1zepu9MbXGq3LkZqgeWiOloK1BAxGaqqP.JTP
 2rgmIXgUkeOtmL227Oy8sAb2ziNZI3pdZioCyvKngr7Oi59_H
X-Yahoo-Newman-Property: ymail-3
Date: Sun, 3 Apr 2011 13:41:20 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dave Chinner <david@fromorbit.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, npiggin@kernel.dk, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 0/3] Unmapped page cache control (v5)
In-Reply-To: <20110402011040.GG6957@dastard>
Message-ID: <alpine.DEB.2.00.1104031339120.15317@router.home>
References: <20110331144145.0ECA.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1103311451530.28364@router.home> <20110401221921.A890.A69D9226@jp.fujitsu.com> <20110402011040.GG6957@dastard>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Apr 2011, Dave Chinner wrote:

> Fundamentally, if you just switch off memory reclaim to avoid the
> latencies involved with direct memory reclaim, then all you'll get
> instead is ENOMEM because there's no memory available and none will be
> reclaimed. That's even more fatal for the system than doing reclaim.

Not for my use cases here. No one will die if reclaim happens but its bad
for the bottom line. Reducing the chance of memory reclaim occurring in a
critical section is sufficient.
