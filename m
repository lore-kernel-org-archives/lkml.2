Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab2LNUTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 15:19:06 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:46785 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab2LNUTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 15:19:01 -0500
From: Satoru Moriya <satoru.moriya@hds.com>
To: Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>
CC: Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [patch 2/8] mm: vmscan: disregard swappiness shortly before
 going OOM
Thread-Topic: [patch 2/8] mm: vmscan: disregard swappiness shortly before
 going OOM
Thread-Index: AQHN2LHkBEwhfYwtskuvG7nk0rbXIZgW3T8AgABSm4CAAAnhgIAAFiQwgAC/pACAAD92AIAAdxqA///4ZSA=
Date: Fri, 14 Dec 2012 20:17:27 +0000
Message-ID: <8631DC5930FA9E468F04F3FD3A5D007214AD7388@USINDEM103.corp.hds.com>
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org>
 <1355348620-9382-3-git-send-email-hannes@cmpxchg.org>
 <20121213103420.GW1009@suse.de> <20121213152959.GE21644@dhcp22.suse.cz>
 <20121213160521.GG21644@dhcp22.suse.cz>
 <8631DC5930FA9E468F04F3FD3A5D007214AD2FA2@USINDEM103.corp.hds.com>
 <20121214045030.GE6317@cmpxchg.org> <20121214083738.GA6898@dhcp22.suse.cz>
 <50CB493B.8000900@redhat.com>
In-Reply-To: <50CB493B.8000900@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-14_05:2012-12-14,2012-12-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=5 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1212140188
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBEKJECo002337

On 12/14/2012 10:43 AM, Rik van Riel wrote:
> On 12/14/2012 03:37 AM, Michal Hocko wrote:
> 
>> I can answer the later. Because memsw comes with its price and 
>> swappiness is much cheaper. On the other hand it makes sense that
>> swappiness==0 doesn't swap at all. Or do you think we should get back 
>> to _almost_ doesn't swap at all?
> 
> swappiness==0 will swap in emergencies, specifically when we have 
> almost no page cache left, we will still swap things out:
> 
>         if (global_reclaim(sc)) {
>                 free  = zone_page_state(zone, NR_FREE_PAGES);
>                 if (unlikely(file + free <= high_wmark_pages(zone))) {
>                         /*
>                          * If we have very few page cache pages, force-scan
>                          * anon pages.
>                          */
>                         fraction[0] = 1;
>                         fraction[1] = 0;
>                         denominator = 1;
>                         goto out;
> 
> This makes sense, because people who set swappiness==0 but do have 
> swap space available would probably prefer some emergency swapping 
> over an OOM kill.

This behavior is reasonable for global reclaim to me. But when
we hit this condition, it may be better to print some messages
to notify the user who set swappiness==0 of anon page scan.

Regards,
Satoru
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
