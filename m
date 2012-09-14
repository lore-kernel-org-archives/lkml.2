Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613Ab2INRih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:38:37 -0400
Received: from mx2.netapp.com ([216.240.18.37]:42379 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758935Ab2INRif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:38:35 -0400
X-IronPort-AV: E=Sophos;i="4.80,423,1344236400"; 
   d="scan'208";a="689775256"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Chuck Lever <chuck.lever@oracle.com>
CC: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jlayton@redhat.com" <jlayton@redhat.com>
Subject: Re: [PATCH 0/3] lockd: use per-net refrence-counted NSM clients
Thread-Topic: [PATCH 0/3] lockd: use per-net refrence-counted NSM clients
Thread-Index: AQHNkoXiw9uFuLP9oU2/5Ud3jGv0jJeKhW2AgAAKVgA=
Date: Fri, 14 Sep 2012 17:38:18 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA908FA7F55@SACEXCMBX04-PRD.hq.netapp.com>
References: <20120914140811.10835.81465.stgit@localhost.localdomain>
	 <4030B8F9-5C67-4AE7-826E-B4B6AD4FAD01@oracle.com>
In-Reply-To: <4030B8F9-5C67-4AE7-826E-B4B6AD4FAD01@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8123AE52F6FD5B4DAF238BC39230C081@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8EHchpE011305

On Fri, 2012-09-14 at 13:01 -0400, Chuck Lever wrote:
> What happens if statd is restarted?

Nothing unusual. Why?

> Sent from my iPhone
> 
> On Sep 14, 2012, at 10:25 AM, Stanislav Kinsbursky <skinsbursky@parallels.com> wrote:
> 
> > This is a bug fix for https://bugzilla.redhat.com/show_bug.cgi?id=830862.
> > 
> > The problem is that with NFSv4 mount in container (with separated mount
> > namesapce) and active lock on it, dying child reaped of this container will
> > try to umount NFS and doing this will try to create RPC client to send
> > unmonitor request to statd.
> > But creation of RCP client requires valid current->nsproxy (for operation with
> > utsname()) and during umount on child reaper exit it's equal to zero.
> > 
> > Proposed solution is to introduce refrence-counter per-net NSM client, which
> > is created on fist monitor call and destroyed after the lst monitor call.
> > 
> > The following series implements...
> > 
> > ---
> > 
> > Stanislav Kinsbursky (3):
> >      lockd: use rpc client's cl_nodename for id encoding
> >      lockd: per-net NSM client creation and destruction helpers introduced
> >      lockd: create and use per-net NSM RPC clients on MON/UNMON requests
> > 
> > 
> > fs/lockd/mon.c   |   91 +++++++++++++++++++++++++++++++++++++++++++-----------
> > fs/lockd/netns.h |    4 ++
> > fs/lockd/svc.c   |    1 +
> > 3 files changed, 77 insertions(+), 19 deletions(-)
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
