Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab2JIVbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 17:31:37 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48613 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756952Ab2JIVbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 17:31:33 -0400
Message-ID: <5074975B.20809@linaro.org>
Date: Tue, 09 Oct 2012 14:30:03 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mike Hommey <mh@glandium.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tglek@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/3] Volatile Ranges (v7) & Lots of words
References: <1348888593-23047-1-git-send-email-john.stultz@linaro.org> <20121009080735.GA24375@glandium.org>
In-Reply-To: <20121009080735.GA24375@glandium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12100921-1976-0000-0000-00001233B823
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2012 01:07 AM, Mike Hommey wrote:
> Note it doesn't have to be a vs. situation. madvise could be an
> additional way to interface with volatile ranges on a given fd.
>
> That is, madvise doesn't have to mean anonymous memory. As a matter of
> fact, MADV_WILLNEED/MADV_DONTNEED are usually used on mmaped files.
> Similarly, there could be a way to use madvise to mark volatile ranges,
> without the application having to track what memory ranges are
> associated to what part of what file, which the kernel already tracks.

Good point. We could add madvise() interface, but limit it only to 
mmapped tmpfs files, in parallel with the fallocate() interface.

However, I would like to think through how MADV_MARK_VOLATILE with 
purely anonymous memory could work, before starting that approach. That 
and Neil's point that having an identical kernel interface restricted to 
tmpfs, only as a convenience to userland in switching from virtual 
address to/from mmapped file offset may be better left to a userland 
library.

thanks
-john

