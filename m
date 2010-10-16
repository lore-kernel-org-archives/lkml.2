Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab0JPB7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 21:59:10 -0400
Received: from imr4.ericy.com ([198.24.6.8]:57150 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230Ab0JPB7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 21:59:08 -0400
Date: Fri, 15 Oct 2010 18:58:29 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Ben Dooks <ben-linux@fluff.org>, Rodolfo Giometti <giometti@linux.it>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] i2c/mux: Driver for PCA9541 I2C Master Selector
Message-ID: <20101016015829.GA30128@ericsson.com>
References: <1286932516-20689-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1286932516-20689-1-git-send-email-guenter.roeck@ericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 09:15:16PM -0400, Guenter Roeck wrote:
> This patch adds support for PCA9541, an I2C Bus Master Selector.
> The driver is modeled as single channel I2C Multiplexer to be able to utilize
> the I2C multiplexer framework.
> 
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> Reviewed-by: Tom Grennan <tom.grennan@ericsson.com>
> ---
> v2 changes:
> - Added more detailed description and reasoning why the driver was implemented
>   as single-channel multiplexer.
> - Modified arbitration algorithm, since access to i2c masters from interrupt
>   level is not a good idea. Instead of using hrtimers and handling arbitration
>   in interrupt, handle it from select_chan and either delay for short retry
>   periods or sleep for long (millisecond) periods.
> 
>  drivers/i2c/muxes/Kconfig   |   10 +
>  drivers/i2c/muxes/Makefile  |    1 +
>  drivers/i2c/muxes/pca9541.c |  397 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 408 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/i2c/muxes/pca9541.c
> 
Any comments / thoughts / feedback ?

Thanks,
Guenter
