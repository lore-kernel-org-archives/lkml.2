Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab2D3VHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 17:07:53 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40156 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581Ab2D3VHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 17:07:52 -0400
Message-ID: <4F9EFF04.4040308@linaro.org>
Date: Mon, 30 Apr 2012 14:07:16 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE
 flags
References: <1335289787-11089-1-git-send-email-john.stultz@linaro.org> <1335289787-11089-3-git-send-email-john.stultz@linaro.org> <20120427003953.GC9541@dastard> <4F9ABA74.8040404@linux.vnet.ibm.com> <20120428013628.GJ9541@dastard>
In-Reply-To: <20120428013628.GJ9541@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12043021-9360-0000-0000-000005E33D84
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 06:36 PM, Dave Chinner wrote:
> That's my concern - that persistent filesystems will have different
> behaviour to in-memory filesystems. They *must* be consistent in
> behaviour w.r.t. to stale data exposure, otherwise we are in a world
> of pain when applications start to use this. Quite frankly, I don't
> care about performance of VOLATILE ranges, but I care greatly
> about ensuring filesystems don't expose stale data to user
> applications....
>
I think we're in agreement with the rest of this email, but I do want to 
stress that the performance of volatile ranges will become more 
ciritical, as in order for folks to effectively use them, they need to 
be able to mark and unmark ranges any time they're not using the data.

No application likely wants their data to be purged, but by volunteering 
it allows them to help the kernel with low-memory constraints and 
improve entire system behavior.

So if the overhead is too great for marking and unmarking pages, 
applications will be less likely to "help out".  :)

thanks
-john

