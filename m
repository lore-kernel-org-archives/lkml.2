Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab2BTJqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 04:46:16 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:59056 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab2BTJqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 04:46:14 -0500
Subject: Re: will these methods work with firmware loading?
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        wireless <linux-wireless@vger.kernel.org>,
        linux-hotplug@vger.kernel.org
In-Reply-To: <4F414230.5040506@lwfinger.net> (sfid-20120219_194128_235089_6C62CE24)
References: <4F414230.5040506@lwfinger.net>
	 (sfid-20120219_194128_235089_6C62CE24)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Feb 2012 10:46:07 +0100
Message-ID: <1329731167.3458.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Larry,

> I know that changing the request_firmware() call to request_firmware_nowait() 
> solves the problem; however, that gives some trouble for driver b43legacy as it 
> loads 3 or 4 firmware files depending on the hardware version. When I launch the 
> 3 or 4 nowait requests, I get an error because the system is trying to start 
> several tasks with the same name.
> 
> Would it be OK to load the first file with the nowait version, and issue a 
> request_firmware() for the others from the callback routine? I think that would 
> not cause any problems, but I would like to get confirmation from an expert.

That should work -- I just looked at the firmware code and it spawns a
new thread for every "nowait" request (and it calls the callback in that
thread's context), so it won't block against itself.

> Similarly, if I were to create a work queue, init and schedule it from 
> module_init(), and then use synchronous loads to get the firmware from the work 
> queue callback, would that get around the boot problem? I know it works as I 
> have trial patches; however, my version of udev is not one affected. This method 
> is very easy to implement, but again I would like confirmation from an expert.

We discussed that before, and technically it should work, I'm just a bit
worried about udev treating asynchronous and synchronous requests
differently and that causing issues, but somebody who knows udev better
will have to comment on that.

johannes

