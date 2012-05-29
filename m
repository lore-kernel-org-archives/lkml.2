Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab2E2Pr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 11:47:59 -0400
Received: from mx2.parallels.com ([64.131.90.16]:57274 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab2E2Pr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 11:47:58 -0400
Message-ID: <4FC4EF26.30609@parallels.com>
Date: Tue, 29 May 2012 19:45:42 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <devel@openvz.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 05/28] memcg: Reclaim when more than one page needed.
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-6-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290917230.4666@router.home> <alpine.DEB.2.00.1205290919130.4666@router.home>
In-Reply-To: <alpine.DEB.2.00.1205290919130.4666@router.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.255.67.70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 06:20 PM, Christoph Lameter wrote:
> On Tue, 29 May 2012, Christoph Lameter wrote:
>
>>>   	* unlikely to succeed so close to the limit, and we fall back
>>>   	 * to regular pages anyway in case of failure.
>>>   	 */
>>> -	if (nr_pages == 1&&  ret)
>>> +	if (nr_pages<= (PAGE_SIZE<<  PAGE_ALLOC_COSTLY_ORDER)&&  ret) {
>
> Should this not be
>
> 	 nr_pages<= 1<<  PAGE_ALLOC_COSTLY_ORDER

I myself believe you are right.

Not sure if Suleiman had anything in mind that we're not seeing when he 
wrote this code?

