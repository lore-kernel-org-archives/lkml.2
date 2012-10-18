Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab2JRKCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:02:36 -0400
Received: from smtp.citrix.com ([66.165.176.89]:11858 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123Ab2JRKCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:02:33 -0400
X-IronPort-AV: E=Sophos;i="4.80,606,1344211200"; 
   d="scan'208";a="41650871"
Message-ID: <507FD39F.4060601@citrix.com>
Date: Thu, 18 Oct 2012 11:02:07 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Jens Axboe <axboe@kernel.dk>,
        <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        <linux-fbdev@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH 0/5] drivers: xen frontend devices should handle missed backend
 CLOSING
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subsystem maintainers, you can either pick up the relevant driver patch
or ack it to go via Konrad's Xen tree.

The series makes all the Xen frontend drivers handle the backend
transitioning to CLOSED without the frontend having previously seen
the backend in the CLOSING state.

Backends shouldn't do this but some do.  e.g., if the host is
XenServer and the toolstack decides to do a forced shutdown of a VBD,
then the blkfront may miss the CLOSING transition and the /dev/xvdX
device will not be destroyed which prevents it being reused.

I have seen systems that ended up in this state but it's not clear if
this was the actual cause.  However, I think in general it's a good
thing to thing to improve the handling of unexpected state
transitions.

David
