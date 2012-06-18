Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab2FRN3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 09:29:10 -0400
Received: from mx2.netapp.com ([216.240.18.37]:52214 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab2FRN3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 09:29:05 -0400
X-IronPort-AV: E=Sophos;i="4.75,792,1330934400"; 
   d="scan'208";a="656149459"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Andre Tomt <andre@tomt.net>
CC: "Schumaker, Bryan" <Bryan.Schumaker@netapp.com>,
        Linux-NFS <linux-nfs@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "David Howells" <dhowells@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG in __key_instantiate_and_link(): unable to handle kernel
 paging request at 0000632e6472616f
Thread-Topic: BUG in __key_instantiate_and_link(): unable to handle kernel
 paging request at 0000632e6472616f
Thread-Index: AQHNS/p/aXpJonDub0C7d6ldaTsTCpcAQEAAgABJuIA=
Date: Mon, 18 Jun 2012 13:28:49 +0000
Message-ID: <1340026127.2451.7.camel@lade.trondhjem.org>
References: <20120601034114.GA9248@localhost> <4FDBF056.7040404@tomt.net>
	  <4FDCD3C7.5080503@tomt.net> <1339876739.8267.96.camel@lade.trondhjem.org>
	 <4FDEEF38.8030101@tomt.net>
In-Reply-To: <4FDEEF38.8030101@tomt.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <407EA407D9A78B48BCF44E8F9F2BE56D@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5IDTIuG021505

On Mon, 2012-06-18 at 11:04 +0200, Andre Tomt wrote:
> On 16. juni 2012 21:59, Myklebust, Trond wrote:
> > It looks to me as if the legacy upcall code is assuming that there can
> > be no more than 1 upcall at a time: there is only a single
> > idmap->idmap_key_cons, which gets assigned in nfs_idmap_legacy_upcall
> > and then read in idmap_pipe_downcall.
> >
> > Bryan, can you look into this? I suspect that we need a mutex or
> > something like that (for the legacy upcall case only) to ensure that
> > nobody overwrites the idmap->idmap_key_cons while an upcall is in
> > progress.
> >
> > Andre, if you want idmapper scalability, then you should rather use the
> > new idmapper upcall. You need a recent version of the nfs-utils package,
> > the keyutils package, and they you should add an 'id_resolver' line
> > to /etc/request-keys.conf as per the nfsidmap manpage.
> 
> Indeed, using keyutils did avoid the crashes here, 40 hours and counting.
> 
> Are there any downsides of having keyutils w/ id_resolver on by default 
> in a distribution? Would it break older kernels or nfs-utils (just not 
> getting used is fine, obviously)?

Older kernels aren't able to use the keyutils mechanism, so they will
still require you to run the idmapd daemon, but there should be no
problems with just enabling it in /etc/request-key.conf.
Fedora 17 is supposed to install the id_resolver by default.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
