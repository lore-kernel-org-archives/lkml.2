Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759178Ab2IKLsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:48:39 -0400
Received: from mx0.aculab.com ([213.249.233.131]:48879 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759047Ab2IKLsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:48:38 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH 2/2] netprio_cgroup: Optimize the priomap copy loop slightly
Date: Tue, 11 Sep 2012 12:42:23 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6FE9@saturn3.aculab.com>
In-Reply-To: <20120911112237.13852.1095.stgit@srivatsabhat.in.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH 2/2] netprio_cgroup: Optimize the priomap copy loop slightly
thread-index: Ac2QD9dFZ+mfmLSrSi6ywm2vEK2SwQAAnJjw
References: <20120911112231.13852.61794.stgit@srivatsabhat.in.ibm.com> <20120911112237.13852.1095.stgit@srivatsabhat.in.ibm.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        <davem@davemloft.net>, <nhorman@tuxdriver.com>
Cc: <john.r.fastabend@intel.com>, <gaofeng@cn.fujitsu.com>,
        <eric.dumazet@gmail.com>, <mark.d.rustad@intel.com>,
        <lizefan@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8BBmjCh023520

> -	for (i = 0;
> -	     old_priomap && (i < old_priomap->priomap_len);
> -	     i++)
> -		new_priomap->priomap[i] = old_priomap->priomap[i];
> +	if (old_priomap) {
> +		old_len = old_priomap->priomap_len;
> +
> +		for (i = 0; i < old_len; i++)
> +			new_priomap->priomap[i] = old_priomap->priomap[i];
> +	}

Or:
	memcpy(new_priomap->priomap, old_priomap->priomap,
		old_priomap->priomap_len * sizeof old_priomap->priomap[0]);

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
