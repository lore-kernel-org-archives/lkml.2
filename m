Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab2DQOEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:04:38 -0400
Received: from mx2.netapp.com ([216.240.18.37]:8597 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605Ab2DQOEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:04:36 -0400
X-IronPort-AV: E=Sophos;i="4.75,434,1330934400"; 
   d="scan'208";a="641523404"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Jeff Layton <jlayton@redhat.com>
CC: Miklos Szeredi <miklos@szeredi.hu>,
        Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        Malahal Naineni <malahal@us.ibm.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pstaubach@exagrid.com" <pstaubach@exagrid.com>,
        "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "hch@infradead.org" <hch@infradead.org>,
        "michael.brantley@deshaw.com" <michael.brantley@deshaw.com>,
        "sven.breuner@itwm.fraunhofer.de" <sven.breuner@itwm.fraunhofer.de>
Subject: Re: [PATCH RFC] vfs: make fstatat retry on ESTALE errors from
 getattr call
Thread-Topic: [PATCH RFC] vfs: make fstatat retry on ESTALE errors from
 getattr call
Thread-Index: AQHNHJu4WFyXQNvYykq9RVAgdBQu35afeSoAgAAI/oA=
Date: Tue, 17 Apr 2012 14:04:34 +0000
Message-ID: <1334671473.2963.27.camel@lade.trondhjem.org.localdomain>
References: <1334316311-22331-1-git-send-email-jlayton@redhat.com>
	 <20120413150518.GA1987@us.ibm.com>
	 <20120413114236.0e557e01@tlielax.poochiereds.net>
	 <4F8B1B7B.3040304@itwm.fraunhofer.de>
	 <20120416073655.7cdb90cf@corrin.poochiereds.net>
	 <4F8C3036.2030702@itwm.fraunhofer.de>
	 <20120416134642.1754cd3e@corrin.poochiereds.net>
	 <1334604785.2879.23.camel@lade.trondhjem.org>
	 <20120416154322.0d95e435@corrin.poochiereds.net>
	 <1334607906.2879.36.camel@lade.trondhjem.org>
	 <20120416190548.2463d1d0@corrin.poochiereds.net>
	 <87sjg2o62z.fsf@tucsk.pomaz.szeredi.hu>
	 <20120417093222.2ff5e1bd@corrin.poochiereds.net>
In-Reply-To: <20120417093222.2ff5e1bd@corrin.poochiereds.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <841327280AE8DD469662F8BDEFDA69A8@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3HE4jRn010790

On Tue, 2012-04-17 at 09:32 -0400, Jeff Layton wrote:
> On Tue, 17 Apr 2012 15:12:20 +0200
> Miklos Szeredi <miklos@szeredi.hu> wrote:

> To do that would require protocol support that we simply don't have. We
> don't have a way to (for instance) say via NFS "give me the attributes
> for this filename". Well, at least not for NFSv3...

What's wrong with LOOKUP?

> With v4 you could theoretically construct a compound that does that,
> but you'd have to assume that the server won't release the reference to
> the inode midway through the compound. That's a reasonably safe
> assumption.

Actually, NFSv4 is the one that has the problem: there are no atomicity
guarantees within compounds, so you could theoretically get an ESTALE in
the GETATTR part of our lookup compound.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
