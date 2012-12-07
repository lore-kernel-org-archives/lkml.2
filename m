Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964978Ab2LGMd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 07:33:58 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56099 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964818Ab2LGMd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 07:33:57 -0500
Date: Fri, 7 Dec 2012 12:33:43 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: Giridhar Maruthy <giridhar.maruthy@linaro.org>,
        linux-samsung-soc@vger.kernel.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        linux-i2c@vger.kernel.org, ben-linux@fluff.org, khali@linux-fr.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] I2C: EXYNOS: Add slave support to i2c
Message-ID: <20121207123343.GU14363@n2100.arm.linux.org.uk>
References: <1354354961-28833-1-git-send-email-giridhar.maruthy@linaro.org> <CAHuqX+EQ0pZnm27yAVqC=NRX8huQ5EvbC8PGn2G3xYw4D71gQA@mail.gmail.com> <50C1DB05.7090500@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C1DB05.7090500@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 05:33:17PM +0530, Tushar Behera wrote:
> On 12/03/2012 05:46 PM, Giridhar Maruthy wrote:
> > This patch adds slave support to i2c. The dt entry i2c-mode
> > decides at probe time if the controller needs to work in
> > slave mode and the controller is accordingly programmed.

(I don't have the original patches.)

Hmm.  How has slave-mode support been tested?

Remembering that I2C slave devices do not initiate bus accesses, all
accesses will be started by some other master.  How are you dealing
with the bytes received from the master, and how are you returning a
response to the master in reply to a read request?

We had support for this on PXA I2C through a callback from the driver
into PXA code (used for the Psion Teklogix Netbook device) and it worked
really well, but what you can't do is use the standard I2C interfaces
for slave mode.
