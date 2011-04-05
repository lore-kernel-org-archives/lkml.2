Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab1DEBxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 21:53:05 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33878 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab1DEBwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 21:52:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=cwytOb4C9LtRyK5+E/Xkg1hjWbp2jSXLmoj1r1vfI1165n9cu0u8ijaJqvXeSgdh3r
         8NzKSsDGy+z5Zr+NHn1fsyE2Op4nrIDyAWYEVHcAu8fOh+YpgzNOmHgKo+SjeSXik+yq
         Yy5eGt4XEKDq37swkF9JaJGdWU88vVuhL9Mw0=
MIME-Version: 1.0
In-Reply-To: <4D998DC9.3040109@mimc.co.uk>
References: <4D998DC9.3040109@mimc.co.uk>
Date: Mon, 4 Apr 2011 18:52:53 -0700
X-Google-Sender-Auth: XEBiRAOYWzSa0ona2P_WUVDstKA
Message-ID: <BANLkTi=-LoPdE3U9__MRi4j4L_c8zk5VpA@mail.gmail.com>
Subject: Re: [regression] 2.6.39-rc1 - Beagleboard usbnet broken
From: john stultz <johnstul@us.ibm.com>
To: Mark Jackson <mpfj-list@mimc.co.uk>
Cc: linux-omap@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 4, 2011 at 2:22 AM, Mark Jackson <mpfj-list@mimc.co.uk> wrote:
> Running 2.6.38 on my beagleboard, I can boot using nfs:-
[snip]
> I have just tried out 2.6.39-rc1, and the usbnet is no longer detected:-

Yea, I hit something similar, where on the beagleboard I only see the
root hubs, and not any of the devices (no usb, no keyboard, etc).

I bisected it down to:
commit 9e64bb1e9f0613093b3e34ac5402fcfef0dcc35a
Author: Keshava Munegowda <keshava_mgowda@ti.com>
Date:   Tue Mar 1 20:08:19 2011 +0530

    arm: omap: usb: Invoke usbhs core device initialization

thanks
-john
