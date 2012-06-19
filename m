Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2FSIsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:48:31 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56868 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab2FSIs3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:48:29 -0400
MIME-Version: 1.0
In-Reply-To: <1339435331.31548.19.camel@twins>
References: <1337857490.7300.19.camel@marge.simpson.net> <1337865431.9783.148.camel@laptop>
 <1338906621.6110.30.camel@marge.simpson.net> <1339433835.7358.30.camel@marge.simpson.net>
 <1339435331.31548.19.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Tue, 19 Jun 2012 01:47:57 -0700
Message-ID: <CAPM31RLQRa6z4H6oXOC=2xFSH=X9ACpyKRt5zm=wpKXY4c5MjQ@mail.gmail.com>
Subject: Re: [patch v3] sched: fix select_idle_sibling() induced bouncing
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>, lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan Van De Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 10:22 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2012-06-11 at 18:57 +0200, Mike Galbraith wrote:
>
>> Traversing an entire package is not only expensive, it also leads to tasks
>> bouncing all over a partially idle and possible quite large package.  Fix
>> that up by assigning a 'buddy' CPU to try to motivate.  Each buddy may try
>> to motivate that one other CPU, if it's busy, tough, it may then try it's
>> SMT sibling, but that's all this optimization is allowed to cost.
>>
>> Sibling cache buddies are cross-wired to prevent bouncing.
>>
>> Signed-off-by: Mike Galbraith <efault@gmx.de>
>
> The patch could do with a little comment on how you achieve the
> cross-wiring because staring at the code I go cross-eyed again ;-)
>
> Anyway, I think I'll grab it since nobody seems to have any objections
> and the numbers seem good.
>
> PJT any progress on your load-tracking stuff? Arjan is interested in the
> avg runtime estimation it has to make the whole wake an idle thing
> conditional on.

I'm still pretty much completely clobbered with internal stuff :( but
it's on my agenda to put some cycles towards this week (and weekend).
I'll say by Monday/Tuesday with a hopefully by-Friday.

We've gotten a lot of of test hours on it internally so I'm
comfortable posting a non-RFC mergable series.

- Paul
