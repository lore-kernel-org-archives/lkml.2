Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab1GZNdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 09:33:15 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39416 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1GZNdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 09:33:07 -0400
MIME-Version: 1.0
In-Reply-To: <4E1E510A.6010005@cuw.edu>
References: <1310520405-1558-1-git-send-email-Gregory.Dietsche@cuw.edu>
	<1310520405-1558-4-git-send-email-Gregory.Dietsche@cuw.edu>
	<1310524935.32558.8.camel@Joe-Laptop>
	<4E1E510A.6010005@cuw.edu>
Date: Tue, 26 Jul 2011 15:33:05 +0200
X-Google-Sender-Auth: uFfK9YrH6bKWerTauUaNlxGaDwg
Message-ID: <CAAxaTiNJNXnn3PAcKWBSZ2wbMKBDD9yL6pyediEEBHnjNH-uaA@mail.gmail.com>
Subject: Re: [PATCH 3/3] coccicheck: add parallel execution
From: Nicolas Palix <Nicolas.Palix@inria.fr>
To: Greg Dietsche <gregory.dietsche@cuw.edu>
Cc: Joe Perches <joe@perches.com>, julia@diku.dk, Gilles.Muller@lip6.fr,
        rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk,
        Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 14, 2011 at 4:14 AM, Greg Dietsche <gregory.dietsche@cuw.edu> wrote:
> On 07/12/2011 09:42 PM, Joe Perches wrote:
>>
>> On Tue, 2011-07-12 at 20:26 -0500, Greg Dietsche wrote:
>>
>>>
>>> For example to process 6 SmPL patches at the same time:
>>>        make coccicheck PARALLEL=6
>>> Results are held in /tmp until the scripts finish. By doing this the
>>> script is able to collate the results from each SmPL patch instead of
>>> interleaving them in the output.

On my system, when killing the make task, the cleanup function only
kills the first level of
children processes (shell processes) thus living spatch running, both
the frontend script and the actual code.

Could you resubmit a patch with "pkill -P $$" replaced by  "pkill -s 0"
to kill all related processes ?

That is the only problem I notice. I will thus acked your patch.
Keep Michal in CC for your resubmission as he will commit
your patch.

>>>
>>
>> You might try adding support for gnu parallel instead.
>> http://www.gnu.org/software/parallel/
>>
>>
>
> That is a very interesting and useful tool :) I'd never heard of it before.
> The man page scares me a little bit - lots of options are marked as "alpha
> testing," but the ones i tried seemed to work fine. Anyway, without any
> modifications to Coccinelle, it is possible to do this:
>
> ls scripts/coccinelle/*/*.cocci | parallel -j+0 make coccicheck COCCI={}
> MODE=patch

Maybe that alternative could be added to the documentation ?

>
> it seems to behave mostly like my patch, but doesn't cleanup quite as well
> if you decide to kill it with ctrl-c (it leaves instances of spatch
> running). On the upside, it is up to 3 seconds faster than my patch (because
> my patch waits 3 seconds before checking on the number of jobs that are
> running).
>
> Greg
>



-- 
Nicolas Palix
http://sardes.inrialpes.fr/~npalix/
