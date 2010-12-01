Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab0LAA2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 19:28:46 -0500
Received: from tomasu.net ([64.85.170.234]:59622 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028Ab0LAA2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 19:28:45 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: LKML <linux-kernel@vger.kernel.org>
Subject: low overhead packet capturing on linux
Date: Tue, 30 Nov 2010 17:28:05 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011301728.05197.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working on a little tool to monitor and measure bandwidth use on a vm 
host, down to keeping track of all guest and host bandwidth, including, 
eventually per layer7 protocol use.

Right now I have a pretty simple setup, I setup an AF_PACKET socket, select on 
it, and read data as it comes in. Obviously, this has a fatal flaw. It takes up 
a rather large amount of cpu time just to capture the packets. On a GbE 
interface, it uses up easily 60-80% cpu (on a 2.6Ghz amd phenom II cpu core) 
just to capture the packets, trying to do anything fancy with them will likely 
cause the kernel to drop some packets.

So what I'm looking for is a very low overhead way to capture packets. I've 
come up with a few ideas, some of which I have no idea if they'd even work.

One idea that came to mind (that doesn't entirely look possible) is using 
splice or vmsplice to get me as little copying as is necessary from the net 
device to my own chunk of memory. Even better if it can be a circular queue of 
sorts. I'd probably use one thread to just sit on the socket and manage the 
packets, and a second thread to actually do the accounting on the incoming 
packets.

Anyone have any pointers or tips for me?

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
