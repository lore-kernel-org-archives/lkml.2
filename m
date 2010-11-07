Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab0KGW4q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 17:56:46 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49807 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab0KGW4o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 17:56:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FVVdei14kPBmVJWFO44aPjBSvJFjs3ZAFvWerNJVKPys/sPi+9+8mbSf/grLM+qEht
         AIGaiW2585pCaJPXmtQcWzhRPL4dMVMj1dUxgxKF/bapS0rsokdJMgCMbX5DfczrV9En
         IBUXXXyi6SC17vUGYBVW/kKgHJl8hwn1KToxs=
MIME-Version: 1.0
In-Reply-To: <20101107220353.115646194@cmpxchg.org>
References: <1288973333-7891-1-git-send-email-minchan.kim@gmail.com>
	<20101106010357.GD23393@cmpxchg.org>
	<AANLkTin9m65JVKRuStZ1-qhU5_1AY-GcbBRC0TodsfYC@mail.gmail.com>
	<20101107215030.007259800@cmpxchg.org>
	<20101107220353.115646194@cmpxchg.org>
Date: Mon, 8 Nov 2010 07:56:43 +0900
Message-ID: <AANLkTi=qO84k-KWaG2R_nQr7vxRA2E7DbO4=XhVrFzjv@mail.gmail.com>
Subject: Re: [patch 1/4] memcg: use native word to represent dirtyable pages
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
> The memory cgroup dirty info calculation currently uses a signed
> 64-bit type to represent the amount of dirtyable memory in pages.
>
> This can instead be changed to an unsigned word, which will allow the
> formula to function correctly with up to 160G of LRU pages on a 32-bit
> system, assuming 4k pages.  That should be plenty even when taking
> racy folding of the per-cpu counters into account.
>
> This fixes a compilation error on 32-bit systems as this code tries to
> do 64-bit division.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Reported-by: Dave Young <hidave.darkstar@gmail.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
