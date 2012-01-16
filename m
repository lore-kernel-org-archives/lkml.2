Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab2APHiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 02:38:25 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35081 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab2APHiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 02:38:23 -0500
MIME-Version: 1.0
In-Reply-To: <4F120357.3020808@linux.intel.com>
References: <132d2a41a089905de3147b4656e350608aa7fd6f.1326523495.git.dvhart@linux.intel.com>
	<20120114.001430.787918662083526597.davem@davemloft.net>
	<4F11A533.4040406@linux.intel.com>
	<20120114.115604.2101782124431552110.davem@davemloft.net>
	<20120114214658.4ddfec30@pyramind.ukuu.org.uk>
	<4F120357.3020808@linux.intel.com>
Date: Mon, 16 Jan 2012 16:38:23 +0900
Message-ID: <CANKRQnge1n4M7W5xCqwyGzXp8J3eK1HbZVRqGW7BoE5iOwYCDQ@mail.gmail.com>
Subject: Re: [PATCH] pch_gbe: Use a randomly generated MAC instead of failing probe
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, arjan@linux.intel.com,
        alan@linux.intel.com, jeffrey.t.kirsher@intel.com,
        paul.gortmaker@windriver.com, jdmason@kudzu.us, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/16 Darren Hart <darren.hart@intel.com>:
> I have since resolved this particular issue. I did not disable the
> pcieqos driver I forward ported. With that disabled, pch_phub works as
> expected.
Yes, you can not use both pcieqos and pch_phub at the same time.
Because pcieqos is previous version of pch_phub which is upstreamed.


> Which is to say it lists pch_mac, reads all 0's, and does
> nothing on write (since the MAC ROM doesn't exist). Please see the patch
> thread from Friday to address this using a random mac if the ROM is
> missing or invalid.
Saving MAC address into external ROM is generic method, I think.
Though I know the ROM-less system using eg20t-pch, however I think
this system is not common.
So, I think pch_gbe shouldn't have auto-mac address assignment.

BTW, as you know, a use can write MAC address using sysfs file system
like below.
echo aa:bb:cc:dd:ee:ff > pch_mac

thanks,
tomoya
