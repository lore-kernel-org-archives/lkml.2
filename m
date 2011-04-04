Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab1DDS1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 14:27:41 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54642 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab1DDS1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 14:27:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=qZ7XfEnttVtUG36ivfHMaBulG1jL61Mq8uPEj7k0qvX4R3NZX47Pqjmny4CxRDu+jG
         acY0kJhmaXEjLZG/awA5qUI9j5pJaGYX3d/vLjOaZb9zb2jECh4lVj7Jl+INLy/gzeDB
         cRYRaBUFDhmaGqzDxJPMQoxUV1dVYNc6v1dNY=
Message-ID: <4D9A0D97.1060505@lwfinger.net>
Date: Mon, 04 Apr 2011 13:27:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>
Subject: Regression in 2.6.39-rc1 from commit 7eaceaccab5f40bbfda044629a6298616aeaed50
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After I pulled 2.6.39-rc1, my HP laptop failed to boot by never advancing past 
the device detection stage on my x86_64 system. The problem was bisected, which 
led to:

7eaceaccab5f40bbfda044629a6298616aeaed50 is the first bad commit
commit 7eaceaccab5f40bbfda044629a6298616aeaed50
Author: Jens Axboe <jaxboe@fusionio.com>
Date:   Thu Mar 10 08:52:07 2011 +0100

     block: remove per-queue plugging

     Code has been converted over to the new explicit on-stack plugging,
     and delay users have been converted to use the new API for that.
     So lets kill off the old plugging along with aops->sync_page().

     Signed-off-by: Jens Axboe <jaxboe@fusionio.com>

As this patch cannot be reversed on current 2.6.39-rc1-git, I have not been able 
to do the final test of reverting it, but the bisection was straight forward.

When the system hangs, I can get it to finish booting if I type CTRL/C; however, 
the only disk partition that has been mounted is /. If it matters, I use a 
mixture of ext3 and ext4 file systems.

My disk controller is "nVidia Corporation MCP67 IDE Controller [10de:0560] (rev a1)"

Please let me know what additional info is needed.

Larry
