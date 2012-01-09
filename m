Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab2AIW3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:29:07 -0500
Received: from mx2.netapp.com ([216.240.18.37]:45749 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab2AIW3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:29:05 -0500
X-IronPort-AV: E=Sophos;i="4.71,482,1320652800"; 
   d="scan'208";a="615020336"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [GIT PULL] Please pull NFS client bugfixes and cleanups
Date: Mon, 9 Jan 2012 14:28:48 -0800
Message-ID: <2E1EB2CF9ED1CB4AA966F0EB76EAB4430CCB08B1@SACMVEXC2-PRD.hq.netapp.com>
In-Reply-To: <201201092315.28230.wolfgang.walter@stwm.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [GIT PULL] Please pull NFS client bugfixes and cleanups
Thread-Index: AczPHEVakG1ZAGnsRhWEXt2sFGS36AAABGgw
References: <1326142671.9041.1.camel@lade.trondhjem.org> <201201092315.28230.wolfgang.walter@stwm.de>
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "Wolfgang Walter" <wolfgang.walter@stwm.de>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
        <linux-nfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 09 Jan 2012 22:28:49.0571 (UTC) FILETIME=[0F120730:01CCCF1E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q09MTGhx007299

> -----Original Message-----
> From: Wolfgang Walter [mailto:wolfgang.walter@stwm.de]
> Sent: Monday, January 09, 2012 5:15 PM
> To: Myklebust, Trond
> Cc: Linus Torvalds; linux-nfs@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [GIT PULL] Please pull NFS client bugfixes and cleanups
> 
> On Monday 09 January 2012, Trond Myklebust wrote:
> > Hi Linus,
> >
> > Please pull from the "nfs-for-3.3" branch of the repository at
> >
> >    git pull git://git.linux-nfs.org/projects/trondmy/linux-nfs.git
> > nfs-
> for-3.3
> >
> > This will update the following files through the appended changesets.
> >
> >   Cheers,
> >     Trond
> >
> >
> > commit 074b1d12fe2500d7d453902f9266e6674b30d84c
> > Author: Trond Myklebust <Trond.Myklebust@netapp.com>
> > Date:   Mon Jan 9 13:46:26 2012 -0500
> >
> >     NFSv4: Change the default setting of the nfs4_disable_idmapping
> parameter
> >
> >     Now that the use of numeric uids/gids is officially sanctioned in
> >     RFC3530bis, it is time to change the default here to 'enabled'.
> >
> >     By doing so, we ensure that NFSv4 copies the behaviour of NFSv3
> > when
> we're
> >     using the default AUTH_SYS authentication (i.e. when the client uses the
> >     numeric uids/gids as authentication tokens), so that when new files are
> >     created, they will appear to have the correct user/group.
> >     It also fixes a number of backward compatibility issues when migrating
> >     from NFSv3 to NFSv4 on a platform where the server uses different
> uid/gid
> >     mappings than the client.
> >
> >     Note also that this setting has been successfully tested against servers
> >     that do not support numeric uids/gids at several
> Connectathon/Bakeathon
> >     events at this point, and the fall back to using string names/groups has
> >     been shown to work well in all those test cases.
> >
> >     Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> >
> 
> 
> Does this mean that one has to modify all one's clients to get the old
> behaviour?
> 
> I'm not sure if this is a really good idea. I don't see the advantage. This will
> break a lot of existing installations when upgrading to >=3.3. And someone
> migrating from NFSv3 to NFSv4 has to give some thoughts to it anyway.

Please read the changelog and documentation:

If your server doesnâ€™t support numeric uids/gids, then you will see _no_ change in behaviour.

If your server does support numeric uids/gids, and has the same mapping between numeric uids/gids and username/groupname as your clients, then you will see _no_ change in behaviour.

If your server does support numeric uids/gids, but the mapping between numeric uids/gids and username/groupname differs between server and client (e.g.. uid=20 maps to different users on the client and server) then you already had a problem in that creating the file using NFSv4 would result in you seeing the wrong owner and/or group. If this case, and this case only, the change to nfs4_disable_idmapper will result in you now seeing the correct owner/group for these files (just as if you were using NFSv3).

IOW: the only people who will want to use the old setting are those with broken servers that return incorrect errors when confronted with a numeric uid/gid. We have found no evidence that any such servers exist during the last full year of testing.

Trond
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
