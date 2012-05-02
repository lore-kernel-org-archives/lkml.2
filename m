Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab2EBXad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 19:30:33 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:51125 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab2EBXac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 19:30:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-209.messagelabs.com!1336001429!4630894!7
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Question: Section mismatch warnings in drivers/net
Date: Wed, 2 May 2012 16:30:25 -0700
User-Agent: KMail/1.9.9
CC: <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201205021630.25233.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I noticed a number of section mismatch warnings in various
drivers/net/ drivers. I was going to submit some patches to
clean them up but then saw these commits:

commit 948252cb9e01d65a89ecadf67be5018351eee15e
Author: David S. Miller <davem@davemloft.net>
Date:   Tue May 31 19:27:48 2011 -0700

    Revert "net: fix section mismatches"
    
    This reverts commit e5cb966c0838e4da43a3b0751bdcac7fe719f7b4.
    
    It causes new build regressions with gcc-4.2 which is
    pretty common on non-x86 platforms.
    
    Reported-by: James Bottomley <James.Bottomley@HansenPartnership.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit e5cb966c0838e4da43a3b0751bdcac7fe719f7b4
Author: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Date:   Mon Apr 18 13:31:20 2011 +0000

    net: fix section mismatches
    
    Fix build warnings like the following:
    
    WARNING: drivers/net/built-in.o(.data+0x12434): Section mismatch in reference from the variable madge
    
    And add some consts to EISA device ID tables along the way.
    
    Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
    Signed-off-by: David S. Miller <davem@davemloft.net>

Was the issue with the build regressions ever worked out? Would
patches to fix the section mismatches be appropriate now?

Regards,
Hartley
