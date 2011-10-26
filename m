Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab1JZXpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 19:45:55 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:19997 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753334Ab1JZXpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 19:45:54 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Oct 2011 19:45:54 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAJuYqE4Y9geI/2dsb2JhbAAMHBqEdqd2VSoMAgUWCwILAwIBAgFLAQwIAQGIBCOif5IZgTCGJoEUBKYFUA
X-IronPort-AV: E=Sophos;i="4.69,412,1315195200"; 
   d="scan'208";a="144659954"
Message-ID: <4EA89972.5060101@teksavvy.com>
Date: Wed, 26 Oct 2011 19:36:18 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: asix usb network driver: nfg
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the longest time, the asix driver was _the_ usb network device of choice.
But for kernels of the last year or two, it simply has not been working
reliably here with a variety of 10, 100, and 1000 mbit USB devices.

When it fails, one just sees it sitting there trying to do DHCP,
but it's outbound packets never arrive at the DHCP server.
It can listen just fine, though (wireshark), so I suspect some
sort of blockage in the transmit path.

With some devices, it sometimes works when unplugged (USB) and replugged,
but usually that doesn't help at all here.

And even when it does manage to transmit and negotiate DHCP,
a suspend/resume cycle is enough to kill it again.

Google reveals that this is also the case for at least a few others,
and some distro forums have been directing troubled users to download
the vendor's latest open source driver to get things working again.

     http://www.asix.com.tw/download.php?sub=searchresult&PItemID=84&download=driver

The driver there does indeed work better with some of my devices,
and oddly enough when I uncomment the "// #define DEBUG" line
it then works perfectly for me here.  Just like the old days,
except noisier in the syslog.  :)

Even suspend/resume work again.

So, the in-kernel asix driver seems badly broken for a lot of hardware,
and the vendor driver also has a slight race somewhere that is cured
by enabling debug logging.

Is there an asix driver maintainer, or anyone else with the time
to step up and try to fix these issues?

Thanks
Mark


