Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933378Ab1FAKYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 06:24:30 -0400
Received: from ix03.ka.hist.no ([158.38.48.167]:50092 "EHLO ix03.ka.hist.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758700Ab1FAKY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 06:24:29 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jun 2011 06:24:28 EDT
Message-ID: <4DE6103E.6010100@hist.no>
Date: Wed, 01 Jun 2011 12:11:10 +0200
From: Helge Hafting <helge.hafting@hist.no>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110510 Icedove/3.1.10
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [2.6.39] CIFS write failures where 2.6.38 works
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jun 2011 10:11:11.0012 (UTC) FILETIME=[3B355E40:01CC2044]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At work I use cifs for accessing a windows server. This has worked fine 
for a long time, up to and including Debian's 2.6.38-2.

I just installed Debians's 2.6.39-1, and had to give up on it.
Mounting CIFS works, and I can see the files. But if I
try to make a new file (with cp), I get a long delay.

In this time, anything accessing CIFS will pause, including "ls".
CIFS eventually becomes unstuck, and I will find that my "ls" succeeded, 
but the file copy did not. The file was created, but
with 0 size.

Trying to copy the file again results in another stall, and so on.


When I mount CIFS, I get this message:
CIFS VFS: Unexpected SMB signature

This happens with 2.6.38 as well as 2.6.39.

When writes fail in 2.6.39, I also get:
CIFS VFS: Send error in Close = -512

Followed by:
CIFS VFS: Server servername has not responded in 300 seconds. 
Reconnecting...

I have also seen
CIFS VFS: Send error in Close = -512
and
CIFS VFS: Send error in read = -13

Helge Hafting
