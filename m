Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab2DGIOR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 04:14:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40434 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2DGIOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 04:14:14 -0400
MIME-Version: 1.0
In-Reply-To: <1333757338-6854-1-git-send-email-john.stultz@linaro.org>
References: <1333757338-6854-1-git-send-email-john.stultz@linaro.org>
Date: Sat, 7 Apr 2012 10:14:13 +0200
Message-ID: <CAO6Zf6C618gt4uLaw=MYgAq519d3UrW7zLf78Q1HOryxzRpkKA@mail.gmail.com>
Subject: Re: [PATCH 0/2] [RFC] Volatile Ranges (v6)
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

On 7 April 2012 02:08, John Stultz <john.stultz@linaro.org> wrote:
>
> Another detail is that by hanging the volatile ranges off of the
> address_space, the volatility for tmpfs files persists even when no one
> has an open fd on the file. This could cause some surprises if application
> A marked some pages volatile and died, then application B opened the file
> and had pages dropped out underneith it while it was being used. I suspect
> I need to clean up the volatility when all fds are dropped.

And how do you handle the regions that have already been purged by
this moment? Unless B has some specific mechanism to verify the
consistency of the content, a sensible way would be to always mark off
the regions as non-volatile before accessing them and verify the
return code to see if there are holes.

More generally, what if B opens the file while A is still working with
it? Besides the use of normal synchronization mechanisms, B should not
make any assumption on the current state of the regions (unless there
is a high-level protocol between A and B to share this info). So an
explicit mark-off-as-non_volatile could be a simple generic mechanism.

--Dmitry
