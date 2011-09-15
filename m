Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933905Ab1IOOsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 10:48:03 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:48026 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933801Ab1IOOsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 10:48:01 -0400
Date: Thu, 15 Sep 2011 09:47:55 -0500
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Stalls during writeback for mmaped I/O on XFS in 3.0
Message-ID: <20110915144755.GB2235@BohrerMBP.rgmadvisors.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a workload that is latency sensitive that writes data to a
memory mapped file on XFS.  With the 3.0 kernel I'm seeing stalls of
up to 100ms that occur during writeback that we did not see with older
kernels.  I've traced the stalls and it looks like they are blocking
on wait_on_page_writeback() introduced in
d76ee18a8551e33ad7dbd55cac38bc7b094f3abb "fs: block_page_mkwrite
should wait for writeback to finish"

Reading the commit description doesn't really explain to me why this
change was needed.  Can someone explain what "This is needed to
stabilize pages during writeback for those two filesystems." means in
the context of that commit?  Is this a problem for older kernels as
well?  Should this have been backported to the stable kernels? What
are the downsides of reverting this commit?

Assuming this change is required are there any alternatives solutions
to avoid these stalls with mmaped I/O on XFS?

Thanks,
Shawn


---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

