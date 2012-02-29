Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab2B2QPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 11:15:47 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:39115 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932192Ab2B2QPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 11:15:46 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH 0/8] validate MAC address before call .ndo_set_mac_address
Date: Wed, 29 Feb 2012 17:14:43 +0100
User-Agent: KMail/1.9.10
References: <1330530176-24952-1-git-send-email-danny.kukawka@bisect.de> <1330531139.8460.192.camel@deadeye>
In-Reply-To: <1330531139.8460.192.camel@deadeye>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201202291714.43843.danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330532146;3bcfa974;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch, 29. Februar 2012, you wrote:
> On Wed, 2012-02-29 at 16:42 +0100, Danny Kukawka wrote:
> > Validate the given MAC address directly in dev_set_mac_address()
> > if a .ndo_validate_addr function is available before calling
> > the .ndo_set_mac_address function.
> >
> > Changed .ndo_validate_addr to take a second parameter containing
> > a sockaddr struct to be checked instead of the net_device dev_addr.
> > The behaviour of .ndo_validate_addr is now: if the second parameter
> > is NULL the net_device->dev_addr gets validate, if != NULL
> > the given parameter/sockaddr gets validated instead.
> >
> > This patch series include adaptations for some drivers which
> > use .ndo_set_mac_address functions directly - to prevent double
> > checks and to enable validations via .ndo_validate_addr.
>
> [...]
>
> You have to do this as a single patch.  The kernel and drivers should
> still build at each stage.

Okay. In this case only patch 1 and 2 needs to be merged into one commit/patch 
since the other will even work with out patch one or two. I will send a new 
version of the series as soon as I get more comments on the content.

Danny
