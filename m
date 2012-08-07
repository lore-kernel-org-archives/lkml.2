Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab2HGL23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:28:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3835 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab2HGL20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:28:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6795"; a="221814470"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Jeff Moyer'" <jmoyer@redhat.com>
Cc: <axboe@kernel.dk>, <linux-mmc@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        "'open list:DOCUMENTATION'" <linux-doc@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1344166241-18708-1-git-send-email-tlinder@codeaurora.org>	<1344166241-18708-3-git-send-email-tlinder@codeaurora.org> <x49wr1cdlmg.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49wr1cdlmg.fsf@segfault.boston.devel.redhat.com>
Subject: RE: [RFC/PATCH 2/2] block: Adding ROW scheduling algorithm
Date: Tue, 7 Aug 2012 14:28:22 +0300
Message-ID: <004001cd748f$c2a12b20$47e38160$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQDJuLehQ41MV6PNI9g9xYZZQALMCAF/d/PIAjSnSN2ZOAhNsA==
Content-language: he
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff

First of all - thank you for your input! I think I did address at least some
of the issues you mentioned. But allow me to elaborate

> Perhaps you could start off by describing the workload, and describing why
> the existing I/O schedulers do not perform well.

 In mobile devices we won't have AS much parallel threads as on desktops.
Usually it's a single thread or at most 2 simultaneous working threads for
read & write.
The existing I/O schedulers add unnecessary complexity (CFQ) or don't give
read requests as much priority over write as we would like them to get.

>  Then, you could go on to
> say why you feel that the existing I/O schedulers could not be modified to
> perform better under your workload, 

We ran tests with existing I/O schedulers and tried tuning them to serve our
purposes better but it didn't give us the results we were able to achieve
with ROW.

>and wrap the whole thing up with
> some convincing performance numbers (including your testing procedures
> so others could verify your work independently).

Aren't the test results I published convincing? It shows that ROW has the
best READ throughput and the lowest READ latency. Actually, when playing
with ROW tunable the READ throughput  can go up to 34 mb/sec and READ
latency down to 70 msec (with WRITE throughput at ~15 mb/sec). The downside
is that in such configuration the write latency is ~13 sec which is a bit
too much.

I was testing on our Android based device. I don't know what numbers will
ROW produce if you run it on a PC because as I mentioned, ROW was developed
to run on mobile devices.
As I mentioned, the test I performed was parallel READ and WRITE using lmdd.
I'm not sure I understand what info is missing in order for others to
reproduce it...

Thanks,
Tanya Brokhman
---
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

