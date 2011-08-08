Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab1HHLhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 07:37:05 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44333 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab1HHLhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 07:37:03 -0400
MIME-Version: 1.0
In-Reply-To: <20110808110658.31053.55013.stgit@localhost6>
References: <20110808110658.31053.55013.stgit@localhost6>
Date: Mon, 8 Aug 2011 14:37:02 +0300
X-Google-Sender-Auth: XkQzH-7HW2D-pbrddEktTWQwNlk
Message-ID: <CAOJsxLF909NRC2r6RL+hm1ARve+3mA6UM_CY9epJaauyqJTG8w@mail.gmail.com>
Subject: Re: [PATCH 1/2] vmscan: promote shared file mapped pages
From: Pekka Enberg <penberg@kernel.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konstantin,

On Mon, Aug 8, 2011 at 2:06 PM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
> Commit v2.6.33-5448-g6457474 (vmscan: detect mapped file pages used only once)
> greatly decreases lifetime of single-used mapped file pages.
> Unfortunately it also decreases life time of all shared mapped file pages.
> Because after commit v2.6.28-6130-gbf3f3bc (mm: don't mark_page_accessed in fault path)
> page-fault handler does not mark page active or even referenced.
>
> Thus page_check_references() activates file page only if it was used twice while
> it stays in inactive list, meanwhile it activates anon pages after first access.
> Inactive list can be small enough, this way reclaimer can accidentally
> throw away any widely used page if it wasn't used twice in short period.
>
> After this patch page_check_references() also activate file mapped page at first
> inactive list scan if this page is already used multiple times via several ptes.
>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Both patches seem reasonable but the changelogs don't really explain
why you're doing the changes. How did you find out about the problem?
Is there some workload that's affected? How did you test your changes?

                       Pekka
