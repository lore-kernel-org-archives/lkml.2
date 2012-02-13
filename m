Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab2BMJVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:21:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:25481 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322Ab2BMJVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:21:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="106119776"
Date: Mon, 13 Feb 2012 11:21:01 +0200
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] bluetooth: Convert BT_DBG to pr_debug
Message-ID: <20120213092059.GC21179@aemeltch-MOBL1>
Mail-Followup-To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	Joe Perches <joe@perches.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Gustavo F. Padovan" <padovan@profusion.mobi>,
	"David S. Miller" <davem@davemloft.net>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
References: <cover.1329102581.git.joe@perches.com>
 <90fbd8a0b800c83f5ad1df7889dc9b11d7d9c588.1329102581.git.joe@perches.com>
 <1329115057.28848.52.camel@aeonflux>
 <1329115904.30878.7.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329115904.30878.7.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Sun, Feb 12, 2012 at 10:51:44PM -0800, Joe Perches wrote:
> On Mon, 2012-02-13 at 07:37 +0100, Marcel Holtmann wrote:
> > > No need to obfuscate, just use the normal debugging macro.
> > > Add "\n" to uses, align arguments, coalesce formats.
> > > Fix a typo and fix a bad format extended by a line continuation.
> > what is this patch buying us.
> 
> Easier greps of pr_debug.

This depends what are you grepping for: for all usage of pr_debug or only
for bluetooth related debugs ;)

> BT_DBG is just an unnecessary useless wrapper.

I think at some point we need to remove the wrapper and switch to common 
debug function like dev_dbg but what is the point just renaming it?

Best regards 
Andrei Emeltchenko 

> 
> > The only useful change would be to move to dev_printk, but we are not
> > there yet.
> 
> Maybe dev_dbg, but there isn't always an
> appropriate device * available.
> 
> There are many uses of:
> 	pr_debug("%s ...", (some struct hci_dev *)->name, ...)
> 
> that could be something like
> 
> hci_dev_dbg((some struct hci_dev *), fmt, ...)
> 

