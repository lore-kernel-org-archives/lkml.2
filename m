Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab1GZWqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 18:46:37 -0400
Received: from mta21.charter.net ([216.33.127.81]:41470 "EHLO
	mta21.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab1GZWqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 18:46:35 -0400
X-Authority-Analysis: v=1.1 cv=G6Q69DB3AUoJKS2BpLRaz8MQ2NORN7h5HRzrJMPOhRw=
 c=1 sm=1 a=7Da5kHvgTEoA:10 a=0qEacxHv6EQA:10 a=0xc6OLWX_2kA:10
 a=IkcTkHD0fZMA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=BFj-WmzUx72jkahi2NQA:9
 a=QEXdDO2ut3YA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4E2F43C8.8080805@gregd.org>
Date: Tue, 26 Jul 2011 17:46:32 -0500
From: Greg Dietsche <greg@gregd.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Nicolas Palix <Nicolas.Palix@inria.fr>,
        Greg Dietsche <gregory.dietsche@cuw.edu>,
        Joe Perches <joe@perches.com>, julia@diku.dk, Gilles.Muller@lip6.fr,
        rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk
Subject: Re: [PATCH 3/3] coccicheck: add parallel execution
References: <1310520405-1558-1-git-send-email-Gregory.Dietsche@cuw.edu> <1310520405-1558-4-git-send-email-Gregory.Dietsche@cuw.edu> <1310524935.32558.8.camel@Joe-Laptop> <4E1E510A.6010005@cuw.edu> <CAAxaTiNJNXnn3PAcKWBSZ2wbMKBDD9yL6pyediEEBHnjNH-uaA@mail.gmail.com> <4E2EC6C7.3080009@suse.cz>
In-Reply-To: <4E2EC6C7.3080009@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/26/2011 8:53 AM, Michal Marek wrote:
> Why not move the loop into some Makefile and let make take care of the 
> parallel execution? Something among the lines of
>
> results := check1.out check2.out ... (generated)
> coccicheck: $(results)
>     cat $^
>
> %.out: FORCE
>     ... run given test and store its result ...
>
> then the user can simply type make -j6 coccicheck.
>
> Note: I haven't seen the patch, I only got Nicolas' mail now.
>
> Michal
>

yes, I agree, that would be better - especially from a user perspective.
I'm not much of a makefile expert at all. I did try that approach 
initially, but it seemed like it was going to turn into a rewrite of the 
coccinelle script. If someone can do it via make, I'd say go for it :)  
I won't have much free time for the foreseeable future to tackle it. 
using "make -j" is much more comfortable and intuitive than typing 
PARALLEL= ...

Greg
