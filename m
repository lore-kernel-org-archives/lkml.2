Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab0D3RlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:41:10 -0400
Received: from poutre.nerim.net ([62.4.16.124]:63600 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758853Ab0D3Rdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:33:41 -0400
Date: Fri, 30 Apr 2010 11:48:22 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Wolfram Sang <w.sang@pengutronix.de>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: i2c-i801 retries on lost arbitration (resent: no gpg)
Message-ID: <20100430114822.1a5e0cf9@hyperion.delvare>
In-Reply-To: <20100430094412.GC3553@swordfish.minsk.epam.com>
References: <20100430094412.GC3553@swordfish.minsk.epam.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergey,

On Fri, 30 Apr 2010 12:44:12 +0300, Sergey Senozhatsky wrote:
> Soory, forgot to turn-off gpg.

gpg is fine.

> Both i2c spec and ICH7 datasheet requires to restart transaction in
> case of lost arbitration.
> 
> "No information is lost during the arbitration process. A master that
> loses the arbitration can generate clock pulses until the end of the
> byte in which it loses the arbitration and must restart its transaction
> when the bus is idle."
>         
> Please see the following patch. Is it correct?

No, it's not. As you wrote above, this is not specific to the Intel ICH
but a general I2C issue. As such it must be handled in i2c-core and not
by individual drivers. And as a matter of fact, it is already handled.
Look at functions i2c_transfer and i2c_smbus_xfer in i2c-core.c, see
the comments "Retry automatically on arbitration loss", the code is
already there. It's just a matter of bus drivers properly setting
adapter->retries (which i2c-i801.c does already.)

So I don't know which kernel you're using, but with the latest upstream
kernel, things should work just fine already.

-- 
Jean Delvare
