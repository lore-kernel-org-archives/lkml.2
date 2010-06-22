Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab0FVSKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 14:10:10 -0400
Received: from poutre.nerim.net ([62.4.16.124]:65525 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab0FVSKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 14:10:08 -0400
Date: Tue, 22 Jun 2010 20:10:03 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Ben Dooks <ben-linux@fluff.org>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c/mips: Fix error return codes from Sibyte i2c bus
 driver
Message-ID: <20100622201003.23318b09@hyperion.delvare>
In-Reply-To: <1277215748-31510-1-git-send-email-guenter.roeck@ericsson.com>
References: <1277215748-31510-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Tue, 22 Jun 2010 07:09:08 -0700, Guenter Roeck wrote:
> Sibyte i2c bus driver returns non-descriptive error values.
> Update to return error values as defined in Documentation/i2c/fault-codes.
> 
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
> v2: Return -ENXIO for missing ACK and -EIO for other errors
> ---
>  drivers/i2c/busses/i2c-sibyte.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-sibyte.c b/drivers/i2c/busses/i2c-sibyte.c
> index 3d76a18..0fe505d 100644
> --- a/drivers/i2c/busses/i2c-sibyte.c
> +++ b/drivers/i2c/busses/i2c-sibyte.c
> @@ -94,7 +94,7 @@ static int smbus_xfer(struct i2c_adapter *i2c_adap, u16 addr,
>  		}
>  		break;
>  	default:
> -		return -1;      /* XXXKW better error code? */
> +		return -EOPNOTSUPP;
>  	}
>  
>  	while (csr_in32(SMB_CSR(adap, R_SMB_STATUS)) & M_SMB_BUSY)
> @@ -104,7 +104,7 @@ static int smbus_xfer(struct i2c_adapter *i2c_adap, u16 addr,
>  	if (error & M_SMB_ERROR) {
>  		/* Clear error bit by writing a 1 */
>  		csr_out32(M_SMB_ERROR, SMB_CSR(adap, R_SMB_STATUS));
> -		return -1;      /* XXXKW better error code? */
> +		return (error & M_SMB_ERROR_TYPE) ? -EIO : -ENXIO;
>  	}
>  
>  	if (data_bytes == 1)

Very nice, patch applied, thanks.

-- 
Jean Delvare
