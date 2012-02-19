Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab2BSSky (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 13:40:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53769 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab2BSSkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 13:40:51 -0500
Message-ID: <4F414230.5040506@lwfinger.net>
Date: Sun, 19 Feb 2012 12:40:48 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        wireless <linux-wireless@vger.kernel.org>,
        linux-hotplug@vger.kernel.org
Subject: will these methods work with firmware loading?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I sent a previous messages to most of these lists, but got no answer, thus a 
second try.

When a driver loads firmware synchronously in the module_init() path using 
request_firmware(), then there is trouble with timeouts when booting.

I know that changing the request_firmware() call to request_firmware_nowait() 
solves the problem; however, that gives some trouble for driver b43legacy as it 
loads 3 or 4 firmware files depending on the hardware version. When I launch the 
3 or 4 nowait requests, I get an error because the system is trying to start 
several tasks with the same name.

Would it be OK to load the first file with the nowait version, and issue a 
request_firmware() for the others from the callback routine? I think that would 
not cause any problems, but I would like to get confirmation from an expert.

Similarly, if I were to create a work queue, init and schedule it from 
module_init(), and then use synchronous loads to get the firmware from the work 
queue callback, would that get around the boot problem? I know it works as I 
have trial patches; however, my version of udev is not one affected. This method 
is very easy to implement, but again I would like confirmation from an expert.

Thanks,

Larry
