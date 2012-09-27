Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab2I0QQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 12:16:30 -0400
Received: from mx2.netapp.com ([216.240.18.37]:45654 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab2I0QQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 12:16:29 -0400
X-IronPort-AV: E=Sophos;i="4.80,496,1344236400"; 
   d="scan'208";a="694885684"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Joerg Roedel <joro@8bytes.org>
CC: Joerg Roedel <joerg.roedel@amd.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Subject: Re: kernel BUG at /data/lemmy/linux.trees.git/fs/nfs/idmap.c:681!
Thread-Topic: kernel BUG at /data/lemmy/linux.trees.git/fs/nfs/idmap.c:681!
Thread-Index: AQHNdKJvypEw9t3CEUmeaLKAlM+spZefC3UA//+TOzCAAHnyAIAACk6A
Date: Thu, 27 Sep 2012 16:16:25 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA908FEF7A3@SACEXCMBX04-PRD.hq.netapp.com>
References: <20120807134156.GP1996@amd.com>
	 <20120927145217.GA18962@8bytes.org>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA908FEF572@SACEXCMBX04-PRD.hq.netapp.com>
	 <20120927153928.GB18962@8bytes.org>
In-Reply-To: <20120927153928.GB18962@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <FBA65B587F72984AB9A298AA92156A9F@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8RGGcdB005906

On Thu, 2012-09-27 at 17:39 +0200, Joerg Roedel wrote:
> On Thu, Sep 27, 2012 at 03:32:02PM +0000, Myklebust, Trond wrote:
> 
> > Does your checked out copy of 3.6-rc7 contain commit c50669 (NFS:
> > Clear key construction data if the idmap upcall fails)? The latter was
> > merged in3.6-rc3, and is reported to fix the problem for the other
> > testers.
> 
> Yes, it contains that commit. I was about to test plain v3.6-rc7 without
> my patches (not nfs related, of cource) on-top, but unfortunatly the
> disk with the root-fs died :-/
> I am about to set up the box again and test plain -rc7.

Please do.

I cannot see how that BUG_ON can be triggered in the current code, given
that the only place where idmap->idmap_key_cons is set to a non-NULL
value is covered by a mutex, and that it is always cleared before we
release said mutex.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
