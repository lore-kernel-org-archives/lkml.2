Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab1KPRiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 12:38:17 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:34026 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757241Ab1KPRiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 12:38:15 -0500
Date: Wed, 16 Nov 2011 18:38:06 +0100
From: Jean Delvare <khali@linux-fr.org>
To: York Sun <yorksun@freescale.com>
Cc: <guenter.roeck@ericsson.com>, Tabi Timur-B04825 <B04825@freescale.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <B29983@freescale.com>
Subject: Re: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
Message-ID: <20111116183806.6130f0fb@endymion.delvare>
In-Reply-To: <1321464509.7847.41.camel@oslab-l1>
References: <1321338462-6138-1-git-send-email-guenter.roeck@ericsson.com>
	<CAOZdJXUPO5PyMkAw-2EPvy_qSUuqsgUA7Gr8mKUX7HyShoXk3g@mail.gmail.com>
	<E6AF40B3BFC8A9428EACB47497F0F4B62DC687@039-SN1MPN1-002.039d.mgd.msft.net>
	<ECEE0D23-8F53-402C-A97F-4DB0F0E9C79B@freescale.com>
	<1321464509.7847.41.camel@oslab-l1>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011 09:28:29 -0800, York Sun wrote:
> I am not sure if this mail will reach the list as I am not subscribed.
> 
> In the v2 patch (actually both version), you wrote
> 
> > +		byte = readb(i2c->base + MPC_I2C_DR);
> > +
> > +		/* Adjust length if first received byte is length */
> > +		if (i == 0 && recv_len) {
> > +			if (byte == 0 || byte > I2C_SMBUS_BLOCK_MAX)
> > +				return -EPROTO;
> > +			length += byte;
> > +			/*
> > +			 * For block reads, generate txack here if data length
> > +			 * is 1 byte (total length is 2 bytes).
> > +			 */
> > +			if (length == 2)
> > +				writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA
> > +					 | CCR_TXAK);
> > +		}
> > +		data[i] = byte;
> 
> I am wondering if the first byte should be left out for data[] if the
> recv_len is non-zero. If I understand correctly, this patch is to
> support of SMBus with multiple byte read. The SMBus is different from
> I2C bus on multiple byte. The first data is byte count vs slave data for
> I2C. So you will receive all data preceded by the byte count, which is
> one more than your loop.

That's why he wrote

	length += byte;

and not

	length = byte;

length is initialized to 1 for SMBus block reads.

-- 
Jean Delvare
