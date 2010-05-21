Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab0EUGgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 02:36:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:51779 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab0EUGgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 02:36:36 -0400
Message-ID: <4BF629BB.9000805@kernel.org>
Date: Fri, 21 May 2010 08:35:39 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Oleg Nesterov <oleg@redhat.com>,
       =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
References: <1272429119-12103-1-git-send-email-arve@android.com> <20100430172618.GA9043@redhat.com> <4BF4F31D.8070900@kernel.org> <201005210027.31910.rjw@sisk.pl>
In-Reply-To: <201005210027.31910.rjw@sisk.pl>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 May 2010 06:35:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/21/2010 12:27 AM, Rafael J. Wysocki wrote:
>> Oh, this isn't an issue w/ cmwq.  While frozen all new works are
>> collected into per-cpu delayed worklist and while frozen trustee in
>> charge of the cpu will keep waiting.  Once thawed, trustee will
>> execute all works including the delayed ones unbound to any cpu.
> 
> So, does it require any intrusive changes to make it possible to create
> multithread freezable workqueues?

cmwq itself is quite intrusive changes but w/ cmwq it just takes
flipping a flag when creating the queue.

Thanks.

-- 
tejun
