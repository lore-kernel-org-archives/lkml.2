Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab2IMJUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 05:20:43 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30672 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab2IMJUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 05:20:36 -0400
Date: Thu, 13 Sep 2012 12:19:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>,
        Hansjoerg Lipp <hjlipp@web.de>, kernel-janitors@vger.kernel.org,
        Tilman Schmidt <tilman@imap.cc>, Karsten Keil <isdn@linux-pingi.de>,
        gigaset307x-common@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] drivers/isdn/gigaset/common.c: Remove useless kfree
Message-ID: <20120913091959.GK19396@mwanda>
References: <1347462407-13499-9-git-send-email-peter.senna@gmail.com>
 <AE90C24D6B3A694183C094C60CF0A2F6026B6FEE@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B6FEE@saturn3.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 09:31:45AM +0100, David Laight wrote:
> > Remove useless kfree() and clean up code related to the removal.
> ...
> > diff --git a/drivers/isdn/gigaset/common.c b/drivers/isdn/gigaset/common.c
> > index aa41485..30a6b17 100644
> > --- a/drivers/isdn/gigaset/common.c
> > +++ b/drivers/isdn/gigaset/common.c
> > @@ -1123,7 +1123,6 @@ struct gigaset_driver *gigaset_initdriver(unsigned minor, unsigned minors,
> >  	return drv;
> > 
> >  error:
> > -	kfree(drv->cs);
> >  	kfree(drv);
> >  	return NULL;
> >  }
> > 
> 
> Seems to me that (assuming kfree(NULL) is ok) the kfree()
> is best left in - just in case some other error path is
> added after drv->cs is assigned.
> Better safe than a memory leak.

No.  Delete vestigial code.  There are all kinds of no-ops we could
add to the unwind bits of code if we wanted to so why is "drv->cs"
better than anything else.

First of all, no one is going to change the ISDN code to add an
allocation, but if they did then they have to make sure they don't
leak memory.  That's how it always works.  They can't just assume
that there is going to be a forgotten kfree() hanging off to the
side which is going to take care of it.

regards,
dan carpenter
