Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab1LSRe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 12:34:26 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33929 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab1LSReX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 12:34:23 -0500
Message-ID: <4EEF75A0.2080503@gmail.com>
Date: Mon, 19 Dec 2011 12:34:24 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        =?UTF-8?B?QXJ2ZSBIag==?= =?UTF-8?B?w7hubmV2w6Vn?= 
	<arve@android.com>,
        Rik van Riel <riel@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: Android low memory killer vs. memory pressure notifications
References: <20111219025328.GA26249@oksana.dev.rtsoft.ru> <4EEF74AC.1060503@gmail.com>
In-Reply-To: <4EEF74AC.1060503@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> + read_lock(&tasklist_lock);
>
> Crazy inefficient. mere slab shrinker shouldn't take tasklist_lock.
> Imagine if tasks are much plenty...
>
> Moreover, if system have plenty file cache, any process shouldn't killed
> at all! That's fundamental downside of this patch.

In addition, this code is reused a lot of code of oom-killer. But it is 
bad idea. oom killer is really exceptional case. then it don't pay 
attention faster processing. But, no free memory is not rare. we don't 
have much free memory EVERY TIME. because we have file cache.

