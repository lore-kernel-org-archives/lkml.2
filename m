Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab2KBU7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 16:59:38 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46791 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab2KBU72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 16:59:28 -0400
MIME-Version: 1.0
In-Reply-To: <506B6CE0.1060800@linaro.org>
References: <1348888593-23047-1-git-send-email-john.stultz@linaro.org>
 <20121002173928.2062004e@notabene.brown> <506B6CE0.1060800@linaro.org>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Fri, 2 Nov 2012 21:59:07 +0100
X-Google-Sender-Auth: 2Vl-W_VoN2d6mfariwlWRPeCKAs
Message-ID: <CAHO5Pa0KvH+MTYm6BCM5LHj995HpO+t87szyJjjXgupVq2VTfA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Volatile Ranges (v7) & Lots of words
To: John Stultz <john.stultz@linaro.org>
Cc: NeilBrown <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John,

A question at on one point:

On Wed, Oct 3, 2012 at 12:38 AM, John Stultz <john.stultz@linaro.org> wrote:
> On 10/02/2012 12:39 AM, NeilBrown wrote:
[...]
>>   The SIGBUS interface could have some merit if it really reduces
>> overhead.  I
>>   worry about app bugs that could result from the non-deterministic
>>   behaviour.   A range could get unmapped while it is in use and testing
>> for
>>   the case of "get a SIGBUS half way though accessing something" would not
>>   be straight forward (SIGBUS on first step of access should be easy).
>>   I guess that is up to the app writer, but I have never liked anything
>> about
>>   the signal interface and encouraging further use doesn't feel wise.
>
> Initially I didn't like the idea, but have warmed considerably to it. Mainly
> due to the concern that the constant unmark/access/mark pattern would be too
> much overhead, and having a lazy method will be much nicer for performance.
> But yes, at the cost of additional complexity of handling the signal,
> marking the faulted address range as non-volatile, restoring the data and
> continuing.

At a finer level of detail, how do you see this as happening in the
application. I mean: in the general case, repopulating the purged
volatile page would have to be done outside the signal handler (I
think, because async-signal-safety considerations would preclude too
much compdex stuff going on inside the handler). That implies
longjumping out of the handler, repopulating the pages with data, and
then restarting whatever work was being done when the SIGBUS was
generated.

Cheers,

Michael
