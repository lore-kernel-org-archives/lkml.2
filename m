Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab2JVRC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:02:57 -0400
Received: from mx2.netapp.com ([216.240.18.37]:53606 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab2JVRC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:02:56 -0400
X-IronPort-AV: E=Sophos;i="4.80,630,1344236400"; 
   d="scan'208";a="703021359"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: Re: [ 02/37] lockd: use rpc clients cl_nodename for id encoding
Thread-Topic: [ 02/37] lockd: use rpc clients cl_nodename for id encoding
Thread-Index: AQHNrag6F9dsWWfsAkWh+svJcGKMXpfBuT0AgAKyYwCAAZyLgA==
Date: Mon, 22 Oct 2012 17:02:52 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA9092890D7@SACEXCMBX04-PRD.hq.netapp.com>
References: <20121019031302.789593147@linuxfoundation.org>
	 <20121019031303.167008948@linuxfoundation.org>
	 <20121019231518.GE13292@decadent.org.uk> <20121021162618.GB25856@kroah.com>
In-Reply-To: <20121021162618.GB25856@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <979645209D94CC4EB1817B093FAA0B46@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9MH31HC030522

On Sun, 2012-10-21 at 09:26 -0700, Greg Kroah-Hartman wrote:
> On Sat, Oct 20, 2012 at 12:15:18AM +0100, Ben Hutchings wrote:
> > On Thu, Oct 18, 2012 at 08:16:25PM -0700, Greg Kroah-Hartman wrote:
> > > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Stanislav Kinsbursky <skinsbursky@parallels.com>
> > > 
> > > commit 303a7ce92064c285a04c870f2dc0192fdb2968cb upstream.
> > > 
> > > Taking hostname from uts namespace if not safe, because this cuold be
> > > performind during umount operation on child reaper death. And in this case
> > > current->nsproxy is NULL already.
> >  
> > In this case (3.0.y) you haven't included the following change
> > (commit cb7323fffa85 'lockd: create and use per-net NSM RPC clients on
> > MON/UNMON requests') that makes lockd actually use cl_nodename.  I
> > think this patch alone won't fix the bug, as nsm_args::nodename can
> > end up pointing to freed memory.
> > 
> > (I also wonder whether clients should really be per-net or per UTS
> > namespace, and whether those should be orthogonal namespaces at all.)
> 
> Hm, Trond, should I also include the other commit above in the next
> 3.0-stable release?
> 
> Or should this one be dropped?

Hi Greg,

Applying this patch shouldn't be harmful, but since it isn't actually
fixing a problem (there being no net-namespace code in Linux-3.0), I'd
suggest just dropping it.

Thanks!
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
