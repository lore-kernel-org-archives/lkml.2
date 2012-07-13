Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161570Ab2GMOCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 10:02:54 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:10787 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750967Ab2GMOCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 10:02:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjUMAB0qAFBbdWOb/2dsb2JhbABFr1oiiCSBB4IgAQEEATIBBR0jAQULCxgJFg8JAwIBAgFFBg0BBwEBiAMKu1uLPIV2A5U6iSaGYIJh
X-IronPort-AV: E=Sophos;i="4.77,580,1336341600"; 
   d="scan'208";a="1018986805"
Message-ID: <50002A76.6000609@igalia.com>
Date: Fri, 13 Jul 2012 16:02:30 +0200
From: =?ISO-8859-1?Q?Miguel_G=F3mez?= <magomez@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: arnaud.patard@rtp-net.org, aaro.koskinen@iki.fi, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/19 v2] Staging: xgifb: Remove LCDA detection in xgifb_probe().
References: <cover.1341569486.git.magomez@igalia.com> <0b5331426e8c4fc37b62c58e052526c8c4a28495.1341569486.git.magomez@igalia.com> <20120709183947.GA21153@kroah.com>
In-Reply-To: <20120709183947.GA21153@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 09/07/12 20:39, Greg KH escribió:
> On Fri, Jul 06, 2012 at 12:40:38PM +0200, Miguel Gómez wrote:
>> The piece of code that checks for LCDA in xgifb_probe() just checks for some
>> register values but doesn't really do anything in response to them (the actions
>> that should be executed are commented).
>> As nothing is really being done, the code can be safely removed.
>
> Are you sure?  Some devices (foolish ones that is) need registers read
> to work properly as that is part of their start-up logic.  Yeah, it
> doesn't seem to make sense, but hardware designers usually have good
> reasons for doing this type of thing.  Or at least they think they do :)

Weird... I didn't expect that some devices might need those reads to 
work properly... I'm writing down that comment for the future ;)

> So have you tested the device after this change and it all works
> properly?  You do have this device, right?

I have an XGI Z7 card that I use for testing, and it doesn't require 
those reads to work properly, despite I don't have a Z9 or Z11 to test. 
But according to Aaro's comment, it seems that the patch is safe as 
these register reads don't have any effect.

Regards!

-- 
Miguel Gómez
Igalia - http://www.igalia.com


