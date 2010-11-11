Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab0KKM7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:59:03 -0500
Received: from dtp.xs4all.nl ([80.101.171.8]:64810 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756357Ab0KKM7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:59:02 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Nov 2010 07:59:01 EST
Date: Thu, 11 Nov 2010 13:52:19 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: linux-kernel@vger.kernel.org
Subject: Sync semantics. 
Message-ID: <20101111125219.GA945@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

What should I expect from a "sync" system call?

The manual says: 

   sync() first commits inodes to buffers, and then buffers to disk.

and then goes on to state: 

   ... since  version  1.3.20 Linux does actually wait.

[for the buffers to be handed over to the drive]

So how long can I expect a "sync" call to take? 

I would expect that all buffers that are dirty at the time of the
"sync" call are written by the time that sync returns. I'm currently
bombarding my fileserver with some 40-60Mbytes per second of data to
be written (*). The fileserver has 8G of memory. So max 8000 Mb of
dirty buffers can be stored, right? The server writes an average of
(at least) 40Mb/second to disk. According to my calculator, I will
have to wait up to 200 seconds for the sync system call to return....


# time sync
0.000u 0.220s 2:22:23.96 0.0%   0+0k 0+0io 2pf+0w

Two hours 22 minutes. 

I typed the "time sync" again, and it hasn't returned yet.... Actually
I don't expect it to before 6-hours-from-now because that's when the
clients will run out of data to send.

wolff    13706  0.0  0.0   1816   208 pts/12   D+   12:08   0:00 sync
wolff    14116  0.0  0.0   1908   520 pts/34   S+   13:48   0:00 grep sync

It's been running 100 minutes by now..... 


(*) The three clients are each sending 20-35 Mb/second but are being
held up by the server who doesn't seem to be handling more than about
40-50Mb/sec total.

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
