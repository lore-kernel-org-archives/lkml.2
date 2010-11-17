Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461Ab0KQNF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:05:26 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56047 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab0KQNFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:05:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UxtiYeUIYxFTzKo6Y/XUrMZ95MGIIYEA6mtYiAzlXaBGFxishcGBRAGPZNB5t1Ooj1
         Zn/snveombA3Lot/VvsDrEZTIer8KrEhtcIv/9nhT5m8nhpMdCQyPMESProCcgQ+5/Ik
         +na+r2C2Q8ymZ1+JbGk9mODKa3wzAj7Jqo5hU=
Subject: Re: 2.6.37-rc2 regression: usb network hotplug
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Patrick Schaaf <netdev@bof.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1289995848.5034.5.camel@lat1>
References: <1289995848.5034.5.camel@lat1>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 14:05:17 +0100
Message-ID: <1289999117.2687.26.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 17 novembre 2010 à 13:10 +0100, Patrick Schaaf a écrit :
> When trying out 2.6.37-rc2 on my Dell Latitude D630 laptop, I notice a
> regression, compared to plain 2.6.36, related to USB unplugging my N900
> (cdc_ether network device).
> 
> The usb0 interface is configured to automatically plug into a bridge
> group, if that matters.
> 
> On 2.6.36 I can unplug and replug the device properly.
> 
> Under 2.6.37-rc2, the first plugging works, the device is reachable as
> desired, but after unplugging it the first time, I receive the following
> message every 10 seconds:
> 
>  kernel:[  149.632104] unregister_netdevice: waiting for usb0 to become
> free. Usage count = 1
> 
> The usb0 device is gone at that point. Replugging does not work.
> 
> When I reboot into the same kernel, a list of "cannot reset port"
> messages is apparent in the boot logs, as appended. This disappears
> after shutting down the machine.
> 
> I'll gladly try out patches that could fix this, or try out other things
> to help diagnose.
> 
> best regards
>   Patrick
> 
> <3>[    4.449056] usb 6-1.2: device not accepting address 3, error -71
> <3>[    4.452793] hub 6-1:1.0: cannot disable port 2 (err = -71)
> <3>[    4.454787] hub 6-1:1.0: cannot reset port 2 (err = -71)
> <3>[    4.456787] hub 6-1:1.0: cannot reset port 2 (err = -71)
> <3>[    4.458787] hub 6-1:1.0: cannot reset port 2 (err = -71)
> <3>[    4.460787] hub 6-1:1.0: cannot reset port 2 (err = -71)
> <3>[    4.462786] hub 6-1:1.0: cannot reset port 2 (err = -71)
> <3>[    4.464491] hub 6-1:1.0: Cannot enable port 2.  Maybe the USB
> cable is bad?
> <3>[    4.466787] hub 6-1:1.0: cannot disable port 2 (err = -71)
> <3>[    4.468785] hub 6-1:1.0: cannot reset port 2 (err = -71)
> <3>[    4.470786] hub 6-1:1.0: cannot reset port 2 (err = -71)
> <3>[    4.472787] hub 6-1:1.0: cannot reset port 2 (err = -71)
> <3>[    4.474780] hub 6-1:1.0: cannot reset port 2 (err = -71)
> <3>[    4.476784] hub 6-1:1.0: cannot reset port 2 (err = -71)
> <3>[    4.478261] hub 6-1:1.0: Cannot enable port 2.  Maybe the USB
> cable is bad?
> <3>[    4.479773] hub 6-1:1.0: cannot disable port 2 (err = -71)
> <3>[    4.481773] hub 6-1:1.0: cannot reset port 2 (err = -71)
> <3>[    4.483772] hub 6-1:1.0: cannot reset port 2 (err = -71)
> <3>[    4.485778] hub 6-1:1.0: cannot reset port 2 (err = -71)
> <3>[    4.487787] hub 6-1:1.0: cannot reset port 2 (err = -71)
> <3>[    4.489789] hub 6-1:1.0: cannot reset port 2 (err = -71)
> <3>[    4.491052] hub 6-1:1.0: Cannot enable port 2.  Maybe the USB
> cable is bad?
> <3>[    4.492788] hub 6-1:1.0: cannot disable port 2 (err = -71)
> <3>[    4.494079] hub 6-1:1.0: unable to enumerate USB device on port 2
> <3>[    4.495787] hub 6-1:1.0: cannot disable port 2 (err = -71)
> <3>[    4.497790] hub 6-1:1.0: hub_port_status failed (err = -71)
> <6>[    4.499100] usb 6-1: USB disconnect, address 2
> 

Please try

http://patchwork.ozlabs.org/patch/71354/



