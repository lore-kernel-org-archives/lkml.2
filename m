Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab1EYTQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:16:47 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:59553 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753516Ab1EYTQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:16:46 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Tejun Heo <tj@kernel.org>
Subject: [bisected] 2.6.39 breaks floppy
Date: Wed, 25 May 2011 21:16:36 +0200
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 985
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105252116.37839.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
floppy stopped working in 2.6.39 (confirmed on two machines). 2.6.38 worked 
fine. 
/dev/fd0 is created but does not work (mdir says: "No such device or address", 
mount says "/dev/fd0 is not a valid block device"). dmesg shows no errors:

Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077

Bisected it to 9fd097b14918875bd6f125ed699d7bbbba5893ee
(block: unexport DISK_EVENT_MEDIA_CHANGE for legacy/fringe drivers)

Adding the removed line back to floppy.c fixes the problem.

-- 
Ondrej Zary
