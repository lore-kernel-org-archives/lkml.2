Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab0ESCF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 22:05:26 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55316 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab0ESCFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 22:05:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0/4 v4] ext3/4: enhance fsync performance when using CFQ
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, jens.axboe@oracle.com, vgoyal@redhat.com
In-Reply-To: <1274206820-17071-1-git-send-email-jmoyer@redhat.com>
References: <1274206820-17071-1-git-send-email-jmoyer@redhat.com>
Message-Id: <20100519105706.8821.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 19 May 2010 11:05:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

> This patch series addresses a performance problem experienced when running
> io_zone with small file sizes (from 4KB up to 8MB) and including fsync in
> the timings.  A good example of this would be the following command line:
>   iozone -s 64 -e -f /mnt/test/iozone.0 -i 0
> As the file sizes get larger, the performance improves.  By the time the
> file size is 16MB, there is no difference in performance between runs
> using CFQ and runs using deadline.  The storage in my testing was a NetApp
> array connected via a single fibre channel link.  When testing against a
> single SATA disk, the performance difference is not apparent.

offtopic:

Can this patch help to reduce a pain of following much small files issue?

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=578635

Now, userland folks think sync() is faster than fsync() on ext4. I don't 
hope spread this unrecommended habit widely.



