Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636Ab2DZSLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:11:45 -0400
Received: from mx2.netapp.com ([216.240.18.37]:7976 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706Ab2DZSLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:11:44 -0400
X-IronPort-AV: E=Sophos;i="4.75,487,1330934400"; 
   d="scan'208";a="643681473"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH 2/3] SUNRPC: traverse clients tree on PipeFS event
Thread-Topic: [PATCH 2/3] SUNRPC: traverse clients tree on PipeFS event
Thread-Index: AQHNHwCml0nktMD7qUOuv65VsxBLHpat52cA
Date: Thu, 26 Apr 2012 18:11:42 +0000
Message-ID: <1335463902.9701.35.camel@lade.trondhjem.org>
References: <20120420141419.10848.84280.stgit@localhost6.localdomain6>
	 <20120420141925.10848.90395.stgit@localhost6.localdomain6>
In-Reply-To: <20120420141925.10848.90395.stgit@localhost6.localdomain6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E9018303CA3AF143BE9E32FDACC34E43@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3QIBwM5015796

On Fri, 2012-04-20 at 18:19 +0400, Stanislav Kinsbursky wrote:

> +static int __rpc_pipefs_event(struct rpc_clnt *clnt, unsigned long event,
> +				struct super_block *sb)
> +{
> +	int error;
> +
> +	if (!rpc_clnt_skip_event(clnt, event)) {
> +		error = __rpc_clnt_handle_event(clnt, event, sb);
> +		if (error)
> +			return error;
> +	}
> +	if (clnt != clnt->cl_parent)
> +		return __rpc_pipefs_event(clnt->cl_parent, event, sb);
> +	return 0;
> +}

Hi Stanislav,

Recursion in the kernel is generally frowned upon due to the stack size
limits. Could you please rewrite the above into a simple loop. Something
along the lines of:

	for(;;) {
		...

		if (clnt == clnt->cl_parent)
			break;
		clnt = clnt->cl_parent;
	}

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
