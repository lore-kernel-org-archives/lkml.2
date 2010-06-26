Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab0FZQ3W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 12:29:22 -0400
Received: from bamako.nerim.net ([62.4.17.28]:63813 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab0FZQ3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 12:29:21 -0400
Date: Sat, 26 Jun 2010 18:29:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
       "ben-linux@fluff.org" <ben-linux@fluff.org>,
       "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
       "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c/mips: Fix error return codes from Sibyte i2c bus 
 driver
Message-ID: <20100626182915.46ab3ecd@hyperion.delvare>
In-Reply-To: <alpine.LFD.2.00.1006261709110.14683@eddie.linux-mips.org>
References: <1277056673-4305-1-git-send-email-guenter.roeck@ericsson.com>
	<20100621190252.2adc6bd8@hyperion.delvare>
	<20100622115417.GA14418@ericsson.com>
	<alpine.LFD.2.00.1006261709110.14683@eddie.linux-mips.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jun 2010 17:14:59 +0100 (BST), Maciej W. Rozycki wrote:
> On Tue, 22 Jun 2010, Guenter Roeck wrote:
> 
> > > > @@ -104,7 +104,7 @@ static int smbus_xfer(struct i2c_adapter *i2c_adap, u16 addr,
> > > >  	if (error & M_SMB_ERROR) {
> > > >  		/* Clear error bit by writing a 1 */
> > > >  		csr_out32(M_SMB_ERROR, SMB_CSR(adap, R_SMB_STATUS));
> > > > -		return -1;      /* XXXKW better error code? */
> > > > +		return -ENXIO;
> > > >  	}
> > > >  
> > > >  	if (data_bytes == 1)
> > > 
> > > Definitely an improvement. However, returning -ENXIO on all errors
> > > seems wrong. This error value should only be returned on missing ack
> > > from the slave on address byte. Isn't it possible to distinguish
> > > between different error kinds? M_SMB_ERROR_TYPE seems promising, but
> > > one would need to look up the datasheet (which I don't have) to
> > > discover its meaning.
> > > 
> > Makes sense. I'll dig up a copy of the datasheet and see if I can improve it.
> 
>  The M_SMB_ERROR_TYPE bit is cleared if an expected ackonwledgement has 
> not been seen and set if the transfer has failed after 15 retries.  So 
> that's probably ENXIO for the former and EIO for the latter.

Exactly what Guenter did. Good.

-- 
Jean Delvare
