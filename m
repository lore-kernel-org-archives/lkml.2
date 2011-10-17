Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab1JQULP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 16:11:15 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:36708 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab1JQULN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 16:11:13 -0400
Date: Mon, 17 Oct 2011 23:10:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Subject: re: gpio-ml-ioh: Support interrupt function
Message-ID: <20111017201058.GA13916@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4E9C8BDD.0146,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The linux-next patch 54be566317b6 "gpio-ml-ioh: Support interrupt
function" generates a Sparse warning.

+               irq_base = irq_alloc_descs(-1, IOH_IRQ_BASE, num_ports[j],
+                                          GFP_KERNEL);
                                           ^^^^^^^^^^

The last argument should be a NUMA node, not a GFP_ flag.  I'm not
sure what the right fix is.  There are currently 5 callers in my
cscope for this function in linux-next.

2 pass GFP_KERNEL which is wrong.
2 pass 0 which maybe should be cpu_to_node(0)?
1 passes -1 which maybe could be NUMA_NO_NODE?

I'm probably embarrassing myself with my ignorance here, but I do
know that GFP_KERNEL isn't right.

regards,
dan carpenter
