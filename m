Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965609Ab2CBXn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 18:43:26 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:52717 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab2CBXnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 18:43:25 -0500
From: Satoru Moriya <satoru.moriya@hds.com>
To: Rik van Riel <riel@redhat.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        "shaohua.li@intel.com" <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Fri, 2 Mar 2012 18:43:01 -0500
Subject: RE: [RFC][PATCH] avoid swapping out with swappiness==0
Thread-Topic: [RFC][PATCH] avoid swapping out with swappiness==0
Thread-Index: Acz4xn5SAjgXOus7RFGcNtjskfzr0wAB1qTA
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9CB945618C@USINDEVS02.corp.hds.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9CB9455FE2@USINDEVS02.corp.hds.com>
 <4F514E09.5060801@redhat.com>
In-Reply-To: <4F514E09.5060801@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1203020230
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q22NhZeK021210

Hi Rik,

Thank you for reviewing.

On 03/02/2012 05:47 PM, Rik van Riel wrote:
> On 03/02/2012 12:36 PM, Satoru Moriya wrote:
>> @@ -1999,7 +1999,7 @@ out:
>>           unsigned long scan;
>>
>>           scan = zone_nr_lru_pages(mz, lru);
>> -        if (priority || noswap) {
>> +        if (priority || noswap || !vmscan_swappiness(mz, sc)) {
>>               scan>>= priority;
>>               if (!scan&&  force_scan)
>>                   scan = SWAP_CLUSTER_MAX;
> 
> However, I do not understand why we fail to scale the number of pages 
> we want to scan with priority if "noswap".
> 
> For that matter, surely if we do not want to swap out anonymous pages, 
> we WANT to go into this if branch, in order to make sure we set "scan" 
> to 0?
> 
> scan = div64_u64(scan * fraction[file], denominator);
> 
> With your patch and swappiness=0, or no swap space, it looks like we 
> do not zero out "scan" and may end up scanning anonymous pages.

With my patch, if swappiness==0 or noswap==1, fraction[file] is
set to 0. As a result, scan will be set to 0, too.

> Am I overlooking something?  Is this correct?
> 
> I mean, it is Friday and my brain is very full...

Have a nice weekend ;)

Regards,
Satoru
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
