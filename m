Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab2HGPTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:19:06 -0400
Received: from mx2.netapp.com ([216.240.18.37]:10833 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab2HGPTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:19:03 -0400
X-IronPort-AV: E=Sophos;i="4.77,727,1336374000"; 
   d="scan'208";a="674180207"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Joerg Roedel <joro@8bytes.org>
CC: "Schumaker, Bryan" <Bryan.Schumaker@netapp.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wdauchy@gmail.com" <wdauchy@gmail.com>
Subject: Re: kernel BUG at /data/lemmy/linux.trees.git/fs/nfs/idmap.c:681!
Thread-Topic: kernel BUG at /data/lemmy/linux.trees.git/fs/nfs/idmap.c:681!
Thread-Index: AQHNdKJvypEw9t3CEUmeaLKAlM+spZdO1J0AgAAFvwCAAAB9gIAAAqyAgAACoYCAAAPbgIAACAKA
Date: Tue, 7 Aug 2012 15:19:01 +0000
Message-ID: <1344352739.5781.12.camel@lade.trondhjem.org>
References: <20120807134156.GP1996@amd.com> <50211E42.6040808@netapp.com>
	 <20120807141548.GG1917@8bytes.org> <5021237D.1010107@netapp.com>
	 <20120807142707.GH1917@8bytes.org> <502127EF.3030209@netapp.com>
	 <20120807145019.GI1917@8bytes.org>
In-Reply-To: <20120807145019.GI1917@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BC22A37BC469E44E8CF8A540CBFD102F@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q77FJAmL012971

On Tue, 2012-08-07 at 16:50 +0200, Joerg Roedel wrote:
> On Tue, Aug 07, 2012 at 10:36:31AM -0400, Bryan Schumaker wrote:
> > Your stack trace is showing v4 calls on the failing box, those
> > definitely shouldn't be happening if you're using v3.  Can you double
> > check /etc/fstab and /proc/mounts on a working kernel to be sure?
> 
> So the bug is probably (for whatever reason) that the nfs4 path is
> called for an nfs3 mount :)

If your /etc/nfsmount.conf doesn't contain a line of the form

Defaultvers=4

then the mount utility will try NFSv4 by default. That is not a bug, it
is a deliberate feature of recent versions of nfs-utils.

> Anyway, I attach /proc/mounts and /etc/fstab from that box running a
> v3.5-rc5 kernel (where it works).

I'm guessing that the fact you are not running idmapper is causing the
NFSv4 mount to fail on the older kernels, and so the mount program is
falling back to an NFSv3 mount.

We need to fix v3.6 so that it does the same.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
