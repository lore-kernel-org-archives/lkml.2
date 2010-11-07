Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab0KGXwn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 18:52:43 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49126 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab0KGXwm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 18:52:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Nob05W2iE4jIAiTfPdEEzYzQV3hjs8VztUafUv93vZfj8r19Kew2QIg39lbEc/tCFv
         EiRPmB3EtmZq4Y1yebEzuoQSV02X2+f3CwvwBbJ/GIRoKVwGgkgfg+4nCKG3bR7ahyk1
         OLqBfCCrDipaFMobAoqPS3FClkIAu41snowyQ=
MIME-Version: 1.0
In-Reply-To: <20101107220353.684449249@cmpxchg.org>
References: <1288973333-7891-1-git-send-email-minchan.kim@gmail.com>
	<20101106010357.GD23393@cmpxchg.org>
	<AANLkTin9m65JVKRuStZ1-qhU5_1AY-GcbBRC0TodsfYC@mail.gmail.com>
	<20101107215030.007259800@cmpxchg.org>
	<20101107220353.684449249@cmpxchg.org>
Date: Mon, 8 Nov 2010 08:52:41 +0900
Message-ID: <AANLkTikhX+2E5o=vqc6Yb6GGPJJT2FwuzKMiC31GdY0s@mail.gmail.com>
Subject: Re: [patch 3/4] memcg: break out event counters from other stats
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Andrea Righi <arighi@develer.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 8, 2010 at 7:14 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> For increasing and decreasing per-cpu cgroup usage counters it makes
> sense to use signed types, as single per-cpu values might go negative
> during updates.  But this is not the case for only-ever-increasing
> event counters.
>
> All the counters have been signed 64-bit so far, which was enough to
> count events even with the sign bit wasted.
>
> The next patch narrows the usage counters type (on 32-bit CPUs, that
> is), though, so break out the event counters and make them unsigned
> words as they should have been from the start.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Fair enough.
We already have used unsigned long in vmstat.

-- 
Kind regards,
Minchan Kim
