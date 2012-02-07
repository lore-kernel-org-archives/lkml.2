Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab2BGPe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 10:34:58 -0500
Received: from mx2.netapp.com ([216.240.18.37]:25629 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab2BGPe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 10:34:57 -0500
X-IronPort-AV: E=Sophos;i="4.73,377,1325491200"; 
   d="scan'208";a="623243384"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "Schumaker, Bryan" <Bryan.Schumaker@netapp.com>
CC: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "xemul@parallels.com" <xemul@parallels.com>,
        "neilb@suse.de" <neilb@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH 1/4] NFS: make nfs_client_list per net ns
Thread-Topic: [PATCH 1/4] NFS: make nfs_client_list per net ns
Thread-Index: AczZ9CjJMcn+q4beRcODUHeh0/kZLwL/InoAAAAYcQA=
Date: Tue, 7 Feb 2012 15:34:48 +0000
Message-ID: <1328628888.4124.16.camel@lade.trondhjem.org>
References: <20120123172605.29637.15682.stgit@localhost6.localdomain6>
	 <4F3143F4.3010502@netapp.com>
In-Reply-To: <4F3143F4.3010502@netapp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <3AA830B78768D54E87D975703D2A8E82@tahoe.netapp.com>
MIME-Version: 1.0
X-OriginalArrivalTime: 07 Feb 2012 15:34:51.0745 (UTC) FILETIME=[088D4D10:01CCE5AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q17FZ9Hl029124

On Tue, 2012-02-07 at 10:32 -0500, Bryan Schumaker wrote:
> I fixed up my bisect and identified this patch instead.  The problem I'm seeing is:
> 
>   CC [M]  fs/nfs/delegation.o
>   CC [M]  fs/nfs/idmap.o
> fs/nfs/idmap.c: In function 'rpc_pipefs_event':
> fs/nfs/idmap.c:535:9: error: implicit declaration of function 'net_generic' [-Werror=implicit-function-declaration]
> fs/nfs/idmap.c:535:50: error: 'nfs_net_id' undeclared (first use in this function)
> fs/nfs/idmap.c:535:50: note: each undeclared identifier is reported only once for each function it appears in
> fs/nfs/idmap.c:540:82: error: dereferencing pointer to incomplete type
> fs/nfs/idmap.c:540:224: error: dereferencing pointer to incomplete type
> cc1: some warnings being treated as errors
> 
> make[2]: *** [fs/nfs/idmap.o] Error 1
> make[1]: *** [fs/nfs] Error 2
> make: *** [fs] Error 2
> 
> I think you need to add: #include "netns.h" to idmap.c.
> 
> - Bryan

That should already be there in the 'devel' branch. See commit
17347d03c008e2f504c33bb4905cdad0abc01319.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
