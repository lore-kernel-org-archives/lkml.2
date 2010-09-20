Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab0ITS3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:29:42 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43628 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab0ITS3l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:29:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wdA0UCetCg5MeDza9no9Y2HrgYAI1Pk6L8VdFF2pTXhKZ4fhawB/G1EG6yV5R11wHs
         4oc2bBFNxUQEgtupwLcW+tf9sDcCeHXFt/ils8u6Lp4Xvx6kU1YkfrkJo2+LtP9SZzc2
         MBlGSVz2Ge/sYSf0JOQu9Ob34F+hoIzbfGe0k=
MIME-Version: 1.0
In-Reply-To: <1284987540.2242.29.camel@morgan.silverblock.net>
References: <1284987540.2242.29.camel@morgan.silverblock.net>
Date: Mon, 20 Sep 2010 20:29:40 +0200
Message-ID: <AANLkTikj4biBS7wQsRM6o3kEmyaPNMaSUBEktMmmOy89@mail.gmail.com>
Subject: Re: [PATCH] drm/sysfs: Provide per connector control of DRM KMS polling
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Jon Smirl <jonsmirl@gmail.com>, dri-devel@lists.freedesktop.org,
        Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/20 Andy Walls <awalls@md.metrocast.net>:
> DRM KMS polling of connections providing errant EDID responses, or
> polling of "connectors" that have chips responding on DDC I2C bus
> address 0xA0/0xA1 with no actual physical connector nor EDID EEPROM,
> will create perpetual noise in dmesg and the system log every 10
> seconds.  Currently the user has apparently little recourse to silence
> these messages aside from replacing the offending cable, monitor, or
> graphics adapter.  That recourse is impossible for an unused DVI-D
> "connector" of an internal graphics processor on a motherboard that
> provides no physical DVI-D connector.
>
> This change allows the root user to disable (and re-enable) DRM KMS
> connector polling on a per connector basis via sysfs, like so:

Huh, I didn't imagine solution of this issue that way. AFAIR previous
thread, something else was suggested, it was about storing the fact
that user already received warning/info about error.

Why I don't really like proposed solution?
1) You need to be root
2) Need to know and play with some "magic" sysfs file.

I thing it would be much better and user-friendly to display such an
error just once per display. How this could be implemented?

1) Add field like "warned" to connector struct, default to 0
2) if (warning_to_be_printed && !connector->warned) { printk();
connector->warned = 1
3) if (connector_disconnected) { connector->warned = 0; }

This was you will get just one warning per connected display. Of
course after disconnecting it we have to clear "warned", as user may
connect another "broken" display, then we should print warning again.

What do think about this solution?

-- 
Rafał
