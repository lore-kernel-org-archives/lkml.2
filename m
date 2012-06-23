Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab2FWTLJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 15:11:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47921 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab2FWTLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 15:11:08 -0400
Date: Sat, 23 Jun 2012 22:10:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH V2 1/3] staging/rtl8192u: fix coding style problems
Message-ID: <20120623191051.GF5333@mwanda>
References: <1340132742-18849-1-git-send-email-devendra.aaru@gmail.com>
 <20120620230839.GA17883@kroah.com>
 <1340234315.29885.54.camel@joe2Laptop>
 <CAHdPZaMH1vJPsFmGFrrpWNtCxuY+S35-w2j+gbiiE=7jVKLtUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHdPZaMH1vJPsFmGFrrpWNtCxuY+S35-w2j+gbiiE=7jVKLtUQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2012 at 12:04:12AM +0530, devendra.aaru wrote:
> Hi Joe,
> 
> On Thu, Jun 21, 2012 at 4:48 AM, Joe Perches <joe@perches.com> wrote:
> > On Wed, 2012-06-20 at 16:08 -0700, Greg Kroah-Hartman wrote:
> >> On Wed, Jun 20, 2012 at 12:35:42AM +0530, Devendra Naga wrote:
> >> > fixed some of the coding style problems reported by checkpatch
> > []
> >> > @@ -66,11 +69,10 @@ short eprom_r(struct net_device *dev)
> >> >  {
> >> >     short bit;
> >> >
> >> > -   bit=(read_nic_byte_E(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT) );
> >> > +   bit = (read_nic_byte_E(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT));
> >> >     udelay(EPROM_DELAY);
> >> >
> >> > -   if(bit) return 1;
> >> > -   return 0;
> >> > +   return !!bit;
> >>
> >> Oh come on, really?  !! is more "clear" here?
> >
> > Depends on the reader.  !! is pretty common.
> >
> >> No, please be painfully obvious, that's the only way to write kernel
> >> code.  Not like this.
> >
> > I'd just make the return a bool instead.
> >
>  taking another variable and assign it like bool ret = !!bit, and
> returning ret?, i think this doesn't look better.

*eye roll*

	if (bit)
		return 1;
	return 0;

regards,
dan carpenter


