Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab1F2PFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:05:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41285 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab1F2PE6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:04:58 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.172.9]
In-Reply-To: <20110627210007.GC20865@ponder.secretlab.ca>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <1308640714-17961-3-git-send-email-ohad@wizery.com> <20110627210007.GC20865@ponder.secretlab.ca>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 29 Jun 2011 18:04:37 +0300
Message-ID: <BANLkTi=4Pp1UYWFsBywRvLL1n=ggCZgAeA@mail.gmail.com>
Subject: Re: [RFC 2/8] remoteproc: add omap implementation
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 12:00 AM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> Very little for me to comment on here.  However, something I just
> noticed.  Why is it necessary to pass in THIS_MODULE to the
> rproc_register function?  Having a reference to the pdev gives you the
> pointer to the driver, which has the THIS_MODULE value in it.  That
> should be sufficient.

Nice one, thanks !

> /me also isn't sure if incrementing the refcount on the module is the
> best way to prevent the rproc from going away, but I haven't dug into
> the details in the driver code to find out.  Drivers can get unbound
> from devices without the driver being unloaded, so I imagine there is
> an in-use count on the device itself that would prevent driver
> unbinding.

Yes, increasing the module refcount is necessary to prevent the user
from removing the driver when the rproc is used.

If the underlying device goes away while rproc is used, then
rproc_unregister should return -EBUSY, which would fail the underlying
driver's ->remove() handler (gpiolib is doing something very similar).
I have forgotten to add this check, and will add it now.

Thanks !
