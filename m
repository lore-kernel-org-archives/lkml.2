Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab2CHUuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:50:19 -0500
Received: from mx2.netapp.com ([216.240.18.37]:31885 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab2CHUuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:50:16 -0500
X-IronPort-AV: E=Sophos;i="4.73,553,1325491200"; 
   d="scan'208";a="631884499"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Olga Kornievskaia <aglo@citi.umich.edu>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] NFSv4: Return the delegation if the server returns
 NFS4ERR_OPENMODE
Thread-Topic: [PATCH 2/2] NFSv4: Return the delegation if the server returns
 NFS4ERR_OPENMODE
Thread-Index: AQHM/LNZTVOlz2021kCDLkZUy1AmJZZhNRYAgAAGfYCAACPOAIAABSyAgAACRwA=
Date: Thu, 8 Mar 2012 20:50:14 +0000
Message-ID: <1331239814.11759.1.camel@lade.trondhjem.org>
References: <87k42yjb0c.fsf@tucsk.pomaz.szeredi.hu>
	 <1331160049-3842-1-git-send-email-Trond.Myklebust@netapp.com>
	 <1331160049-3842-2-git-send-email-Trond.Myklebust@netapp.com>
	 <1331160049-3842-3-git-send-email-Trond.Myklebust@netapp.com>
	 <CAN-5tyG-w+ie3sxTwNA6e9x=CojxyDaJScJuCbS+9VE=yTmJNA@mail.gmail.com>
	 <1331230525.2472.39.camel@lade.trondhjem.org>
	 <CAN-5tyFYE5ECtv__C9S_GMT1gBMQ4+6WPS-1BjmSE7vHoRAQdw@mail.gmail.com>
	 <20120308204205.GB9273@fieldses.org>
In-Reply-To: <20120308204205.GB9273@fieldses.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <15E5548A396897479E6F835DED20EF19@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q28KoP5w025293

On Thu, 2012-03-08 at 15:42 -0500, J. Bruce Fields wrote:
> On Thu, Mar 08, 2012 at 03:23:34PM -0500, Olga Kornievskaia wrote:
> > On Thu, Mar 8, 2012 at 1:15 PM, Myklebust, Trond
> > <Trond.Myklebust@netapp.com> wrote:
> > > On Thu, 2012-03-08 at 12:52 -0500, Olga Kornievskaia wrote:
> > >> wouldn't it be better for you to proactively return a read delegation
> > >> then unnecessarily erroring?
> > >
> > > If nobody else holds a delegation, then the NFS client is actually
> > > allowed to keep its read delegation while writing to the file. It does
> > > admittedly need to request an OPEN stateid for write in that case...
> > > (See section 10.4 of RFC3530bis draft 16)
> > 
> > If we both agree that there has to be a request for an open stateid for
> > a write, then instead of returning the read delegation if the client receives
> > err_openmode (when it send the request with read delegation stateid
> > as you said per 3560bis), can't the client resend the setattr with the open
> > stateid? The ordering of the stateid usage is a "should" and not a "must".
> > 
> > In rfc5661, it really doesn't make sense to ever send a setattr with
> > a read delegation stateid. According to 9.1.2, the server "MUST" return
> > err_open_mode" error in that case.
> > 
> > I gather you are in this case dealing with 4.0 delegations. But I wonder
> > if you'll do something else for 4.1 delegation then?
> 
> 3530bis has the same language ("...must verify that the access mode
> allows writing and return an NFS4ERR_OPENMODE error if it does not").

OK, so we shouldn't send the delegation stateid either for v4 or v4.1.
However should we pre-emptively return the delegation? I've been
assuming not.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
