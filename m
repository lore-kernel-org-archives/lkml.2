Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab2K2WJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 17:09:08 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56640 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab2K2WJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:09:05 -0500
Date: Thu, 29 Nov 2012 16:08:11 -0600
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v3] char/tpm: Use true and false for bools
Message-ID: <20121129220811.GA32514@ennui.austin.ibm.com>
References: <20121129160627.GB15399@ennui.austin.ibm.com>
 <1354223321-3343-1-git-send-email-peterhuewe@gmx.de>
 <1354226092.1700.8.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354226092.1700.8.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112922-9360-0000-0000-00000D532EE1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 01:54:52PM -0800, Joe Perches wrote:
> On Thu, 2012-11-29 at 22:08 +0100, Peter Huewe wrote:
> > Bool initializations should use true and false.  Bool tests don't need
> > comparisons
> []
> > .v3 for this tiny patch... shame on me.
> 
> Don't be silly...
> 
> > diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> []
> > @@ -545,7 +545,7 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
> >  			rc = -ENODEV;
> >  			goto out_err;
> >  		}
> > -		itpm = (probe == 0) ? 0 : 1;
> > +		itpm = !!probe;
> 
> Even more trivia:
> 
> This !! isn't necessary as ints assigned to bool are converted
> by the compiler to 0 or 1.

  Good to know, thanks Joe!

Kent

> 
> 

