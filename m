Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1IFRgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 13:36:17 -0400
Received: from peace.netnation.com ([204.174.223.2]:43613 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab1IFRgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 13:36:10 -0400
Date: Tue, 6 Sep 2011 10:36:05 -0700
From: Simon Kirby <sim@hostway.ca>
To: linux-kernel@vger.kernel.org, Jon Mason <mason@myri.com>,
        Jordan_Hargrave@dell.com
Subject: [3.1-rc4] Bus Fatal Error caused by "PCI: Set PCI-E Max Payload
	Size on fabric"
Message-ID: <20110906173605.GA12577@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Since trying 3.1-rc4 on a few Dell servers, all of them have booted up
with the amber error LED lit. "ipmitool sel list" shows:

   1 | 09/06/2011 | 17:21:56 | Event Logging Disabled #0x72 | Log area reset/cleared | Asserted
   2 | 09/06/2011 | 17:25:38 | Critical Interrupt #0x18 | Bus Fatal Error | Asserted
   3 | 09/06/2011 | 17:25:38 | Unknown #0x1a | 
   4 | 09/06/2011 | 17:25:38 | Unknown #0x1a | 

I bisected this to:

b03e7495a862b028294f59fc87286d6d78ee7fa1 is the first bad commit
commit b03e7495a862b028294f59fc87286d6d78ee7fa1
Author: Jon Mason <mason@myri.com>
Date:   Wed Jul 20 15:20:54 2011 -0500

    PCI: Set PCI-E Max Payload Size on fabric

It sounds like this has caused other problems as well: http://www.spinics.net/lists/linux-scsi/msg54464.html    

In this case, the 6 or so boxes I've see the issue on are all PowerEdge 2950 servers.

Simon-         
