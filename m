Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015Ab0JUPDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:03:36 -0400
Received: from imr3.ericy.com ([198.24.6.13]:35123 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756922Ab0JUPDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:03:35 -0400
Date: Thu, 21 Oct 2010 08:03:00 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Ben Dooks <ben-linux@fluff.org>, Rodolfo Giometti <giometti@linux.it>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] i2c/mux: Driver for PCA9541 I2C Master Selector
Message-ID: <20101021150300.GB26460@ericsson.com>
References: <1287546908-32634-1-git-send-email-guenter.roeck@ericsson.com>
 <20101021164304.06770538@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101021164304.06770538@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 10:43:04AM -0400, Jean Delvare wrote:
> On Tue, 19 Oct 2010 20:55:08 -0700, Guenter Roeck wrote:
> > This patch adds support for PCA9541, an I2C Bus Master Selector.
> > The driver is modeled as single channel I2C Multiplexer to be able to utilize
> > the I2C multiplexer framework.
> > 
> > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> > Reviewed-by: Tom Grennan <tom.grennan@ericsson.com>
> > ---
> > v3 changes:
> > - Clarified and cleaned up comments.
> > - No longer pass "struct i2c_adapter *" as parameter.
> >   Get it from client->adapter if needed.
> > - No longer pass "struct pca9541 *" as parameter. 
> >   Pass "struct i2c_client *" instead and get "struct pca9541 *" from it
> >   if needed.
> > - Removed "struct i2c_client *client" from struct pca9541 since it is
> >   no longer needed.
> > - Moved "pca9541_release_bus(client);" ahead of i2c_add_mux_adapter()
> >   to avoid a possible race condition. Also protect the call with
> >   i2c_lock_adapter() / i2c_unlock_adapter().
> > - Removed __devinit from pca9541_probe() and __devexit from pca9541_remove().
> 
> Applied, thanks.
> 
> Would you mind adding yourself to MAINTAINERS as a maintainer for this
> driver? While the driver is small, it's not trivial and it's difficult
> to work on it without the right hardware setup.
> 
Sure. Not intentional - I wanted to do that, just forgot. And I agree,
it is pretty much impossible to maintain it unless you have HW to test it.

Want me to resubmit or send a separate patch ?

Thanks,
Guenter
