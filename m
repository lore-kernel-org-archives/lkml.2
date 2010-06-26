Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab0FZQPL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 12:15:11 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:37442 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab0FZQPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 12:15:09 -0400
Date: Sat, 26 Jun 2010 17:14:59 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
cc: Jean Delvare <khali@linux-fr.org>,
       "ben-linux@fluff.org" <ben-linux@fluff.org>,
       "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
       "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c/mips: Fix error return codes from Sibyte i2c bus
 driver
In-Reply-To: <20100622115417.GA14418@ericsson.com>
Message-ID: <alpine.LFD.2.00.1006261709110.14683@eddie.linux-mips.org>
References: <1277056673-4305-1-git-send-email-guenter.roeck@ericsson.com> <20100621190252.2adc6bd8@hyperion.delvare> <20100622115417.GA14418@ericsson.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jun 2010, Guenter Roeck wrote:

> > > @@ -104,7 +104,7 @@ static int smbus_xfer(struct i2c_adapter *i2c_adap, u16 addr,
> > >  	if (error & M_SMB_ERROR) {
> > >  		/* Clear error bit by writing a 1 */
> > >  		csr_out32(M_SMB_ERROR, SMB_CSR(adap, R_SMB_STATUS));
> > > -		return -1;      /* XXXKW better error code? */
> > > +		return -ENXIO;
> > >  	}
> > >  
> > >  	if (data_bytes == 1)
> > 
> > Definitely an improvement. However, returning -ENXIO on all errors
> > seems wrong. This error value should only be returned on missing ack
> > from the slave on address byte. Isn't it possible to distinguish
> > between different error kinds? M_SMB_ERROR_TYPE seems promising, but
> > one would need to look up the datasheet (which I don't have) to
> > discover its meaning.
> > 
> Makes sense. I'll dig up a copy of the datasheet and see if I can improve it.

 The M_SMB_ERROR_TYPE bit is cleared if an expected ackonwledgement has 
not been seen and set if the transfer has failed after 15 retries.  So 
that's probably ENXIO for the former and EIO for the latter.

  Maciej
