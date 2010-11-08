Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab0KHXVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:21:14 -0500
Received: from smtp-out.google.com ([216.239.44.51]:50025 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab0KHXVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:21:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:references:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding;
	b=j+2Zlf0zwhVK7REhQm/aLRKrlCYr2t0DwYPlOcAORXCRqieEDkZfnFvUkTJQsFpnQ
	iXOSxnE+261hOuVA2I2Lw==
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
Subject: Re: [patch 3/4] memcg: break out event counters from other stats
References: <1288973333-7891-1-git-send-email-minchan.kim@gmail.com>
	<20101106010357.GD23393@cmpxchg.org>
	<AANLkTin9m65JVKRuStZ1-qhU5_1AY-GcbBRC0TodsfYC@mail.gmail.com>
	<20101107215030.007259800@cmpxchg.org>
	<20101107220353.684449249@cmpxchg.org>
	<AANLkTikhX+2E5o=vqc6Yb6GGPJJT2FwuzKMiC31GdY0s@mail.gmail.com>
Date: Mon, 08 Nov 2010 15:20:38 -0800
Message-ID: <xr93hbfr9zcp.fsf@ninji.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim <minchan.kim@gmail.com> writes:

> On Mon, Nov 8, 2010 at 7:14 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>> For increasing and decreasing per-cpu cgroup usage counters it makes
>> sense to use signed types, as single per-cpu values might go negative
>> during updates.  But this is not the case for only-ever-increasing
>> event counters.
>>
>> All the counters have been signed 64-bit so far, which was enough to
>> count events even with the sign bit wasted.
>>
>> The next patch narrows the usage counters type (on 32-bit CPUs, that
>> is), though, so break out the event counters and make them unsigned
>> words as they should have been from the start.
>>
>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Greg Thelen <gthelen@google.com>
