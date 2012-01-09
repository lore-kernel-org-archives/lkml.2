Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436Ab2AIVLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 16:11:40 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:32554 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933062Ab2AIVLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 16:11:38 -0500
X-Authority-Analysis: v=2.0 cv=AqJsLZBP c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=zQGhUK9Iw4MA:10 a=8nJEP1OIZ-IA:10 a=Lzabj1l8GfN3Mhb02_wA:9 a=dp46X55juV-uD1xln6gA:7 a=wPNLvfGTeEIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.78.168.186
Message-ID: <4F0B5808.2010900@cfl.rr.com>
Date: Mon, 09 Jan 2012 16:11:36 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Multiple consoles
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was considering some questions I read about setting up a multi-seat 
system where you have two separate sets of displays, keyboards, mice, 
and X servers.  The problem someone noticed is that if you run the 
second X server on tty8, then you have to switch the console to tty8 to 
activate it, which disables the primary X server.

It occurred to me that there ought to be an entirely separate set of 
virtual consoles bound to the second seat, and the second X server ought 
to run on one of those vcs.  Or of course, you could choose to log into 
the console and not bother with X.

Looking at drivers/tty/vt/vt.c, it appears that it was written assuming 
that there is just one linux console.  It appears to use global 
variables for keeping track of which vc is active, etc, rather than 
creating one or more console devices, and store the vc multiplexing 
information in those devices.  So to fix this, vt.c and keyboard.c would 
need significantly refactored to remove the global variables and create 
a console device to bind vcs, keyboards, and displays to, and then you 
could create a second one if you wanted.

Does this make sense or am I missing something?
