Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab0JUOne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:43:34 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:5984 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab0JUOna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:43:30 -0400
Date: Thu, 21 Oct 2010 16:43:04 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Rodolfo Giometti <giometti@linux.it>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] i2c/mux: Driver for PCA9541 I2C Master Selector
Message-ID: <20101021164304.06770538@endymion.delvare>
In-Reply-To: <1287546908-32634-1-git-send-email-guenter.roeck@ericsson.com>
References: <1287546908-32634-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 20:55:08 -0700, Guenter Roeck wrote:
> This patch adds support for PCA9541, an I2C Bus Master Selector.
> The driver is modeled as single channel I2C Multiplexer to be able to utilize
> the I2C multiplexer framework.
> 
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> Reviewed-by: Tom Grennan <tom.grennan@ericsson.com>
> ---
> v3 changes:
> - Clarified and cleaned up comments.
> - No longer pass "struct i2c_adapter *" as parameter.
>   Get it from client->adapter if needed.
> - No longer pass "struct pca9541 *" as parameter. 
>   Pass "struct i2c_client *" instead and get "struct pca9541 *" from it
>   if needed.
> - Removed "struct i2c_client *client" from struct pca9541 since it is
>   no longer needed.
> - Moved "pca9541_release_bus(client);" ahead of i2c_add_mux_adapter()
>   to avoid a possible race condition. Also protect the call with
>   i2c_lock_adapter() / i2c_unlock_adapter().
> - Removed __devinit from pca9541_probe() and __devexit from pca9541_remove().

Applied, thanks.

Would you mind adding yourself to MAINTAINERS as a maintainer for this
driver? While the driver is small, it's not trivial and it's difficult
to work on it without the right hardware setup.

-- 
Jean Delvare
