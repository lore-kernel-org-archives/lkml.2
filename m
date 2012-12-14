Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab2LNTpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 14:45:30 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:46909 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab2LNTp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 14:45:29 -0500
From: Satoru Moriya <satoru.moriya@hds.com>
To: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>
CC: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [patch 2/8] mm: vmscan: disregard swappiness shortly before
 going OOM
Thread-Topic: [patch 2/8] mm: vmscan: disregard swappiness shortly before
 going OOM
Thread-Index: AQHN2LHkBEwhfYwtskuvG7nk0rbXIZgW3T8AgABSm4CAAAnhgIAAFiQwgAC/pACAAD92AIAAZd5Q
Date: Fri, 14 Dec 2012 19:44:30 +0000
Message-ID: <8631DC5930FA9E468F04F3FD3A5D007214AD7315@USINDEM103.corp.hds.com>
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org>
 <1355348620-9382-3-git-send-email-hannes@cmpxchg.org>
 <20121213103420.GW1009@suse.de> <20121213152959.GE21644@dhcp22.suse.cz>
 <20121213160521.GG21644@dhcp22.suse.cz>
 <8631DC5930FA9E468F04F3FD3A5D007214AD2FA2@USINDEM103.corp.hds.com>
 <20121214045030.GE6317@cmpxchg.org> <20121214083738.GA6898@dhcp22.suse.cz>
In-Reply-To: <20121214083738.GA6898@dhcp22.suse.cz>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-14_05:2012-12-14,2012-12-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1212140183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 03:37 AM, Michal Hocko wrote:
> On Thu 13-12-12 23:50:30, Johannes Weiner wrote:
>> On Thu, Dec 13, 2012 at 10:25:43PM +0000, Satoru Moriya wrote:
>>>
>>> I introduced swappiness check here with fe35004f because, in some 
>>> cases, we prefer OOM to swap out pages to detect problems as soon as 
>>> possible. Basically, we design the system not to swap out and so if 
>>> it causes swapping, something goes wrong.
>>
>> I might be missing something terribly obvious, but... why do you add 
>> swap space to the system in the first place?  Or in case of cgroups, 
>> why not set the memsw limit equal to the memory limit?
> 
> I can answer the later. Because memsw comes with its price and 
> swappiness is much cheaper. On the other hand it makes sense that
> swappiness==0 doesn't swap at all. Or do you think we should get back 
> to _almost_ doesn't swap at all?
> 

Right. One of the reason is what Michal described above and another
reason that I thought is softlimit. softlimit reclaim always works
with priority=0. Therefore, if we set softlimit to one memcg without
swappiness=0, the kernel scans both anonymous and filebacked pages
during soft limit reclaim for the memcg and reclaims them.

Regards,
Satoru
