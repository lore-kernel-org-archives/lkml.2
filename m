Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab1LIQBO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 11:01:14 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:22650
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149Ab1LIQBM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 11:01:12 -0500
X-SpamScore: -16
X-BigFish: VS-16(zz9371I542M1432N4015Lzz1202hzz8275bh8275dhz2fh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Haiyang Zhang <haiyangz@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH] net/hyperv: Fix the stop/wake queue mechanism
Thread-Topic: [PATCH] net/hyperv: Fix the stop/wake queue mechanism
Thread-Index: AQHMsSx+2SVgzLNkXk+4T3Hv4pSSBZXTs8Ww
Date: Fri, 9 Dec 2011 16:00:59 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0CCD457B@TK5EX14MBXC227.redmond.corp.microsoft.com>
References: <1322855785-22776-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1322855785-22776-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.34]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Haiyang Zhang [mailto:haiyangz@microsoft.com]
> Sent: Friday, December 02, 2011 2:56 PM
> To: Haiyang Zhang; KY Srinivasan; davem@davemloft.net; gregkh@suse.de;
> linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
> devel@linuxdriverproject.org
> Subject: [PATCH] net/hyperv: Fix the stop/wake queue mechanism
> 
> The ring buffer is only used to pass meta data for outbound packets. The
> actual payload is accessed by DMA from the host. So the stop/wake queue
> mechanism based on counting and comparing number of pages sent v.s.
> number
> of pages in the ring buffer is wrong. Also, there is a race condition in
> the stop/wake queue calls, which can stop xmit queue forever.
> 
> The new stop/wake queue mechanism is based on the actual bytes used by
> outbound packets in the ring buffer. The check for number of outstanding
> sends after stop queue prevents the race condition that can cause wake
> queue happening earlier than stop queue.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reported-by: Long Li <longli@microsoft.com>
> ---
>  drivers/net/hyperv/netvsc.c     |   14 +++++++++++---
>  drivers/net/hyperv/netvsc_drv.c |   24 +-----------------------
>  2 files changed, 12 insertions(+), 26 deletions(-)

Hi Greg,

Since the netvsc haven't been merged into Dave's tree yet after out of staging,
could you consider this patch for your tree?

Thanks,
-  Haiyang


