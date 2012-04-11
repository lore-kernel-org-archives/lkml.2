Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965Ab2DKTE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:04:27 -0400
Received: from mx2.parallels.com ([64.131.90.16]:41406 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760903Ab2DKTEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:04:25 -0400
Message-ID: <4F85D53B.1070806@parallels.com>
Date: Wed, 11 Apr 2012 16:02:19 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Michal Hocko <mhocko@suse.cz>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>, <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        "Johannes Weiner" <hannes@cmpxchg.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] remove BUG() in possible but rare condition
References: <1334167824-19142-1-git-send-email-glommer@parallels.com> <20120411184845.GA24831@tiehlicka.suse.cz> <CA+55aFx1GMWGgh0sTAzvvVSzPQsQ_4NKeaNv1zpKrP4fg1dG+Q@mail.gmail.com>
In-Reply-To: <CA+55aFx1GMWGgh0sTAzvvVSzPQsQ_4NKeaNv1zpKrP4fg1dG+Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.19.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 03:57 PM, Linus Torvalds wrote:
> On Wed, Apr 11, 2012 at 11:48 AM, Michal Hocko<mhocko@suse.cz>  wrote:
>>
>> I am not familiar with the code much but a trivial call chain walk up to
>> write_dev_supers (in btrfs) shows that we do not check for the return value
>> from __getblk so we would nullptr and there might be more.
>> I guess these need some treat before the BUG might be removed, right?
>
> Well, realistically, isn't BUG() as bad as a NULL pointer dereference?
>
> Do you care about the exact message on the screen when your machine dies?
Not particular, but I don't see why (I might be wrong) it would 
necessarily lead to a NULL pointer dereference.

At least in my test cases, after turning this to a WARN (to make sure it 
was still being hit), the machine could go on just fine.

I was running this in a container system, with restricted memory. After
killing the container - at least in my ext4 system - everything seemed 
as happy as ever.

