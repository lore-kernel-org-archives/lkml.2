Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385Ab0D3RF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:05:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:60359 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758356Ab0D3RFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:05:47 -0400
Message-ID: <4BDA5B8B.50004@kernel.org>
Date: Fri, 30 Apr 2010 06:24:43 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Oleg Nesterov <oleg@redhat.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
References: <1272429119-12103-1-git-send-email-arve@android.com> <201004282250.44200.rjw@sisk.pl> <l2yd6200be21004282037rc063266by91db7f732ceaa529@mail.gmail.com> <201004292316.14524.rjw@sisk.pl>
In-Reply-To: <201004292316.14524.rjw@sisk.pl>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 30 Apr 2010 04:24:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/29/2010 11:16 PM, Rafael J. Wysocki wrote:
>>> Also, we already have one PM workqueue.  It is used for runtime PM, but I guess
>>> it may be used just as well for the opportunistic suspend.  It is freezable,
>>> but would it hurt?
>>
>> No, it works, the freezable flag is just ignored when I call
>> pm_suspend and I don't run anything else on the workqueue while
>> threads are frozen. It does need to be a single threaded workqueue
>> though, so make sure you don't just change that.
> 
> Freezable workqueues have to be singlethread or else there will be unfixable
> races, so you can safely assume things will stay as they are in this respect.

Rafael, can you elaborate a bit more on this?  Just in case I missed
something while doing cmwq as it currently doesn't have such limit.

Thanks.

-- 
tejun
