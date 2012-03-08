Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272Ab2CHSys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:54:48 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:33012 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757292Ab2CHSyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:54:45 -0500
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1/qLQxM46nqVWZPpS8VEJzGH+83DFhTBMAYNIGidZ
	oRny8Mgv5W8dz3
Message-ID: <4F590069.1050207@fisher-privat.net>
Date: Thu, 08 Mar 2012 19:54:33 +0100
From: "Oleksij Rempel (fishor)" <bug-track@fisher-privat.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120302 Thunderbird/11.0
MIME-Version: 1.0
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: memory corruption  after suspend - ultrabook not able to turn on
 after failed suspend, EHCI workaround - Asus Zenbook UX31E
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo all,

Alan Stern suggested me to ask on this lists. The problems seems to be 
complicated. https://bugzilla.kernel.org/show_bug.cgi?id=42728

So now to the problem.

Symptoms are fallowing, after initiating suspend this laptop freezes. 
After forcing after poweroff, it is really hard to power on this laptop. 
linux kernel gets oops, windows will get BSOD.

I tried /sys/power/pm_test and i got fallowing result. Setting 
pm_test=devices do not make any problems. With pm_test=processors the 
test runs ok, but after power off i get same result as with filed suspend.

Steps to reproduce:
- echo 0 > pm_async
- echo processors > pm_test
- echo mem > state
(here the display will go off, usb mouse powered off too, after one 
second it returns back to console .... no freezes)
- poweroff
- after power on, start memtest .... here i will get lots of bad memory 
blocks.

the processor is Intel Core i7-2677M. According to the specification it 
has build in memory controller. I assume the controller is some how 
misconfigured at suspend, this is why i get bad blocks with memtest86+. 
It looks like the laptop stay in this broken supend mode even after 
poweroff. To bring it back to normal i need to completely poweroff it, 
it mean unplug battery and powersupply.
