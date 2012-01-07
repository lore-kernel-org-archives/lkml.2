Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab2AGML1 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 7 Jan 2012 07:11:27 -0500
Received: from h118.nextmail.ru ([194.67.36.118]:46270 "EHLO h118.nextmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab2AGMLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 07:11:25 -0500
To: =?koi8-r?B?TW9oYW1tZWQgU2hhZmk=?= <shafi.wireless@gmail.com>
From: =?koi8-r?B?TVI=?= <g7af0ec1e3ea1e7b1@nextmail.ru>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: =?koi8-r?B?UmU6IGF0aDlrIGNyYXNoIDMuMi1yYzc=?=
Date: Sat, 07 Jan 2012 16:11:21 +0400
X-Mailer: NextMail.Ru
X-RemoteAddr: 195.91.224.225
Message-ID: <NEXT-4f0836697a46a0.73058707@nextmail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > thanks for the providing the log. it looks like there is some other
 > problem in doing the chip reset and
 >eventually when we get into ath_update_survey_stats we are hitting the
 >panic.
 > you can try two things:
 > 
 > *after these WARNINGS, is your card in some stable state?. are you
 > able to see it in lspci(ie does it gets disappeared) and still
 > continue your wifi operation. if not then there is some other problem
 > while the panic is a symptom of it.

There is another failure mode. 

I think rmmod/modprobe says all:

Jan  7 00:25:04 401a0bf1 kernel: [ 5373.686727] ath9k: Driver unloaded
Jan  7 00:25:07 401a0bf1 kernel: [ 5376.441778] ath9k 0000:03:00.0: enabling 
device (0000 -> 0002)
Jan  7 00:25:07 401a0bf1 kernel: [ 5376.441789] ath9k 0000:03:00.0: PCI INT A 
-> GSI 17 (level, low) -> IRQ 17
Jan  7 00:25:07 401a0bf1 kernel: [ 5376.441802] ath9k 0000:03:00.0: setting 
latency timer to 64
Jan  7 00:25:07 401a0bf1 kernel: [ 5376.558038] ath: Couldn't reset chip
Jan  7 00:25:07 401a0bf1 kernel: [ 5376.558042] ath: Unable to initialize 
hardware; initialization status: -5
Jan  7 00:25:07 401a0bf1 kernel: [ 5376.558048] ath9k 0000:03:00.0: Failed to 
initialize device
Jan  7 00:25:07 401a0bf1 kernel: [ 5376.558092] ath9k 0000:03:00.0: PCI INT A 
disabled
Jan  7 00:25:07 401a0bf1 kernel: [ 5376.558259] ath9k: probe of 0000:03:00.0 
failed with error -5

When I had the card just stop working without crashing my notebook (3.0, 3.1) 
I got the same when trying to reload the driver.

 > *does the other patch which remove some suspicious looking code, to
 > see if it improves the situation and avoids the warnings itself.

I have built and loaded the kernel with this patch. I even have netconsole 
apparently working. But ten hours have not elapsed yet. So far so good.

If it works till the 10th, I will test it with roaming, too. 


