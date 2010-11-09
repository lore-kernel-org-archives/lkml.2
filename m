Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab0KIFtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 00:49:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59840 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab0KIFtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 00:49:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mike Waychison <mikew@google.com>
Subject: Re: [PATCH v2 17/23] kmsg_dumper: Introduce a new 'SOFT' dump reason
Cc: kosaki.motohiro@jp.fujitsu.com, simon.kagstrom@netinsight.net,
        davem@davemloft.net, nhorman@tuxdriver.com,
        Matt Mackall <mpm@selenic.com>, adurbin@google.com,
        linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>, Americo Wang <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
In-Reply-To: <20101108203316.22479.86025.stgit@crlf.mtv.corp.google.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com> <20101108203316.22479.86025.stgit@crlf.mtv.corp.google.com>
Message-Id: <20101109144749.BC6C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Nov 2010 14:49:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> It is a useful to be able to exercise kmsg_dumper implementations without
> requiring a kernel oops or panic.  This commit adds a new reason called
> KMSG_DUMP_SOFT, which signifies that the system isn't really going down.
> 
> This logic is used in a later commit that introduces the netoops driver.
> 
> Signed-off-by: Mike Waychison <mikew@google.com>
> ---
> 
> It is also possible that we not introduce KMSG_DUMP_SOFT, and simply overload
> the existing KMSG_DUMP_OOPS reason, but I figured that this would be cleaner.
> 
> TODO: Make sure mtdoops and ramoops do something useful with this flag?

Yes. If userland explicitly want to log, we have no reason to refuse it. :)
But, I don't think KMSG_DUMP_SOFT is good name because _SOFT don't explain
anything.



> ---
>  include/linux/kmsg_dump.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/kmsg_dump.h b/include/linux/kmsg_dump.h
> index a229acc..0abc2d7 100644
> --- a/include/linux/kmsg_dump.h
> +++ b/include/linux/kmsg_dump.h
> @@ -20,6 +20,7 @@ enum kmsg_dump_reason {
>  	KMSG_DUMP_OOPS,
>  	KMSG_DUMP_PANIC,
>  	KMSG_DUMP_KEXEC,
> +	KMSG_DUMP_SOFT,
>  };
>  
>  /**
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



