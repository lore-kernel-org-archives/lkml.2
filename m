Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab1BAI6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 03:58:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32836 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab1BAI6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 03:58:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ksjxpaqGHLTQeaonDTxQyw6wujsadwzckRJjBasEgdeeySVRU0bxmtQoM06DT2LsS2
         in82oPrix9F9hWTUxRvLbuGWjp5rKND7dbtqnGT3QpAmEOJw8NaxLcZMVfovEhxaSIJE
         kZILqxizMy0IXeQ01B/Mn/DMIz/iWaPtcAJL4=
Date: Tue, 1 Feb 2011 00:58:23 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: tapio.vihuri@nokia.com
Cc: peter.ujfalusi@nokia.com, randy.dunlap@oracle.com,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        ilkka.koskinen@nokia.com, samu.p.onkalo@nokia.com
Subject: Re: [PATCH v6 0/3] input: Add support for ECI (multimedia)
 accessories
Message-ID: <20110201085823.GB17706@core.coreip.homeip.net>
References: <1296482634-31666-1-git-send-email-tapio.vihuri@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296482634-31666-1-git-send-email-tapio.vihuri@nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tapio,

On Mon, Jan 31, 2011 at 04:03:51PM +0200, tapio.vihuri@nokia.com wrote:
> 
> This patch set introduce Multimedia Headset Accessory support for
> Nokia phones. Technically those are known as ECI (Enhancement Control Interface)
> 	
> If headset has many buttons, like play, vol+, vol- etc. then it is propably ECI
> accessory.
> 
> Among several buttons ECI accessories contains memory for storing several
> parameters.
> 
> This ECI input driver provides the following features:
>  - reading ECI configuration memory
>  - ECI buttons as input events
> 
> Drive is constructed as follows:
>  - ECI accessory input driver deals with headset accessory
>  - ECI bus control driver deals the HW transfering data to/from headset
>  - platform data match used HW

I finally had a chance to look though the patches more closely and I do
not understand why you decided to introduce the platform device in
addition to I2C device. You end up with 2 artificially separated bodies of
code that are not viable on their own. The ECI module with it's platform
device is not usable without the controller; the controller can not be
registered without the ECI device initialized; there are ordering
issues, both initialization and PM-wise and you are forced to support
only one device.

Is there going to be an SPI interface as well? If not then fold it all
together and have I2C device as the only device involved. If SPI is a
possibility then look in drivers such as adxl34x, ad714x and others that
are split into core module and bus interface implementations.

Thanks.

-- 
Dmitry
