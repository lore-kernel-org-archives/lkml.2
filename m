Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab0KHW3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:29:15 -0500
Received: from smtp-out.google.com ([216.239.44.51]:22610 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab0KHW3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:29:14 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:references:date:in-reply-to:message-id:
	user-agent:mime-version:content-type;
	b=Wk2lvZQN8nA/Ox9XzeLe6ITF9IcH7GopP2XJiI5q2IUfny97n/TwEIEdccM2xYkyp
	X2wJ0acDmHuio2CWl4Otw==
From: Greg Thelen <gthelen@google.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Andrea Righi <arighi@develer.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/4] memcg: catch negative per-cpu sums in dirty info
References: <1288973333-7891-1-git-send-email-minchan.kim@gmail.com>
	<20101106010357.GD23393@cmpxchg.org>
	<AANLkTin9m65JVKRuStZ1-qhU5_1AY-GcbBRC0TodsfYC@mail.gmail.com>
	<20101107215030.007259800@cmpxchg.org>
	<20101107220353.414283590@cmpxchg.org>
	<AANLkTik4GfMEpE7HaXe93YSy-cTGKjDW1TgKYtOC2wos@mail.gmail.com>
Date: Mon, 08 Nov 2010 14:28:46 -0800
In-Reply-To: <AANLkTik4GfMEpE7HaXe93YSy-cTGKjDW1TgKYtOC2wos@mail.gmail.com>
	(Minchan Kim's message of "Mon, 8 Nov 2010 08:26:29 +0900")
Message-ID: <xr9362w7bgbl.fsf@ninji.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim <minchan.kim@gmail.com> writes:

> On Mon, Nov 8, 2010 at 7:14 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>> Folding the per-cpu counters can yield a negative value in case of
>> accounting races between CPUs.
>>
>> When collecting the dirty info, the code would read those sums into an
>> unsigned variable and then check for it being negative, which can not
>> work.
>>
>> Instead, fold the counters into a signed local variable, make the
>> check, and only then assign it.
>>
>> This way, the function signals correctly when there are insane values
>> instead of leaking them out to the caller.
>>
>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Greg Thelen <gthelen@google.com>
