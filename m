Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab0IWQ1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 12:27:43 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:45615 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab0IWQ1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 12:27:41 -0400
Date: Thu, 23 Sep 2010 19:25:21 +0300
From: Ville Tervo <ville.tervo@nokia.com>
To: ext Alan Ott <alan@signal11.us>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Antonio Ospite <ospite@studenti.unina.it>,
        Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Stephane Chatty <chatty@enac.fr>, Michael Poole <mdpoole@troilus.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bastien Nocera <hadess@hadess.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 0/2] Get and Set Feature Reports on HIDRAW (USB and
 Bluetooth)
Message-ID: <20100923162521.GA15641@null>
References: <1281442367.12579.206.camel@localhost.localdomain>
 <1281990059-3562-1-git-send-email-alan@signal11.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281990059-3562-1-git-send-email-alan@signal11.us>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Mon, Aug 16, 2010 at 10:20:57PM +0200, ext Alan Ott wrote:
> This is version 4. Built against 2.6.35+ revision 320b2b8de12698 .


I gave a try to to this patch using your test tool [1] and very old BT
keyboard. I don't have anything else ATM to test with. Is there some BT hid
devices which support setting and getting features?

Shouldn't HIDIOCSFEATURE's bt version have similar wait as HIDIOCGFEATURE to
get report status back from the device? or is there even any status coming back
in successful case? Sorry I'm a newbie with HID and trying to understand how
this should work.

Now it just returns num of send bytes even if the remote device returned some
error. Which one is the expected behavior?

Other problem is that Get report is getting now handshake from set report.


2010-09-23 17:55:46.680612 < ACL data: handle 38 flags 0x02 dlen 9
    L2CAP(d): cid 0x008b len 5 [psm 17]
      HIDP: Set report: Feature report
      0000: 09 ff ff ff                                       ....
2010-09-23 17:55:46.680653 < ACL data: handle 38 flags 0x02 dlen 6
    L2CAP(d): cid 0x008b len 2 [psm 17]
      HIDP: Get report: Feature report
      0000: 09                                                .
2010-09-23 17:55:46.697577 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 38 packets 1
2010-09-23 17:55:46.698579 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 38 packets 1
2010-09-23 17:55:46.776827 > ACL data: handle 38 flags 0x02 dlen 5
    L2CAP(d): cid 0x0040 len 1 [psm 17]
      HIDP: Handshake: Invalid parameter
2010-09-23 17:55:46.777069 < ACL data: handle 38 flags 0x02 dlen 7
    L2CAP(d): cid 0x008b len 3 [psm 17]
      HIDP: Data: Output report
      0000: 01 77                                             .w
2010-09-23 17:55:46.797577 > HCI Event: Number of Completed Packets (0x13) plen 5
    handle 38 packets 1
2010-09-23 17:55:46.816826 > ACL data: handle 38 flags 0x02 dlen 5
    L2CAP(d): cid 0x0040 len 1 [psm 17]
      HIDP: Handshake: Invalid parameter
2010-09-23 17:55:46.856828 > ACL data: handle 38 flags 0x02 dlen 5
    L2CAP(d): cid 0x0040 len 1 [psm 17]
      HIDP: Handshake: Unsupported request



[1] http://lkml.org/lkml/2010/6/17/414

-- 
Ville the HID newbie
