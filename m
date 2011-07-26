Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1GZNxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 09:53:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab1GZNxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 09:53:15 -0400
Message-ID: <4E2EC6C7.3080009@suse.cz>
Date: Tue, 26 Jul 2011 15:53:11 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Nicolas Palix <Nicolas.Palix@inria.fr>
Cc: Greg Dietsche <gregory.dietsche@cuw.edu>, Joe Perches <joe@perches.com>,
        julia@diku.dk, Gilles.Muller@lip6.fr, rdunlap@xenotime.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cocci@diku.dk
Subject: Re: [PATCH 3/3] coccicheck: add parallel execution
References: <1310520405-1558-1-git-send-email-Gregory.Dietsche@cuw.edu> <1310520405-1558-4-git-send-email-Gregory.Dietsche@cuw.edu> <1310524935.32558.8.camel@Joe-Laptop> <4E1E510A.6010005@cuw.edu> <CAAxaTiNJNXnn3PAcKWBSZ2wbMKBDD9yL6pyediEEBHnjNH-uaA@mail.gmail.com>
In-Reply-To: <CAAxaTiNJNXnn3PAcKWBSZ2wbMKBDD9yL6pyediEEBHnjNH-uaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.7.2011 15:33, Nicolas Palix wrote:
> Hi,
>
> On Thu, Jul 14, 2011 at 4:14 AM, Greg Dietsche<gregory.dietsche@cuw.edu>  wrote:
>> On 07/12/2011 09:42 PM, Joe Perches wrote:
>>>
>>> On Tue, 2011-07-12 at 20:26 -0500, Greg Dietsche wrote:
>>>
>>>>
>>>> For example to process 6 SmPL patches at the same time:
>>>>         make coccicheck PARALLEL=6
>>>> Results are held in /tmp until the scripts finish. By doing this the
>>>> script is able to collate the results from each SmPL patch instead of
>>>> interleaving them in the output.

Why not move the loop into some Makefile and let make take care of the 
parallel execution? Something among the lines of

results := check1.out check2.out ... (generated)
coccicheck: $(results)
	cat $^

%.out: FORCE
	... run given test and store its result ...

then the user can simply type make -j6 coccicheck.

Note: I haven't seen the patch, I only got Nicolas' mail now.

Michal
