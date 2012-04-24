Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab2DXToH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:44:07 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:46818 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332Ab2DXToF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:44:05 -0400
Message-ID: <4F97023F.7070109@linaro.org>
Date: Tue, 24 Apr 2012 12:42:55 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] [RFC] ashmem: Convert ashmem to use volatile ranges
References: <1335289787-11089-1-git-send-email-john.stultz@linaro.org> <1335289787-11089-4-git-send-email-john.stultz@linaro.org> <1335295291.28150.222.camel@twins>
In-Reply-To: <1335295291.28150.222.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042419-5518-0000-0000-000003E40910
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 12:21 PM, Peter Zijlstra wrote:
> On Tue, 2012-04-24 at 10:49 -0700, John Stultz wrote:
>> First pass attempt at getting ashmem to utilize the volatile range
>> code.
> One would think the purpose of the previous patches was to entirely do
> away with the ashmem interface.. this patch is a temporary band-aid to
> assist in testing without having to modify userspace?
>
So in a way, yes. I'm trying to iteratively chip away at the staging 
drivers, providing a smooth transition path. This patch is just to show 
(or determine, depending on if the GET_PIN_STATUS is critical) that the 
fadvise volatile functionality is sufficient to replace the ashmem 
unpinning feature.

Part of the trouble with pushing the Android drivers upstream is that 
each driver doesn't just solve one issue, but usually handles a number 
of problems. Thus discussion about alternative solutions gets muddled as 
no one alternative is sufficient.

For the ashmem driver, one big use case is a way to provide fds to 
anonymous memory that can be shared between processes. This is the same 
as an unlinked tmpfs file, but allows them to not have tmpfs mounts, 
which could potentially be cluttered with poorly written or malicious 
applications.  There is also the feature of being able to unpin memory 
ranges of that fd, which I thought was interesting for wider use.

The fadivse volatile work provides that unpinning feature, but doesn't 
do anything to try to provide atomically unlinked tmpfs fds. To solve 
that problem,  we'll have to revisit if the simplified ashmem interface 
makes sense, or if there should be something like a permissions based 
userspace solution with a deamon that does the create/unlink and hands 
the fds out.  But hopefully that discussion will be more clear, as it 
will be only about one feature.

thanks
-john

