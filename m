Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab1BWMZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:25:06 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37632 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab1BWMZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:25:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=W6CVs9iOvP27RNxMI8XAybcAvC4WSMiXZKptGv0DHYUatFhmlfpVhjipeTxWU/hOke
         nmaDiz4t4jTzNsZN+M4rIszd05tuNURYfStvpFDQOhc7IPJx2lVpybcKbGDISv5foMDy
         vgsNrPkg99uGwZy60dBSscfCKIDct0VmaYPJY=
Date: Wed, 23 Feb 2011 15:24:43 +0300
From: Dan Carpenter <error27@gmail.com>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Manohar Vanga <manohar.vanga@cern.ch>, devel@driverdev.osuosl.org,
        gregkh@suse.de, cota@braap.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: vme: fix bug in vme_register_bridge
Message-ID: <20110223122443.GS1898@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Martyn Welch <martyn.welch@ge.com>,
	Manohar Vanga <manohar.vanga@cern.ch>, devel@driverdev.osuosl.org,
	gregkh@suse.de, cota@braap.org, linux-kernel@vger.kernel.org
References: <1298453209-30821-1-git-send-email-manohar.vanga@cern.ch>
 <4D64D70A.1060007@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D64D70A.1060007@ge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 09:44:42AM +0000, Martyn Welch wrote:
> On 23/02/11 09:26, Manohar Vanga wrote:
> > Fix a bug in vme_register_bridge that results in an infinite loop in
> > the event that device_register fails.

[snip]

> > +	/*
> > +	 * Ignore the failed device and unregister the rest.
> > +	 */
> > +	i--;
> >  	while (i > -1) {
> >  		dev = &bridge->dev[i];
> >  		device_unregister(dev);
> > +		i--;
> >  	}

Ah.  I see you fixed the bug already.  Good deal.  Btw, no need to add
comments for the obvious stuff.

You still aren't CCing the right list, devel@driverdev.osuosl.org.
It's not enough for Martyn to sent it to us, because by that point 
the patch has '> ' chars on every line.

regards,
dan carpenter
