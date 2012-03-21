Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab2CUKFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 06:05:19 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:57868 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2CUKFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 06:05:17 -0400
Message-ID: <4F69A798.4000200@ce.jp.nec.com>
Date: Wed, 21 Mar 2012 19:04:08 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
CC: "Alasdair G. Kergon" <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] Fix I/O counts in vmstat
References: <Pine.LNX.4.64.1203202336370.15617@file.rdu.redhat.com>
In-Reply-To: <Pine.LNX.4.64.1203202336370.15617@file.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mikulas,

> The decision whether bio is counted or not is made by the code that
> submits the bio. This leads to some problems:

How about convering dm targets to use generic_make_request?

Since submit_bio counts vm events, it seems natural for
caller to decide which function to use.
Device driver does not know whether the requested I/O is
for vm-to-device or device-to-device.
We could still use iostat to measure throughput of individual
block devices. 

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
