Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab2BPSnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 13:43:39 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60512 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754254Ab2BPSnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 13:43:37 -0500
Message-ID: <4F3D4E34.9060105@fb.com>
Date: Thu, 16 Feb 2012 10:43:00 -0800
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
References: <1329006098-5454-1-git-send-email-andrea@betterlinux.com> <1329006098-5454-4-git-send-email-andrea@betterlinux.com> <20120215233537.GA20724@dev3310.snc6.facebook.com> <20120215234724.GA21685@thinkpad> <4F3C467B.1@fb.com> <20120216005608.GC21685@thinkpad> <4F3C6594.3030709@fb.com> <20120216103944.GA1440@thinkpad>
In-Reply-To: <20120216103944.GA1440@thinkpad>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.260,0.0.0000
 definitions=2012-02-16_06:2012-02-16,2012-02-16,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/12 2:39 AM, Andrea Righi wrote:

> Arun, thank you very much for your review and testing. Probably we'll
> move to a different, memcg-based solution, so I don't think I'll post
> another version of this patch set as is. In case, I'll apply one of
> the workarounds for the rb_root attribute.

I'm not sure if the proposed memory.file.limit_in_bytes is the right 
interface. Two problems:

* The user is now required to figure out what is the right amount of 
page cache for the app (may change over time)

* If the app touches two sets of files, one with streaming access and 
the other which benefits from page cache (eg: a mapper task in a map 
reduce), memcg doesn't allow the user to specify the access pattern per-fd.

  -Arun

