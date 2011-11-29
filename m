Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab1K2NgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 08:36:18 -0500
Received: from mx2.netapp.com ([216.240.18.37]:61077 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419Ab1K2NgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 08:36:15 -0500
X-IronPort-AV: E=Sophos;i="4.69,591,1315206000"; 
   d="scan'208";a="603025663"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH 4/5] NFS: remove RPC PipeFS mount point reference from blocklayout routines
Date: Tue, 29 Nov 2011 05:35:51 -0800
Message-ID: <2E1EB2CF9ED1CB4AA966F0EB76EAB4430C3CBC23@SACMVEXC2-PRD.hq.netapp.com>
In-Reply-To: <F19688880B763E40B28B2B462677FBF805E3A4AFFD@MX09A.corp.emc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 4/5] NFS: remove RPC PipeFS mount point reference from blocklayout routines
Thread-Index: AcyukY9ts3BtGyv/REqRoBBt3RXgUwAAFmgQAAJnQJA=
References: <20111129090754.20730.64567.stgit@localhost6.localdomain6> <20111129091037.20730.59391.stgit@localhost6.localdomain6> <F19688880B763E40B28B2B462677FBF805E3A4AFF2@MX09A.corp.emc.com> <4ED4CDCE.9080804@parallels.com> <F19688880B763E40B28B2B462677FBF805E3A4AFFD@MX09A.corp.emc.com>
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: <tao.peng@emc.com>, <skinsbursky@parallels.com>
Cc: <linux-nfs@vger.kernel.org>, <xemul@parallels.com>, <neilb@suse.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jbottomley@parallels.com>, <bfields@fieldses.org>,
        <davem@davemloft.net>, <devel@openvz.org>
X-OriginalArrivalTime: 29 Nov 2011 13:35:52.0636 (UTC) FILETIME=[D06537C0:01CCAE9B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pATDaXsI008103

> -----Original Message-----
> From: tao.peng@emc.com [mailto:tao.peng@emc.com]
> Sent: Tuesday, November 29, 2011 7:40 AM
> To: skinsbursky@parallels.com
> Cc: Myklebust, Trond; linux-nfs@vger.kernel.org; xemul@parallels.com;
> neilb@suse.de; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> jbottomley@parallels.com; bfields@fieldses.org; davem@davemloft.net;
> devel@openvz.org
> Subject: RE: [PATCH 4/5] NFS: remove RPC PipeFS mount point reference
> from blocklayout routines
> 
> > -----Original Message-----
> > From: Stanislav Kinsbursky [mailto:skinsbursky@parallels.com]
> > Sent: Tuesday, November 29, 2011 8:19 PM
> > To: Peng, Tao
> > Cc: Trond.Myklebust@netapp.com; linux-nfs@vger.kernel.org; Pavel
> > Emelianov; neilb@suse.de; netdev@vger.kernel.org;
> > linux-kernel@vger.kernel.org; James Bottomley; bfields@fieldses.org;
> > davem@davemloft.net; devel@openvz.org
> > Subject: Re: [PATCH 4/5] NFS: remove RPC PipeFS mount point reference
> > from blocklayout routines
> >
> > 29.11.2011 16:00, tao.peng@emc.com Ğ¿Ğ¸ÑˆĞµÑ‚:
> > >> -----Original Message-----
> > >> From: linux-nfs-owner@vger.kernel.org
> > >> [mailto:linux-nfs-owner@vger.kernel.org] On Behalf Of
> > Stanislav
> > >> Kinsbursky
> > >> Sent: Tuesday, November 29, 2011 6:11 PM
> > >> To: Trond.Myklebust@netapp.com
> > >> Cc: linux-nfs@vger.kernel.org; xemul@parallels.com; neilb@suse.de;
> > >> netdev@vger.kernel.org; linux- kernel@vger.kernel.org;
> > >> jbottomley@parallels.com; bfields@fieldses.org;
> > >> davem@davemloft.net; devel@openvz.org
> > >> Subject: [PATCH 4/5] NFS: remove RPC PipeFS mount point reference
> > >> from blocklayout routines
> > >>
> > >> This is a cleanup patch. We don't need this reference anymore,
> > >> because blocklayout pipes dentries now creates and destroys in
> > >> per-net operations and on PipeFS mount/umount notification.
> > >> Note that nfs4blocklayout_register_net() now returns 0 instead of
> > >> -ENOENT in case of PipeFS superblock absence. This is ok, because
> > >> blocklayout pipe dentry will be created on PipeFS mount event.
> > > When is the "pipefs mount event" going to happen? When inserting
> > > kernel modules or when user issues
> > mount command?
> > >
> >
> > When user issues mount command.
> > Kernel mounts of PipeFS has been removed with all these patch sets
> > I've sent already.
> Then it is going to break blocklayout user space program blkmapd, which is
> stared before mounting any file system and it tries to open the pipe file
> when started.

Why on earth is blkmapd doing this instead of listening for file creation notifications like the other rpc_pipefs daemons do?

Trond

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
