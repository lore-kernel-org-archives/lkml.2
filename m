Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab2DJGAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 02:00:42 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:53368 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab2DJGAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 02:00:40 -0400
Message-ID: <4F83CC86.2010805@msgid.tls.msk.ru>
Date: Tue, 10 Apr 2012 10:00:38 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Jan Kara <jack@suse.cz>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dramatic I/O slowdown after upgrading 2.6.38->3.0+
References: <4F75E46E.2000503@msgid.tls.msk.ru> <20120405232913.GA6640@quack.suse.cz> <4F7E74F4.90604@msgid.tls.msk.ru> <20120410022628.GN18323@dastard>
In-Reply-To: <20120410022628.GN18323@dastard>
X-Enigmail-Version: 1.3.4
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.04.2012 06:26, Dave Chinner wrote:

> Barriers. Turn them off, and see if that fixes your problem.

Thank you Dave for a hint.  And nope, that's not it, not at all... ;)
While turning off barriers helps a tiny bit, to gain a few %% from
the huge slowdown, it does not cure the issue.

Meanwhile, I observed the following:

1) the issue persists on more recent kernels too, I tried 3.3
   and it is also as slow as 3.0.

2) at least 2.6.38 kernel works fine, as fast as 2.6.32, I'll
   try 2.6.39 next.

   I updated $subject accordingly.

3) the most important thing I think: this is general I/O speed
   issue.  Here's why:

  2.6.38:
  # dd if=/dev/sdb of=/dev/null bs=1M iflag=direct count=100
  100+0 records in
  100+0 records out
  104857600 bytes (105 MB) copied, 1.73126 s, 60.6 MB/s

  3.0:
  # dd if=/dev/sdb of=/dev/null bs=1M iflag=direct count=100
  100+0 records in
  100+0 records out
  104857600 bytes (105 MB) copied, 29.4508 s, 3.6 MB/s

That's about 20 times difference on direct read from the
same - idle - device!!

Preparing for another bisect attempt, slowly.....

Thank you!

/mjt
