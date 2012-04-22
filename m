Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab2DVPwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 11:52:13 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:42433 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab2DVPwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 11:52:11 -0400
Date: Sun, 22 Apr 2012 23:52:02 +0800
From: Richard Yang <weiyang@linux.vnet.ibm.com>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: One problem in reassign pci bus number?
Message-ID: <20120422155202.GA13540@richard>
Reply-To: Richard Yang <weiyang@linux.vnet.ibm.com>
References: <20120410090306.GA7056@richard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410090306.GA7056@richard>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12042215-5816-0000-0000-0000023DB204
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

I am reading the pci_scan_bridge() and not sure what will happen in
following situation.

Suppose the kernel is not passed the pci=assign-busses.

Below is a picture about the pci system.

                   +-------+       
                   |       | root bridge(0,255)
                   +---+---+       
                       |          Bus 0 
      -----+-----------+------------------------------+--
           |                                          |
           |                                          |
           |                                          |
      +----+----+                               +-----+-----+
      |         |  B1(1,15)                     |           |B2(16,28)
      +----+----+                               +-----+-----+
           |  Bus 1                                   |    Bus 16           
      -----+-----------------------         ----------+----------------
                            |
                       +----+----+
                       |         | B3               
                       +---------+                
                                                 
Suppose B1 and B2 works fine with the BIOS, which get the right bus
number and range.

B3 does not works fine with the BIOS, which doesn't get the bus number.

So in pci_scan_bridge(), B3 will be met in the second pass and get bus
number 16?
Would this be a conflict?

-- 
Richard Yang
Help you, Help me

