Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab2IMBYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 21:24:17 -0400
Received: from mx2.netapp.com ([216.240.18.37]:47030 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705Ab2IMBYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 21:24:10 -0400
X-IronPort-AV: E=Sophos;i="4.80,413,1344236400"; 
   d="scan'208";a="688993793"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Josh Boyer <jwboyer@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Schumaker, Bryan" <Bryan.Schumaker@netapp.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [ 042/108] NFS: Alias the nfs module to nfs4
Thread-Topic: [ 042/108] NFS: Alias the nfs module to nfs4
Thread-Index: AQHNkT7zQ9NJUuhTq0uFXyZ79P0ufJeH616AgAAEb4A=
Date: Thu, 13 Sep 2012 01:24:08 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA908FA0381@SACEXCMBX04-PRD.hq.netapp.com>
References: <20120912232816.GA1655@kroah.com>
	 <20120912232450.500619493@linuxfoundation.org>
	 <20120912232454.947953753@linuxfoundation.org>
	 <CA+5PVA5TuUo329wGe6UGCbrq1o7rOs5uMosNtv-38ZqhrVPUAQ@mail.gmail.com>
In-Reply-To: <CA+5PVA5TuUo329wGe6UGCbrq1o7rOs5uMosNtv-38ZqhrVPUAQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <01849687A5E459478E648F1E79BFBA26@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8D1OSm5001990

On Wed, 2012-09-12 at 21:08 -0400, Josh Boyer wrote:
> On Wed, Sep 12, 2012 at 7:28 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > From: Greg KH <gregkh@linuxfoundation.org>
> >
> > 3.5-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > commit 425e776d93a7a5070b77d4f458a5bab0f924652c upstream.
> >
> > This allows distros to remove the line from their modprobe
> > configuration.
> >
> > Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
> > Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> > [bwh: Backported to 3.2: adjust context]
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Could someone elaborate why this is acceptable now, while it wasn't
> during the timeframe I sent an identical patch months ago?
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/1204.3/02064.html
> 
> We had some trouble in Fedora 17 because of this and would up with
> patches to nfs-utils because the modalias was NAKed.  If we're bringing
> it into stable (and upstream) at this point, it would be good to know
> what changed so I can go and undo what we did because I was told no.
> 
> Please don't get me wrong, I'm all for simplicity.  I'm just perhaps
> so simple that the brief changelog confuses me because it doesn't
> actually describe why the original solution wasn't followed up on.

Linux-3.6 converts NFSv2/v3/v4 into modules, and so modprobe.conf
entries of the form

  alias nfs4 nfs

will now fail to ensure that 'mount -t nfs4 ...' works. In order to
facilitate the task for the distros when dealing with kernels >= 3.5.x,
we've added the automatic module alias so that they can remove the
hard-coded aliases in modprobe.conf while remaining backward-compatible.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
