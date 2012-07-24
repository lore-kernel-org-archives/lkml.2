Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab2GXAXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 20:23:23 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57367 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab2GXAXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 20:23:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120722181956.GA4557@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998FDA9E@DQHE02.ent.ti.com>
 <1342799346.5138.7.camel@lorien2> <CAK5ve-JPtHkCMPV_UYUUZxrt_gzS3tsRXm5x8nFbB6hp+-gBxg@mail.gmail.com>
 <20120722181956.GA4557@opensource.wolfsonmicro.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Tue, 24 Jul 2012 08:23:00 +0800
X-Google-Sender-Auth: P-YrZA_RYbc3cDBYzUoWpAb2BYc
Message-ID: <CAK5ve-KAufV5h93AcWdVUVZx2E+pfgQ1L0jp5H28wHgBfV2zPA@mail.gmail.com>
Subject: Re: [PATCH v2] leds: add new lp8788 led driver
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: shuahkhan@gmail.com, "Kim, Milo" <Milo.Kim@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 2:19 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Sat, Jul 21, 2012 at 02:48:49AM +0800, Bryan Wu wrote:
>
>> Actually cancel_work_sync() is quite similar to flush_work_sync()
>> here. For the timer thing, in fact it is NULL when cancel_work_sync()
>> call __cancel_work_timer().
>
>> And Mark, do you have any advice about the flush_work_sync() and
>> cancel_work_sync(). I saw you use flush in the
>> drivers/leds/leds-wm8350.c.
>
> If the work is flushed then the state that userspace thought was set
> when the driver is removed will actually be set before the driver is
> removed.  This is fairly minor but might be useful.

So what's kind of state you mentioned here that is cared by user
space. I find these 2 functions are quite confused for use right now.
Literally, canceling normally will remove pending work item and wait
for running work item to finish. flushing will wait for both pending
and running work item to finish.

Thanks,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
