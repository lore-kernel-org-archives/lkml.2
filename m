Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539Ab2FTXSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:18:39 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38928 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758511Ab2FTXSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:18:36 -0400
Message-ID: <1340234315.29885.54.camel@joe2Laptop>
Subject: Re: [PATCH V2 1/3] staging/rtl8192u: fix coding style problems
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Devendra Naga <devendra.aaru@gmail.com>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 20 Jun 2012 16:18:35 -0700
In-Reply-To: <20120620230839.GA17883@kroah.com>
References: <1340132742-18849-1-git-send-email-devendra.aaru@gmail.com>
	 <20120620230839.GA17883@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 16:08 -0700, Greg Kroah-Hartman wrote:
> On Wed, Jun 20, 2012 at 12:35:42AM +0530, Devendra Naga wrote:
> > fixed some of the coding style problems reported by checkpatch
[]
> > @@ -66,11 +69,10 @@ short eprom_r(struct net_device *dev)
> >  {
> >  	short bit;
> >  
> > -	bit=(read_nic_byte_E(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT) );
> > +	bit = (read_nic_byte_E(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT));
> >  	udelay(EPROM_DELAY);
> >  
> > -	if(bit) return 1;
> > -	return 0;
> > +	return !!bit;
> 
> Oh come on, really?  !! is more "clear" here?

Depends on the reader.  !! is pretty common.

> No, please be painfully obvious, that's the only way to write kernel
> code.  Not like this.

I'd just make the return a bool instead.

Also, there are unnecessary parens that could
be removed to make the code clearer.

(1<<EPROM_R_SHIFT), (1<<EPROM_W_SHIFT) and
(1<<EPROM_CK_SHIFT) could be new #defines too.


