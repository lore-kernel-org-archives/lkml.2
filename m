Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab2BPPOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 10:14:04 -0500
Received: from mx2.netapp.com ([216.240.18.37]:29489 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab2BPPOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 10:14:01 -0500
X-IronPort-AV: E=Sophos;i="4.73,430,1325491200"; 
   d="scan'208";a="625975697"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "xemul@parallels.com" <xemul@parallels.com>,
        "neilb@suse.de" <neilb@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [RFC PATCH] SUNRPC: connect local transports synchronously
Thread-Topic: [RFC PATCH] SUNRPC: connect local transports synchronously
Thread-Index: AQHM7Lys+QBmkvlPAkK7M1BwYZ2FPZZAJ9EA
Date: Thu, 16 Feb 2012 15:13:53 +0000
Message-ID: <1329405232.4279.4.camel@lade.trondhjem.org>
References: <20120216150507.19081.28659.stgit@localhost6.localdomain6>
In-Reply-To: <20120216150507.19081.28659.stgit@localhost6.localdomain6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C889075737E6264D975E0FAE3246B671@tahoe.netapp.com>
MIME-Version: 1.0
X-OriginalArrivalTime: 16 Feb 2012 15:13:55.0367 (UTC) FILETIME=[9968FB70:01CCECBD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1GFECVb024761

On Thu, 2012-02-16 at 19:06 +0400, Stanislav Kinsbursky wrote:
> Local tranports uses UNIX sockets and connecting of these sockets is done in
> context of file system namespace (i.e. task file system root).
> Currenly, all sockets connect operations are performed by rpciod work queue,
> which actually means, that any service will be registered in the same rpcbind
> instance regardless to process file system root.
> This is not containers, which usually have it's own nested root. There are 2
> approaches, how to solve the problem. First one is to store proper root in
> tranport and switch to it in rpciod workqueue function for connect operations.
> But this looks ugly. The second one is to connect to unix sockets
> synchronously. This aptch implements the last one.

That approach can fall afoul of the selinux restrictions on the process
context. Processes that are allowed to write data, may not be allowed to
create sockets or call connect(). That is the main reason for doing it
in the rpciod context, which is a clean kernel process context.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
