Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934174Ab0EDUkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:40:32 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50874 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab0EDUka convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:40:30 -0400
MIME-Version: 1.0
In-Reply-To: <20100504051256.GC3043@thegnar.org>
References: <1272667021-21312-1-git-send-email-arve@android.com>
	 <1272667021-21312-2-git-send-email-arve@android.com>
	 <20100504051256.GC3043@thegnar.org>
Date: Tue, 4 May 2010 13:40:27 -0700
Message-ID: <n2ud6200be21005041340x32141eaem328765be77223cdd@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: markgross@thegnar.org
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
       Magnus Damm <damm@igel.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/3 mark gross <640e9920@gmail.com>:
> On Fri, Apr 30, 2010 at 03:36:54PM -0700, Arve Hjønnevåg wrote:
...
>> +When the policy is "opportunisic", there is a special value, "on", that can be
>> +written to /sys/power/state. This will block the automatic sleep request, as if
>> +a suspend blocker was used by a device driver. This way the opportunistic
>> +suspend may be blocked by user space whithout switching back to the "forced"
>> +mode.
>
> You know things would be so much easier if the policy was a one-shot
> styled thing.  i.e. when enabled it does what it does, but upon resume
> the policy must be re-enabled by user mode to get the opportunistic
> behavior.  That way we don't need to grab the suspend blocker from the
> wake up irq handler all the way up to user mode as the example below
> calls out.  I suppose doing this would put a burden on the user mode code
> to keep track of if it has no pending blockers registered after a wake
> up from the suspend.  but that seems nicer to me than sprinkling
> overlapping blocker critical sections from the mettle up to user mode.
>
> Please consider making the policy a one shot API that needs to be
> re-enabled after resume by user mode.  That would remove my issue with
> the design.
>

Making it one shot does not change where kernel code needs to block
suspend, but it does force user space to poll trying to suspend while
suspend is blocked by a driver.

-- 
Arve Hjønnevåg
