Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795Ab2IJPmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:42:01 -0400
Received: from mx2.netapp.com ([216.240.18.37]:63268 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab2IJPl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:41:59 -0400
X-IronPort-AV: E=Sophos;i="4.80,398,1344236400"; 
   d="scan'208";a="687928046"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: Jeff Layton <jlayton@redhat.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH v2] SUNRPC: check current nsproxy before set of node
 name on client creation
Thread-Topic: [PATCH v2] SUNRPC: check current nsproxy before set of node
 name on client creation
Thread-Index: AQHNeUylwnVjh2tbW02Id+IcJKD75ZeAFAKAgAB9EYCAAI9kAIACwv6AgABw0oCAAALMAIAAAUkA
Date: Mon, 10 Sep 2012 15:41:57 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA908F96556@SACEXCMBX04-PRD.hq.netapp.com>
References: <20120813113731.9629.31906.stgit@localhost.localdomain>
	    <20120813081054.0ee39037@corrin.poochiereds.net>
	   <4FA345DA4F4AE44899BD2B03EEEC2FA908F90888@SACEXCMBX04-PRD.hq.netapp.com>
	   <504ADED9.2020607@parallels.com>
	  <4FA345DA4F4AE44899BD2B03EEEC2FA908F914D4@SACEXCMBX04-PRD.hq.netapp.com>
	  <504DA833.60301@parallels.com>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA908F9547B@SACEXCMBX04-PRD.hq.netapp.com>
	 <504E0930.5050408@parallels.com>
In-Reply-To: <504E0930.5050408@parallels.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB4663C4F782D14DAD289D0EC7C2DED5@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8AFg8v0018783

On Mon, 2012-09-10 at 19:37 +0400, Stanislav Kinsbursky wrote:
> Hi, Trond.
> So, if I understand you right, we can create rpc client (or increase usage 
> counter) on NSMPROC_MON call and destroy (or decrease usage counter) on 
> NSMPROC_UNMON call.
> Will this solution works?

The rpc client(s) will need to be per-net-namespace, which complicates
matters a little bit, but yes, creation at NSMPROC_MON, and destruction
at NSMPROC_UNMON should work.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
