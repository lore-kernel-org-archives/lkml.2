Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767807Ab2KONeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 08:34:24 -0500
Received: from mx2.netapp.com ([216.240.18.37]:1770 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767735Ab2KONeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:34:22 -0500
X-IronPort-AV: E=Sophos;i="4.83,257,1352102400"; 
   d="scan'208";a="710348862"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH v3] SUNRPC: set desired file system root before
 connecting local transports
Thread-Topic: [PATCH v3] SUNRPC: set desired file system root before
 connecting local transports
Thread-Index: AQHNwviEozW+CxsorEGJ6nqK7Kz9MZfra/qA
Date: Thu, 15 Nov 2012 13:34:16 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA9092E2984@SACEXCMBX04-PRD.hq.netapp.com>
References: <20121106124035.GA20522@infradead.org>
	 <20121106130705.GC6718@fieldses.org> <20121106131018.GA12211@infradead.org>
	 <20121106133605.GD6718@fieldses.org> <20121107183355.GA7421@fieldses.org>
	 <50A0B562.2090807@parallels.com> <20121114210112.GA539@fieldses.org>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA9092E0A40@SACEXCMBX04-PRD.hq.netapp.com>
	 <20121114214236.GB539@fieldses.org>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA9092E0AE9@SACEXCMBX04-PRD.hq.netapp.com>
	 <20121114215426.GC539@fieldses.org> <87obize6jp.fsf@xmission.com>
In-Reply-To: <87obize6jp.fsf@xmission.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <520DBE35F2D5774493D5DBE10454EFB4@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAFDYUvc030396

On Wed, 2012-11-14 at 22:14 -0800, Eric W. Biederman wrote:
> "J. Bruce Fields" <bfields@fieldses.org> writes:
> 
> > On Wed, Nov 14, 2012 at 09:51:33PM +0000, Myklebust, Trond wrote:
> >> On Wed, 2012-11-14 at 16:42 -0500, J. Bruce Fields wrote:
> >> > Simo's patches use them for upcalls to svcgssd.  Those will always be
> >> > done from server threads.
> >> 
> >> Any reason why you can't set that up when you start nfsd?
> >
> > Oh, right, I was thinking of the upcalls themselves--right, the connect
> > we should be able to do on server start, I agree.
> >
> >> 
> >> > > If not, then let's just move
> >> > > the AF_LOCAL connection back into the process context and out of rpciod.
> >> > 
> >> > Remind me how this helps?
> >> 
> >> rpciod shares the 'init' process net namespace and chroot properties.
> >> If, however you call bind() from the (containerised) process that was
> >> used to start nfsd, then you will be using filesystem root (and net
> >> namespace) of that container.
> >
> > Got it.
> 
> If you can move the connect and bind into the server start that does
> sound like a very good and maintainable solution.  I suspect it might
> even be a smidge better for error handling.
> 
> Is there ever a reason to reconnect one of these sockets?

Not for the rpcbind case, however you can easily get into a situation
where the user restarts the gss daemon. The good news is that the gss
upcall code that uses AF_LOCAL hasn't been merged upstream yet, so that
particular interface is not yet locked in stone.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
