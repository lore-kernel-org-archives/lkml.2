Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab0KGX0b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 18:26:31 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41275 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab0KGX0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 18:26:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=sb+4B7kh5jrz7lOeQgTNGxEKrY8x/bxs50W9VWgwCMfK3WsWERLx1OBQolHy0MR7WW
         Ql2Sfe8YYtV6xVEyRxsfik7lRQTJypCOpYthMo+2S3ftxq9VIZp2Cubtbtyy8WiVxpkB
         J1SbUFnckqhVhaQBBtd1DFbfxB9AisXNHjJZE=
MIME-Version: 1.0
In-Reply-To: <20101107220353.414283590@cmpxchg.org>
References: <1288973333-7891-1-git-send-email-minchan.kim@gmail.com>
	<20101106010357.GD23393@cmpxchg.org>
	<AANLkTin9m65JVKRuStZ1-qhU5_1AY-GcbBRC0TodsfYC@mail.gmail.com>
	<20101107215030.007259800@cmpxchg.org>
	<20101107220353.414283590@cmpxchg.org>
Date: Mon, 8 Nov 2010 08:26:29 +0900
Message-ID: <AANLkTik4GfMEpE7HaXe93YSy-cTGKjDW1TgKYtOC2wos@mail.gmail.com>
Subject: Re: [patch 2/4] memcg: catch negative per-cpu sums in dirty info
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 8, 2010 at 7:14 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> Folding the per-cpu counters can yield a negative value in case of
> accounting races between CPUs.
>
> When collecting the dirty info, the code would read those sums into an
> unsigned variable and then check for it being negative, which can not
> work.
>
> Instead, fold the counters into a signed local variable, make the
> check, and only then assign it.
>
> This way, the function signals correctly when there are insane values
> instead of leaking them out to the caller.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
