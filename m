Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285Ab2GYErS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 00:47:18 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:32993 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2GYErR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 00:47:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120724125513.GG12438@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998FDA9E@DQHE02.ent.ti.com>
 <1342799346.5138.7.camel@lorien2> <CAK5ve-JPtHkCMPV_UYUUZxrt_gzS3tsRXm5x8nFbB6hp+-gBxg@mail.gmail.com>
 <20120722181956.GA4557@opensource.wolfsonmicro.com> <CAK5ve-KAufV5h93AcWdVUVZx2E+pfgQ1L0jp5H28wHgBfV2zPA@mail.gmail.com>
 <20120724125513.GG12438@opensource.wolfsonmicro.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 25 Jul 2012 12:46:56 +0800
X-Google-Sender-Auth: kC7URWdl5zdAIE0RRi5Ec30BT_M
Message-ID: <CAK5ve-Lyk_EjOjSKHF-j0J1_8oey8wWKkVXAdqbKpRX2eZY+hg@mail.gmail.com>
Subject: Re: [PATCH v2] leds: add new lp8788 led driver
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: shuahkhan@gmail.com, "Kim, Milo" <Milo.Kim@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 8:55 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Jul 24, 2012 at 08:23:00AM +0800, Bryan Wu wrote:
>> On Mon, Jul 23, 2012 at 2:19 AM, Mark Brown
>
>> > If the work is flushed then the state that userspace thought was set
>> > when the driver is removed will actually be set before the driver is
>> > removed.  This is fairly minor but might be useful.
>
>> So what's kind of state you mentioned here that is cared by user
>> space. I find these 2 functions are quite confused for use right now.
>
> Any state - none of the drivers with sleeping I/O can do anything
> directly in their callbacks so they defer everything to work (we really
> should have that in the core but it was too annoying to implement last
> time I looked).
>
>> Literally, canceling normally will remove pending work item and wait
>> for running work item to finish. flushing will wait for both pending
>> and running work item to finish.
>
> Right, so if we flush it means we know that any scheduled work actually
> ran and implemented whatever change was requested.

Thanks Mark for clarifying this.

I'm going to Ack this driver and Mark will you merge this as whole patchset?

Acked-by: Bryan Wu <bryan.wu@canonical.com>

Thanks,
-Bryan
