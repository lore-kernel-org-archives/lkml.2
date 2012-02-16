Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab2BPTIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:08:16 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52916 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752014Ab2BPTIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:08:13 -0500
Message-ID: <4F3D53F9.8040508@fb.com>
Date: Thu, 16 Feb 2012 11:07:37 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Andrea Righi <andrea@betterlinux.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shaohua Li <shaohua.li@intel.com>,
        =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>,
        John Stultz <john.stultz@linaro.org>,
        Jerry James <jamesjer@betterlinux.com>,
        Julius Plenz <julius@plenz.com>, linux-mm <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3/3] fadvise: implement POSIX_FADV_NOREUSE
References: <1329006098-5454-1-git-send-email-andrea@betterlinux.com> <1329006098-5454-4-git-send-email-andrea@betterlinux.com> <20120215233537.GA20724@dev3310.snc6.facebook.com> <20120215234724.GA21685@thinkpad> <4F3C467B.1@fb.com> <20120216005608.GC21685@thinkpad> <4F3C6594.3030709@fb.com> <20120216103944.GA1440@thinkpad> <4F3D4E34.9060105@fb.com> <20120216185753.GD13354@thinkpad>
In-Reply-To: <20120216185753.GD13354@thinkpad>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.260,0.0.0000
 definitions=2012-02-16_06:2012-02-16,2012-02-16,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/12 10:57 AM, Andrea Righi wrote:

> Maybe we should try to push ...something... in the memcg code for the
> short-term future, make it as much generic as possible, and for the
> long-term try to reuse the same feature (totally or in part) in the
> per-fd approach via fadvise().

Yes - the two approaches are complementary and we should probably pursue 
both.

There are a number of apps which are already using fadvise though:

https://issues.apache.org/jira/browse/MAPREDUCE-3289
http://highscalability.com/blog/2012/1/12/peregrine-a-map-reduce-framework-for-iterative-and-pipelined.html

and probably many other similar cases that are not open source.

Some of these apps may be better off using NOREUSE instead of DONTNEED, 
since they may not have a clue on what else is going on in the system.

The way I think about it: NOREUSE is a statement about what my process 
is doing and DONTNEED is a statement about the entire system.

  -Arun
