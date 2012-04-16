Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab2DPTdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 15:33:24 -0400
Received: from mx2.netapp.com ([216.240.18.37]:3404 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab2DPTdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 15:33:22 -0400
X-IronPort-AV: E=Sophos;i="4.75,429,1330934400"; 
   d="scan'208";a="641363070"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Jeff Layton <jlayton@redhat.com>
CC: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        Malahal Naineni <malahal@us.ibm.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pstaubach@exagrid.com" <pstaubach@exagrid.com>,
        "miklos@szeredi.hu" <miklos@szeredi.hu>,
        "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "hch@infradead.org" <hch@infradead.org>,
        "michael.brantley@deshaw.com" <michael.brantley@deshaw.com>,
        "sven.breuner@itwm.fraunhofer.de" <sven.breuner@itwm.fraunhofer.de>
Subject: Re: [PATCH RFC] vfs: make fstatat retry on ESTALE errors from
 getattr call
Thread-Topic: [PATCH RFC] vfs: make fstatat retry on ESTALE errors from
 getattr call
Thread-Index: AQHNHAe/tG+9b6eY/E2HM6iNF4DgUg==
Date: Mon, 16 Apr 2012 19:33:05 +0000
Message-ID: <1334604785.2879.23.camel@lade.trondhjem.org>
References: <1334316311-22331-1-git-send-email-jlayton@redhat.com>
	 <20120413150518.GA1987@us.ibm.com>
	 <20120413114236.0e557e01@tlielax.poochiereds.net>
	 <4F8B1B7B.3040304@itwm.fraunhofer.de>
	 <20120416073655.7cdb90cf@corrin.poochiereds.net>
	 <4F8C3036.2030702@itwm.fraunhofer.de>
	 <20120416134642.1754cd3e@corrin.poochiereds.net>
In-Reply-To: <20120416134642.1754cd3e@corrin.poochiereds.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <488A94341602844AACDA23E99457839F@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3GJXbGB004962

On Mon, 2012-04-16 at 13:46 -0400, Jeff Layton wrote:
> The question about looping indefinitely really comes down to:
> 
> 1) is a persistent ESTALE in conjunction with a successful lookup a
> situation that we expect to be temporary. i.e. will the admin at some
> point be able to do something about it? If not, then there's no point
> in continuing to retry. Again, this is a situation that *really* should
> not happen if the filesystem is doing the right thing.
> 
> 2) If the admin can't do anything about it, is it reasonable to expect
> that users can send a fatal signal to hung applications if this
> situation occurs.
> 
> We expect that that's ok in other situations to resolve hung
> applications, so I'm not sure I understand why it wouldn't be
> acceptable here...

There are definitely potentially persistent pathological situations that
the filesystem can't do anything about. If the point of origin for your
pathname (for instance your current directory in the case of a relative
pathname) is stale, then no amount of looping is going to help you to
recover.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
