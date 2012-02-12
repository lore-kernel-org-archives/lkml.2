Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab2BLTId (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 14:08:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44718 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab2BLTIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 14:08:31 -0500
Message-ID: <4F380E2C.3050303@lwfinger.net>
Date: Sun, 12 Feb 2012 13:08:28 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        wireless <linux-wireless@vger.kernel.org>
Subject: Question about loading firmware
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers b43 and b43legacy both load their firmware from their probe routines, 
which is a problem with the latest udev implementations, and I'm trying to fix 
that problem.

The complication is that they need to load several (3 or 4) firmware files. When 
I tried to use request_firmware_nowait() to load them in parallel, I got 
warnings that I was trying to create a duplicate name in sysfs. I presume this 
is because each of the tasks has the same name - I used the default THIS_MODULE 
value for the first argument. I'm not sure that I could change that - I don't 
see any examples in the existing source.

If I changed the probe routine to start a workqueue item that called the 
firmware loading routines, could I safely use request_firmware() in that case? 
If so, it would be a clean solution.

Thanks,

Larry

