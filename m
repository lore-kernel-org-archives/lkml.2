Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987Ab1ENDDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 23:03:04 -0400
Received: from nm9.bullet.mail.bf1.yahoo.com ([98.139.212.168]:39426 "HELO
	nm9.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757248Ab1ENDDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 23:03:03 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 May 2011 23:03:03 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 995091.64082.bm@omp1050.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=oVG+nQzTs+BaDPrHW3Mmz2Fgpe2CPwZz/CHj0MZTgIIkzspGYAKGsTnHM3y18cxpmdwBhF6YNFaLobN1MpxEDgnK9LVZqWd+nTEWGfCm6orGPRmAbWdwKi06U2Srb1BCXhAfLEWvthXNDPqPimc0GI0yPnyA4+j4NxzZpwHK0f4=;
Message-ID: <367853.39582.qm@web130121.mail.mud.yahoo.com>
X-YMail-OSG: yu8qs.MVM1kcn5wlB0dGvxKdPuNtd3o8BrkZha5WFR1w_wX
 GGT0twhx4WfTa2olAL_4CfoxoDGCeQiZkR9tyc9btUXGpYkjbz2in7VrizEC
 5vIWCtDgl362RLwMN4Ttp8MC9j85xbDYxqbjZixiwq1oAfQvmmOYe4GeBrP7
 Jjs78GPQrXJRsPSvvObAePaXDzLXM9Jm1EsZ.5eEgtPi24tq2RBILRQ464dA
 K6o6ZQFVRfUjzaPLiJ4M4LRxQA2IbK8LxV.decEhBjoLsyGOVBGXbDdUtRQQ
 43NH1RlDR3AYH_DrYiXYPHCGRvptr.zSBiNuFIlE1joV.tmChedLbZUjo2qX
 LRsXGrbIj27ERMHCIGw7S.syjUb2OHqpQuxpa3jcA2sPkUEs93bI7DUz.PJE
 NtVVfLZQ2IGrq
X-Mailer: YahooMailClassic/14.0.1 YahooMailWebService/0.8.111.303096
Date: Fri, 13 May 2011 19:57:20 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Subject: Possible coding issue in udf??
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fs/udf/inode.c, line 1455, linux 2.6.35, there is the following code:

	udfperms = ((inode->i_mode & S_IRWXO)) |
		   ((inode->i_mode & S_IRWXG) << 2) |
		   ((inode->i_mode & S_IRWXU) << 4);

Shouldn't we be shifting by 3 bits? i.e:
	udfperms = ((inode->i_mode & S_IRWXO)) |
		   ((inode->i_mode & S_IRWXG) << 3) |
		   ((inode->i_mode & S_IRWXU) << 6);

The S_I.. constants are all defined in include/linux/stat.h as 3-bit values.

I will send a patch if needed.

I code, therefore I am
