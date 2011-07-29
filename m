Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1G2QER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 12:04:17 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:40636 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191Ab1G2QEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 12:04:16 -0400
Date: Fri, 29 Jul 2011 12:04:16 -0400
To: linux-serial@vger.kernel.org
Cc: Len Sorensen <lsorense@csclub.uwaterloo.ca>, linux-kernel@vger.kernel.org,
        Breno Leitao <leitao@linux.vnet.ibm.com>
Subject: Very strange data loss with jsm driver
Message-ID: <20110729160416.GK8562@caffeine.csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I discovered a strange situation where the jsm driver discards the
majority of transmit data.

I have two text files.

The first file consists of 9100 lines of:
0123456789<newline>
Total 100100 bytes.

The second file consists of 100 lines of:
01234567890123456789.....0123456789<newline> (1000 character line)
Total 100100 bytes.

The first file transmits instantly, with the receiving end getting
approximately 100 bytes of the data.

The second file sends in about 1 minute and 40 seconds at 9600 baud
(the speed doesn't affect the behaviour in any noticeable way) as one
would expect, and the other end sees all the data.

The trigger point appears to be lines of up to 14 bytes, followed by
a newline.  With 15 bytes or more per line it seems to be OK.

Anyone got a clue?

I was testing on 3.0.0.  Same on 2.6.32.

3.0.0 unfortunately no longer has port statistics on the jsm driver in
/proc/tty/driver/jsm making it hard to see what the driver believes is
going on, it seems 2.6.37 broke that with some serial cleanup.
I am cleaning up a patch to fix that.

-- 
Len Sorensen
