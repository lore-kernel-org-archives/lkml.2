Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab2FLX2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 19:28:16 -0400
Received: from mx2.netapp.com ([216.240.18.37]:53916 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab2FLX2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 19:28:14 -0400
X-IronPort-AV: E=Sophos;i="4.75,761,1330934400"; 
   d="scan'208";a="655024640"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Mark Lord <kernel@teksavvy.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "davej@redhat.com" <davej@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: mount.nfs: cannot allocate memory
Thread-Topic: mount.nfs: cannot allocate memory
Thread-Index: AQHNSO3PUW39M+F5kUCViXnMQsENJJb3wUCAgAACygCAAAVcgA==
Date: Tue, 12 Jun 2012 23:28:08 +0000
Message-ID: <1339543659.27036.2.camel@lade.trondhjem.org>
References: <4FD7C65F.80602@teksavvy.com> <4FD7C7C6.9030204@teksavvy.com>
	 <4FD7C995.8040402@teksavvy.com> <4FD7CBEC.1020901@teksavvy.com>
In-Reply-To: <4FD7CBEC.1020901@teksavvy.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CF822759BE84F04799CC494A102450C6@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5CNSTIN020904

On Tue, 2012-06-12 at 19:08 -0400, Mark Lord wrote:
> On 12-06-12 06:58 PM, Mark Lord wrote:
> > Adding Ben Hutchings to CC: as he seems to have looked into this before.
> > 
> >> On 12-06-12 06:44 PM, Mark Lord wrote:
> >>> I've been seeing these messages on my AMD Fusion server
> >>> running linux-3.3.7-64bit.  Does this ring any bells for anyone else?
> >>> The system is NOT low on memory.
> >>>
> >>> I'm building/installing 3.4.2 now to see if it behaves any better.
> >>>
> >>> [962841.265658] mount.nfs: page allocation failure: order:4, mode:0xc0d0
> >>> [962841.265674] Pid: 32116, comm: mount.nfs Not tainted 3.3.7 #2
> >>> [962841.265680] Call Trace:
> >>> [962841.265700]  [<ffffffff81079363>] ? warn_alloc_failed+0x11a/0x12d
> >>> [962841.265713]  [<ffffffff8107b904>] ? __alloc_pages_nodemask+0x6c0/0x702
> >>> [962841.265725]  [<ffffffff8114fcb8>] ? timerqueue_del+0x53/0x63
> >>> [962841.265758]  [<ffffffff8107b9ba>] ? __get_free_pages+0x10/0x3f
> >>> [962841.265805]  [<ffffffffa01ea33d>] ? nfs_idmap_new+0x28/0xde [nfs]
> >>> [962841.265836]  [<ffffffffa01c79c9>] ? nfs4_init_client+0x74/0x12a [nfs]
> ...
> >> Looks like an old bug, perhaps:
> >> https://bugzilla.redhat.com/show_bug.cgi?id=593035
> >> https://bugzilla.redhat.com/show_bug.cgi?id=728003
> >>
> >> I wonder what the underlying cause is?
> >> And I also wonder if the NFS code should be more clever
> >> about handing order-4 allocation failures.
> > 
> > More references:
> > http://www.mail-archive.com/debian-kernel@lists.debian.org/msg71281.html
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1004619
> > http://codemonkey.org.uk/2012/02/17/fedora-16-kernel-bugzilla-status-report-20120210-20120217/
> > https://lkml.org/lkml/2011/2/24/73
> 
> Ahh.. this one seems to explain it, kind of:
>    http://permalink.gmane.org/gmane.linux.nfs/41686
> 
> So in 3.3.7, I didn't have CONFIG_NFS_USE_NEW_IDMAPPER enabled,
> and the kernel seems to be buggy without that.
> 
> In 3.4.2, that option has disappeared entirely,
> most likely because it is now the default behaviour.  Right?

Yes, but we also added some patches to Linux 3.4 in order to fix this
bug.

Please see commit d073e9b541e1ac3f52d72c3a153855d9a9ee3278 (NFSv4:
Reduce the footprint of the idmapper) and commit
685f50f9188ac1e8244d0340a9d6ea36b6136cec (NFSv4: Further reduce the
footprint of the idmapper)

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
