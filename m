Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab1JRAdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 20:33:05 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:34791 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042Ab1JRAdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 20:33:04 -0400
Message-ID: <4E9CC93B.4000800@dsn.lapis-semi.com>
Date: Tue, 18 Oct 2011 09:32:59 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: gpio-ml-ioh: Support interrupt function
References: <20111017201058.GA13916@elgon.mountain>
In-Reply-To: <20111017201058.GA13916@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(2011/10/18 5:10), Dan Carpenter wrote:
> The linux-next patch 54be566317b6 "gpio-ml-ioh: Support interrupt
> function" generates a Sparse warning.
>
> +               irq_base = irq_alloc_descs(-1, IOH_IRQ_BASE, num_ports[j],
> +                                          GFP_KERNEL);
>                                             ^^^^^^^^^^
>
> The last argument should be a NUMA node, not a GFP_ flag.  I'm not
> sure what the right fix is.  There are currently 5 callers in my
> cscope for this function in linux-next.
>
> 2 pass GFP_KERNEL which is wrong.
> 2 pass 0 which maybe should be cpu_to_node(0)?
> 1 passes -1 which maybe could be NUMA_NO_NODE?
>
I can understand your saying.
Seeing accepted other drivers, '0' or '-1' is used.
Focusing on GPIO driver, gpio-pca953x.c uses '-1'.

Though I tried to understand source code of irq_alloc_descs,
I can't understand which value we should use.

 > Grant,
Could you help me ?

-- 
tomoya
ROHM Co., Ltd.
