Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab1JSLRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 07:17:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49309 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab1JSLRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 07:17:19 -0400
Message-ID: <4E9EB1BC.9020709@yahoo.co.uk>
Date: Wed, 19 Oct 2011 12:17:16 +0100
From: Sam Tygier <samtygier@yahoo.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 3.1rc10 null pointer dereference ideapad_backlight_notify_power
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:kIxA+AAUhlYM8Xfgzd+v2xTirdI5gwOwnZom0iqGQef
 xwWxZA7Kl3emZfp/L7xMl8++uUSWfhDEZHz1PrOw7S9KJ7O7QI
 Szm+9oOyHOnp/m9spCMS0iDbb4i/saG+puABwKdzRGnheGLghV
 00jBuBb+ftdB/t4ihwbO3vqa01aN3EBH8ZdguZWOpxzstasFl5
 EpxnjuaouSWsXJQQRilMWqFd/75tK13CiM67Sr65r51nLgpIl6
 +zXrv1uarDmKyJXRo2G5ii9TCmRTQgVHsAXxNbDTcNbJFCD85Z
 EtfqHzf0m9HdbISiVqdqqOQ0SJ5ogw0B2uZr/D7m+4MKgnuBg=
 =
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernels 3.1rc9 and 3.1rc10 (from the ubuntu mainline repo) I get a crash when disabling and then enabling the screen backlight with the alt+f2 key on a lenovo ideapad S12 (intel version). The crash does not occur with 3.0 kernels in ubuntu.  I have not tested earlier 3.1 rcs.

The crash message scrolls to fast to see, it is not writen to a log, and i dont see it on a USB serial console (I may be doing something wrong, but I do see other messages during boot). I managed to get some photos of the message. interesting parts are:

BUG: unable to handle kernel NULL pointer dereference at 00000008
IP: [<f807b29e>]  ideapad_backlight_notify_power+0x2e/0x40 [ideapad_laptop]
*pde = 00000000
Oops: 0002 [#1] SMP

call trace functions:
ideapad_acpi_notify
acpi_device_notify
acpi_ev_notify_dispach
acpi_os_execute_deferred
process_one_work
? acpi_os_wait_events_complete
????????? can't read this one
kthread
kthread_bind
kernel_thread_helper

i put the photos at http://www.hep.manchester.ac.uk/u/sam/pub/ideapad/

if it would be helpfull, i could try a few more times for sharper photos. please let me know if there is any other useful information you need.

thanks,
sam  
