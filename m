Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab3AJHS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 02:18:26 -0500
Received: from mx2.parallels.com ([64.131.90.16]:40280 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932211Ab3AJHSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 02:18:25 -0500
Message-ID: <50EE6B41.8030205@parallels.com>
Date: Thu, 10 Jan 2013 11:18:25 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>,
        "Pekka Enberg" <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Luiz Capitulino" <lcapitulino@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        "Leonid Moiseichuk" <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        "Bartlomiej Zolnierkiewicz" <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        <patches@linaro.org>, <kernel-team@android.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] Add mempressure cgroup
References: <20130104082751.GA22227@lizard.gateway.2wire.net> <1357288152-23625-1-git-send-email-anton.vorontsov@linaro.org> <20130109203731.GA20454@htj.dyndns.org> <50EDDF1E.6010705@parallels.com> <20130109213604.GA9475@lizard.fhda.edu> <20130109215514.GD20454@htj.dyndns.org> <20130109220641.GA12865@lizard.fhda.edu>
In-Reply-To: <20130109220641.GA12865@lizard.fhda.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 02:06 AM, Anton Vorontsov wrote:
> On Wed, Jan 09, 2013 at 01:55:14PM -0800, Tejun Heo wrote:
> [...]
>>> We can use mempressure w/o memcg, and even then it can (or should :) be
>>> useful (for cpuset, for example).
>>
>> The problem is that you end with, at the very least, duplicate
>> hierarchical accounting mechanisms which overlap with each other
>> while, most likely, being slightly different.  About the same thing
>> happened with cpu and cpuacct controllers and we're now trying to
>> deprecate the latter.
> 
> Yeah. I started answering your comments about hierarchical accounting,
> looked into the memcg code, and realized that *this* is where I need the
> memcg stuff. :)
> 
> Thus yes, I guess I'll have to integrate it with memcg, or sort of.
> 

That being my point since the beginning. To generate per-memcg pressure,
you need memcg anyway. So you would have to have two different and
orthogonal mechanisms, and therefore, double account.


