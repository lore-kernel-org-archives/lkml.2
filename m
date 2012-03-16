Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161908Ab2CPA7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 20:59:13 -0400
Received: from mx2.netapp.com ([216.240.18.37]:27557 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161704Ab2CPA7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 20:59:11 -0400
X-IronPort-AV: E=Sophos;i="4.73,594,1325491200"; 
   d="scan'208";a="633848308"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Vivek Trivedi <vtrivedi018@gmail.com>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH 1/1] NFS: fix sb->s_id in nfs debug prints
Thread-Topic: [PATCH 1/1] NFS: fix sb->s_id in nfs debug prints
Thread-Index: AQHNAtmSxlVRa1HgT0Cu5jGNB21JkJZsj6KA
Date: Fri, 16 Mar 2012 00:59:10 +0000
Message-ID: <1331859549.25523.5.camel@lade.trondhjem.org>
References: <1331836132-2053-1-git-send-email-vtrivedi018@gmail.com>
In-Reply-To: <1331836132-2053-1-git-send-email-vtrivedi018@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B5955AB929BF84B825E1FC35332D7BD@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2G0xLh3007856

On Thu, 2012-03-15 at 23:58 +0530, Vivek Trivedi wrote:
> NFS bdi flush thread in ps output is printed like "flush-<major number
> in decimal>:<minor number in decimal>"
> For example:
> $ ps aux | grep flush
>  2079 root         0 SW   [flush-0:18]
>                                  ^^^^
> 
> nfs_bdi_register()
> ==> bdi_register_dev()
> ==> bdi_register(bdi, NULL, "%u:%u", MAJOR(dev), MINOR(dev));
>                              ^^^^^
> 
> However, NFS sb->s_id store major:minor number in hex:
> 
> nfs_initialise_sb()
> ==>         snprintf(sb->s_id, sizeof(sb->s_id),
>                  "%x:%x", MAJOR(sb->s_dev), MINOR(sb->s_dev));
>                   ^^^^^
> 
> If we enable nfs debug prints using command:
> $ rpcdebug -m nfs -s all
> 
> write to a file:
> $ dd if=/dev/zero of=<NFS Mount>/testfile.txt bs=32768 count=1
> 
> Without Patch:
> [ 2431.032000] NFS:     0 initiated write call (req 0:12/40, 32768 bytes
> @ offset 0)                                         ^^^^
> 
> With Patch:
> [ 2431.032000] NFS:     0 initiated write call (req 0:18/40, 32768 bytes
> @ offset 0)                                         ^^^^
> 
> We should store NFS "s->s_id" in decimal to avoid confusion between NFS
> flush thread name(in ps output) and NFS debug prints.

Why do we care? The s_id is entirely filesystem-specific so it shouldn't
be compared to the properties of VFS objects anyway.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
