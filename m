Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab1E1OGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 10:06:38 -0400
Received: from mail001.aei.ca ([206.123.6.130]:55848 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab1E1OGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 10:06:37 -0400
From: Ed Tomlinson <edt@aei.ca>
To: linux-kernel@vger.kernel.org
Subject: [regression] Apple Magic Mouse stalls
Date: Sat, 28 May 2011 10:06:33 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.39-crc+; KDE/4.6.3; x86_64; ; )
Cc: chase.douglas@canonical.com, rydberg@euromail.se, jkosina@suse.cz,
        linux-input@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105281006.33763.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've been having fun with bluetooth in .38-rc.  My adapter was old (bt 1.1) and the bluetooth stack was having 'fun' with it.
Got tired of that a got asus doggle that supports 2.1+EDR.  Then I tried to use my magic mouse.  It works for a few
minutes and then stalls.  The stalls seem to be related to touches.  If I am careful only to touch with one finger it
seems to work.  It usually works with two fingers, with three it stalls.   Running hcidump sometimes lists a last 
packet with a dlen of 35 when it stalls.  Powering it on an off reset things 

> ACL data: handle 21 flags 0x02 dlen 27
    L2CAP(d): cid 0x0041 len 23 [psm 0]
> ACL data: handle 21 flags 0x02 dlen 27
    L2CAP(d): cid 0x0041 len 23 [psm 0]
> ACL data: handle 21 flags 0x02 dlen 27
    L2CAP(d): cid 0x0041 len 23 [psm 0]
> ACL data: handle 21 flags 0x02 dlen 35
    L2CAP(d): cid 0x0041 len 31 [psm 0]

This was not a problem pre .38.  It started happening in .38-rc along with other bluetooth problems.  I figured the bt
problem was the root cause - I was wrong.

This ring any bells?

TIA
Ed Tomlinson
