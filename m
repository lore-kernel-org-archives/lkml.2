Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0ETIcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 04:32:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:56403 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915Ab0ETIcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 04:32:15 -0400
Message-ID: <4BF4F31D.8070900@kernel.org>
Date: Thu, 20 May 2010 10:30:21 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5?= =?ISO-8859-1?Q?g?= 
	<arve@android.com>,
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
References: <1272429119-12103-1-git-send-email-arve@android.com> <201004282250.44200.rjw@sisk.pl> <l2yd6200be21004282037rc063266by91db7f732ceaa529@mail.gmail.com> <201004292316.14524.rjw@sisk.pl> <4BDA5B8B.50004@kernel.org> <20100430172618.GA9043@redhat.com>
In-Reply-To: <20100430172618.GA9043@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 20 May 2010 08:30:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(sorry about late reply)

On 04/30/2010 07:26 PM, Oleg Nesterov wrote:
> Currently _cpu_down() can't flush and/or stop the frozen cwq->thread.
> 
> IIRC this is fixable, but needs the nasty complications. We should
> thaw + stop the frozen cwq->thread, then move the pending works to
> another CPU.

Oh, this isn't an issue w/ cmwq.  While frozen all new works are
collected into per-cpu delayed worklist and while frozen trustee in
charge of the cpu will keep waiting.  Once thawed, trustee will
execute all works including the delayed ones unbound to any cpu.

Thanks.

-- 
tejun
