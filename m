Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0C2Pl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:41:26 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47906 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab0C2PlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:41:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=QcdAfDvpuZhmqd52bMMQIQi3bkD2R+LIsbqCt5iChrBYR+jeb4zS7hqdGSIuvem6dQ
         3MD+GPYigsE5UtEpWwuMj9eXbjk0ATcrqRbFZEOSVHMgcFxUpulK/blsRia5dqPj6okb
         Yo+4/Xg36QH1Irjw/umtvWguGsg9d+O0fuOE0=
Date: Mon, 29 Mar 2010 18:41:09 +0300
From: Dan Carpenter <error27@gmail.com>
To: giulio.benetti@micronovasrl.com
Cc: grant.likely@secretlab.ca, jeremy.kerr@canonical.com,
       afleming@freescale.com, jezz@sysmic.org,
       devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: [patch] of: check for IS_ERR()
Message-ID: <20100329154109.GF5069@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	giulio.benetti@micronovasrl.com, grant.likely@secretlab.ca,
	jeremy.kerr@canonical.com, afleming@freescale.com, jezz@sysmic.org,
	devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	David Miller <davem@davemloft.net>
References: <20100226094941.GE4912@bicker> <20100226.015420.66646406.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100226.015420.66646406.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 01:54:20AM -0800, David Miller wrote:
> From: Dan Carpenter <error27@gmail.com>
> Date: Fri, 26 Feb 2010 12:49:41 +0300
> 
> > get_phy_device() can return an ERR_PTR()
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > ---
> > I don't have a cross compile environment set up so I can't even compile 
> > test this.  :/  But err.h is included so it should be OK.
> 
> It should return ERR_PTR() consistently.  Checking for both
> NULL and ERR_PTR() is undesirable.

Hi Giulio,

get_phy_device() currently returns NULL because of: 3ee82383f0098a2 "phy: 
fix phy address bug".  If I change it to return ERR_PTR(-ENODEV) that
will mean we break out of the loop with an error in mdiobus_register()
where before we would just continue on.

drivers/net/phy/mdio_bus.c
   119                          phydev = mdiobus_scan(bus, i);
   120                          if (IS_ERR(phydev)) {
   121                                  err = PTR_ERR(phydev);
   122                                  goto error;
   123                          }

Is that OK?

I'm not really familiar with this hardware at all, I'm just going based
on static analysis. :/

regards,
dan carpenter
