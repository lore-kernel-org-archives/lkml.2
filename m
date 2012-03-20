Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776Ab2CTKAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 06:00:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42672 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab2CTKAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 06:00:49 -0400
MIME-Version: 1.0
In-Reply-To: <1331938267-13583-2-git-send-email-john.stultz@linaro.org>
References: <1331938267-13583-1-git-send-email-john.stultz@linaro.org>
	<1331938267-13583-2-git-send-email-john.stultz@linaro.org>
Date: Tue, 20 Mar 2012 11:00:49 +0100
Message-ID: <CAO6Zf6D_uREG5n=yZ04CicHkYsXQp_Zs1xJX2z6C9tyKrP=+Kg@mail.gmail.com>
Subject: Re: [PATCH 1/2] [RFC] Range tree implementation
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On 16 March 2012 23:51, John Stultz <john.stultz@linaro.org> wrote:
> After Andrew suggested something like his mumbletree idea
> to better store a list of ranges, I worked on a few different
> approaches, and this is what I've finally managed to get working.
>
> I suspect range-tree isn't a totally accurate name, but I
> couldn't quite make out the difference between range trees
> and interval trees, so I just picked one to call it. Do
> let me know if you have a better name.
>
> The idea of storing ranges in a tree is nice, but has a number
> of complications. When adding a range, its possible that a
> large range will consume and merge a number of smaller ranges.

Have you considered using 'prio_tree' (include/linux/prio_tree.h)? If
we aim at addressing a wide range of possible use-cases (different
patterns of adding/removing volatile ranges), then, at first glance,
prio_tree looks like a better approach.

e.g. for the "consume and merge a number of smaller ranges" scenario
above, prio_tree gives O(log n) [ O(log n + m) ] behavior iso O(m log
n) in your case.

--Dmitry
