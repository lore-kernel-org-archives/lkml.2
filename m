Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab0IMDDa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 23:03:30 -0400
Received: from ozlabs.org ([203.10.76.45]:52357 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab0IMDD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 23:03:29 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: #2 (Re: More modaliases + patchtool)
Date: Mon, 13 Sep 2010 12:33:22 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: mahatma@eu.by, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <4C6BE292.3060307@bspu.unibel.by> <201009111144.34078.rusty@rustcorp.com.au> <4C8AF933.9060304@goop.org>
In-Reply-To: <4C8AF933.9060304@goop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009131233.23278.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Sep 2010 01:06:19 pm Jeremy Fitzhardinge wrote:
>  On 09/11/2010 12:14 PM, Rusty Russell wrote:
> > On Thu, 19 Aug 2010 10:12:36 pm Dzianis Kahanovich wrote:
> >> diff -pruN a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> >> --- a/drivers/block/xen-blkfront.c	2010-08-19 15:20:56.344764984 +0300
> >> +++ b/drivers/block/xen-blkfront.c	2010-08-19 15:23:41.104764997 +0300
> >> @@ -1306,6 +1306,9 @@ static int __init xlblk_init(void)
> >>  
> >>  	return xenbus_register_frontend(&blkfront);
> >>  }
> >> +
> >> +MODULE_DEVICE_TABLE(xenbus, blkfront_ids);
> >> +
> >>  module_init(xlblk_init);
> > This seems very logical.  Jeremy?
> 
> Looks OK.  What will the effect be?  Will it allow better module
> auto-loading or something?

Normally yes.  Here's how it's supposed to work:
1) The bus provides a "modalias" field for devices, to say what driver module
   to probe for.  You already do this.
2) The driver marks the device table so scripts/mod/file2alias.c can find it.
   This is what this patch does.
3) scripts/mod/file2alias.c creates the wildcard aliases for the module, based
   on the device table.  You'd need to do this.

Instead you have manual MODULE_ALIAS lines for your drivers.  Your bus
matching is so simple and you have so few device types, that this works.
But the Right Way is to use the infrastructure to generate them as above.

Hope that clarifies!
Rusty.
