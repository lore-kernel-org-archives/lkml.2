Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2DIQRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 12:17:45 -0400
Received: from mx2.netapp.com ([216.240.18.37]:31295 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756878Ab2DIQRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 12:17:43 -0400
X-IronPort-AV: E=Sophos;i="4.75,393,1330934400"; 
   d="scan'208";a="639512204"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "bfields@fieldses.org" <bfields@fieldses.org>
CC: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Jeff Layton <jlayton@redhat.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Grace period
Thread-Topic: Grace period
Thread-Index: AQHNFkNePLtNdDcBi0a9POplR1wLJZaS936AgAAKpACAABFIgIAAC4qAgAAAowCAAAGkAA==
Date: Mon, 9 Apr 2012 16:17:06 +0000
Message-ID: <1333988226.2688.76.camel@lade.trondhjem.org>
References: <4F7F230A.6080506@parallels.com>
	 <20120406234039.GA20940@fieldses.org> <4F82C6E3.3030009@parallels.com>
	 <20120409094743.56932677@tlielax.poochiereds.net>
	 <4F82F16C.7030303@parallels.com>
	 <20120409112739.6a823d6f@corrin.poochiereds.net>
	 <4F830999.5000504@parallels.com> <20120409161114.GB6482@fieldses.org>
In-Reply-To: <20120409161114.GB6482@fieldses.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B22B3F07D3044243803F735E3F772FCB@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q39GHpg9018568

On Mon, 2012-04-09 at 12:11 -0400, bfields@fieldses.org wrote:
> On Mon, Apr 09, 2012 at 08:08:57PM +0400, Stanislav Kinsbursky wrote:
> > 09.04.2012 19:27, Jeff Layton Ğ¿Ğ¸ÑˆĞµÑ‚:
> > >
> > >If you allow one container to hand out conflicting locks while another
> > >container is allowing reclaims, then you can end up with some very
> > >difficult to debug silent data corruption. That's the worst possible
> > >outcome, IMO. We really need to actively keep people from shooting
> > >themselves in the foot here.
> > >
> > >One possibility might be to only allow filesystems to be exported from
> > >a single container at a time (and allow that to be overridable somehow
> > >once we have a working active/active serving solution). With that, you
> > >may be able limp along with a per-container grace period handling
> > >scheme like you're proposing.
> > >
> > 
> > Ok then. Keeping people from shooting themselves here sounds reasonable.
> > And I like the idea of exporting a filesystem only from once per
> > network namespace.
> 
> Unfortunately that's not going to get us very far, especially not in the
> v4 case where we've got the common read-only pseudoroot that everyone
> has to share.

I don't see how that can work in cases where each container has its own
private mount namespace. You're going to have to tie that pseudoroot to
the mount namespace somehow.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
