Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab1JMEf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 00:35:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab1JMEfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 00:35:55 -0400
Message-ID: <4E966564.5030902@redhat.com>
Date: Thu, 13 Oct 2011 00:13:24 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Satoru Moriya <satoru.moriya@hds.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: Re: [PATCH -v2 -mm] add extra free kbytes tunable
References: <20110901105208.3849a8ff@annuminas.surriel.com> <20110901100650.6d884589.rdunlap@xenotime.net> <20110901152650.7a63cb8b@annuminas.surriel.com> <alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com> <65795E11DBF1E645A09CEC7EAEE94B9CB516CBBC@USINDEVS02.corp.hds.com> <alpine.DEB.2.00.1110111343070.29761@chino.kir.corp.google.com> <4E959292.9060301@redhat.com> <alpine.DEB.2.00.1110121316590.7646@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1110121316590.7646@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 04:21 PM, David Rientjes wrote:
> On Wed, 12 Oct 2011, Rik van Riel wrote:
>
>> How would this scheme work?
>>
>
> I suggested a patch from BFS that would raise kswapd to the same priority
> of the task that triggered it (not completely up to rt, but the highest
> possible in that case) and I'm waiting to hear if that helps for Satoru's
> test case before looking at alternatives.  We could also extend the patch
> to raise the priority of an already running kswapd if a higher priority
> task calls into the page allocator's slowpath.

This has the distinct benefit of making kswapd most active right
at the same time the application is most active, which returns
us to your first objection to the extra free kbytes patch (apps
will suffer from kswapd cpu use).

Furthermore, I am not sure that giving kswapd more CPU time is
going to help, because kswapd could be stuck on some lock, held
by a lower priority (or sleeping) context.

I agree that the BFS patch would be worth a try, and would be
very pleasantly surprised if it worked, but I am not very
optimistic about it...

-- 
All rights reversed
