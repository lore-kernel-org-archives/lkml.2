Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab2LJJcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 04:32:32 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65404 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab2LJJca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 04:32:30 -0500
MIME-Version: 1.0
In-Reply-To: <20121207123343.GU14363@n2100.arm.linux.org.uk>
References: <1354354961-28833-1-git-send-email-giridhar.maruthy@linaro.org>
	<CAHuqX+EQ0pZnm27yAVqC=NRX8huQ5EvbC8PGn2G3xYw4D71gQA@mail.gmail.com>
	<50C1DB05.7090500@linaro.org>
	<20121207123343.GU14363@n2100.arm.linux.org.uk>
Date: Mon, 10 Dec 2012 15:02:28 +0530
Message-ID: <CAHuqX+G7e4bR_xK2BAEdm4dedaBHE=CG3sHmzHamgCiOtivNwQ@mail.gmail.com>
Subject: Re: [PATCH] I2C: EXYNOS: Add slave support to i2c
From: Giridhar Maruthy <giridhar.maruthy@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tushar Behera <tushar.behera@linaro.org>,
        linux-samsung-soc@vger.kernel.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        linux-i2c@vger.kernel.org, ben-linux@fluff.org, khali@linux-fr.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russel,

Thanks for review and please find my replies below.

On 7 December 2012 18:03, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Dec 07, 2012 at 05:33:17PM +0530, Tushar Behera wrote:
>> On 12/03/2012 05:46 PM, Giridhar Maruthy wrote:
>> > This patch adds slave support to i2c. The dt entry i2c-mode
>> > decides at probe time if the controller needs to work in
>> > slave mode and the controller is accordingly programmed.
>
> (I don't have the original patches.)
>
> Hmm.  How has slave-mode support been tested?

I have taken two I2C controllers in exynos5250.
I configured one as slave and the other as master port.
Then physically connected the pins of the two ports.
>
> Remembering that I2C slave devices do not initiate bus accesses, all
> accesses will be started by some other master.  How are you dealing
> with the bytes received from the master,

I run the slave read application in background.
The resulting slave read will sleep till all bytes are received
(wait_event_interruptible)

once the master sends the data, an ack is given out by the slave controller
in the ISR and the data is cached in the buffer(
buffer sent by slave receive application).
After all data is received, the read wakes up and the
slave receive program gets the data.

> and how are you returning a response to the master in reply to a read request?

Similarl logic works in slave transmit mode (read request). Slave
sleeps till the master initiates the transfer.
>
> We had support for this on PXA I2C through a callback from the driver
> into PXA code (used for the Psion Teklogix Netbook device) and it worked
> really well, but what you can't do is use the standard I2C interfaces
> for slave mode.

I have a question here. Since the same framework can work for both
master and slave, is there any technical limitations I have overseen
which prevents the slave mode to work?
