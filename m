Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab2FRNmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 09:42:40 -0400
Received: from mx2.netapp.com ([216.240.18.37]:43415 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab2FRNmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 09:42:39 -0400
X-IronPort-AV: E=Sophos;i="4.75,792,1330934400"; 
   d="scan'208";a="656153709"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: nfs3 problem with -rc{2,3}
Thread-Topic: nfs3 problem with -rc{2,3}
Thread-Index: AQHNTMS9i2iatMLpKEGb4f4ZWuxoUpcAjD8A
Date: Mon, 18 Jun 2012 13:42:37 +0000
Message-ID: <1340026956.2451.9.camel@lade.trondhjem.org>
References: <20120617200700.GA15348@milliways>
In-Reply-To: <20120617200700.GA15348@milliways>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <64A534AB6975744885BC7124DF1B01CE@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5IDghGr021591

On Sun, 2012-06-17 at 21:07 +0100, Ken Moffat wrote:
> I'm seeing problems writing to shared directories mounted as nfs3.
> Wondering if anyone else is seeing similar problems ?
> 
>  I noticed this last week with -rc2 (my first new kernel since
> 3.4.0), but haven't managed to find a minimal test case to replicate
> it.
> 
>  The first problem was with firefox - I use it to download tarballs
> and patches to a shared /sources.  The first download worked, maybe
> also another, but some time later one stalled and firefox stopped
> refreshing its window.  Looked as if it successfully created
> packagename.tar.gz.part, but with an empty packagename.tar.gz.
> 
>  I killed firefox, then I used wget to download to a local filesystem
> and then tried to cp it to the shared /sources - cp hung indefinitely,
> apparently after completing the transfer.
> 
>  At this time I tried to run a script *in* /sources which hung
> trying to rm a file [ worked fine when I killed it, ssh'd to the
> server, and ran it locally ].
> 
>  I've also got regular backup scripts which wrap rsync writes to a
> different writable directory on the server.  These stall with -rc2
> and -rc3, and get killed by SIGINT when I eventually reboot or shut
> down.
> 
>  I tried using only the rsync command and playing with just an rsync
> of a single file in a directory, but that doesn't provoke the
> problem.  I've also tried various attempts to cp or move a file
> to the shared directory, but again without problems.  It seems that
> things are fine until something provokes the problem, then all
> updates stall.  This makes it a bit hard to get a reliable and
> simple testcase.
> 
>  I suppose I'll have to start to bisect using the backup script as
> my test case (booted rc2 earlier, did nothing except ssh and allow
> fcron to run it - it stalled.  built rc3, booted that, fcron tried
> to run the incomplete backup, again it has stalled).
> 
>  Config from rc2 attached, any suggestions are welcome.

Is this a problem with the client or with the server, and have you tried
seeing if the fixes that were merged into -rc3 help?

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
