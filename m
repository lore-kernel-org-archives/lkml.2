Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934009Ab1IIXDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 19:03:37 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:38536 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933865Ab1IIXDf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 19:03:35 -0400
From: Satoru Moriya <satoru.moriya@hds.com>
To: Randy Dunlap <rdunlap@xenotime.net>, "riel@redhat.com" <riel@redhat.com>
CC: Satoru Moriya <smoriya@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hughd@google.com" <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Date: Fri, 9 Sep 2011 19:01:13 -0400
Subject: Re: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Topic: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Index: AQHMb0ShXxav+ctD80C98iMKPReyCg==
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9CAFE00218@USINDEVS02.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=5 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1109090284
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2011 03:26 PM, Rik van Riel wrote:

> @@ -5123,6 +5135,7 @@ static void setup_per_zone_lowmem_reserve(void)
>  void setup_per_zone_wmarks(void)
>  {
>  	unsigned long pages_min = min_free_kbytes >> (PAGE_SHIFT - 10);
> +	unsigned long pages_low = extra_free_kbytes >> (PAGE_SHIFT - 10);

I think pages_extra is better name for this variable because pages_low is
calculated like following.

pages_low = pages_min + "pages_extra" + (pages_min >> 2)

>  	unsigned long lowmem_pages = 0;
>  	struct zone *zone;
>  	unsigned long flags;
> @@ -5134,11 +5147,14 @@ void setup_per_zone_wmarks(void)
>  	}
>  
>  	for_each_zone(zone) {
> -		u64 tmp;
> +		u64 min, low;

Same as above.

Thanks,
Satoru
