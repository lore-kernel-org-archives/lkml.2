Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab2LBIF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 03:05:57 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23359 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab2LBIF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 03:05:56 -0500
Date: Sun, 2 Dec 2012 11:05:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Milo <Milo.Kim@ti.com>,
        Richard Purdie <rpurdie@rpsys.net>, Bryan Wu <bryan.wu@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 05/56] drivers/leds/leds-lp5521.c: fix lp5521_read() error
 handling
Message-ID: <20121202080508.GA6517@mwanda>
References: <20121130185118.302752929@linuxfoundation.org>
 <20121130185118.896569929@linuxfoundation.org>
 <1354418247.7995.49.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354418247.7995.49.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 02, 2012 at 03:17:27AM +0000, Ben Hutchings wrote:
> On Fri, 2012-11-30 at 10:54 -0800, Greg Kroah-Hartman wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > commit 5bc9ad774c063f6b41965e7314f2c26aa5e465a0 upstream.
> > 
> > Gcc 4.6.2 complains that:
> > 
> >   drivers/leds/leds-lp5521.c: In function `lp5521_load_program':
> >   drivers/leds/leds-lp5521.c:214:21: warning: `mode' may be used uninitialized in this function [-Wuninitialized]
> >   drivers/leds/leds-lp5521.c: In function `lp5521_probe':
> >   drivers/leds/leds-lp5521.c:788:5: warning: `buf' may be used uninitialized in this function [-Wuninitialized]
> >   drivers/leds/leds-lp5521.c:740:6: warning: `ret' may be used uninitialized in this function [-Wuninitialized]
> > 
> > These are real problems if lp5521_read() returns an error.  When that
> > happens we should handle it, instead of ignoring it or doing a bitwise
> > OR with all the other error codes and continuing.
> [...]
> > --- a/drivers/leds/leds-lp5521.c
> > +++ b/drivers/leds/leds-lp5521.c
> [...]
> > @@ -785,7 +789,7 @@ static int __devinit lp5521_probe(struct
> >  	 * LP5521_REG_ENABLE register will not have any effect - strange!
> >  	 */
> >  	ret = lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
> > -	if (buf != LP5521_REG_R_CURR_DEFAULT) {
> > +	if (ret || buf != LP5521_REG_R_CURR_DEFAULT) {
> >  		dev_err(&client->dev, "error in resetting chip\n");
> >  		goto fail2;
> >  	}
> 
> lp5521_probe() is going to return 0 if ret == 0 &&
> buf != LP5521_REG_R_CURR_DEFAULT here.  It needs to set an error code.

Thanks Ben,

I'll send a fix for this.

regards,
dan carpenter

