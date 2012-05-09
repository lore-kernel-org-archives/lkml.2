Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab2EIO0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:26:50 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61077 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995Ab2EIO0r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:26:47 -0400
MIME-Version: 1.0
X-Originating-IP: [109.64.13.136]
In-Reply-To: <20120507171725.GB19417@google.com>
References: <1336056962-10465-1-git-send-email-gilad@benyossef.com>
	<1336056962-10465-4-git-send-email-gilad@benyossef.com>
	<20120503153941.GA5528@google.com>
	<CAOtvUMcJurhAKB5pbq91WCsSM7cELNOdUbANzx4gF0Cf8x4cTg@mail.gmail.com>
	<20120507171725.GB19417@google.com>
Date: Wed, 9 May 2012 17:26:46 +0300
Message-ID: <CAOtvUMcrymsv3_sN8mTmAmf1fbJYNq-k4wD4i_wBMuojGiRLRQ@mail.gmail.com>
Subject: Re: [PATCH v1 3/6] workqueue: introduce schedule_on_each_cpu_cond
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Mike Frysinger <vapier@gentoo.org>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Christoph Lameter <cl@linux.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 7, 2012 at 8:17 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Sun, May 06, 2012 at 04:15:30PM +0300, Gilad Ben-Yossef wrote:
>> A single helper function called schedule_on_each_cpu_cond() is very
>> obvious to find to someone reading the source or documentation. On
>> the other hand figuring out that the helper functions that handle
>> cpu hotplug and cpumask allocation are there for that purpose is a
>> bit more involved.
>>
>> That was my thinking at least.
>
> Yeah, having common mechanism is nice, but I just prefer iterators /
> helpers which can be embedded in the caller to interface which takes a
> callback unless the execution context is actually asynchronous to the
> caller.  We don't use nested functions / scopes in kernel which makes
> those callbacks (higher order functions, lambdas, gammas, zetas
> whatever) painful to use and follow.
>
>> The way i see it, I can either obliterate on_each_cpu_cond() and out
>> its code in place in the LRU path, or fix the callback to get an
>> extra private data parameter -
>
> Unless we can code up something pretty, I vote for just open coding it
> for now.  If we grow more usages like this, maybe we'll be able to see
> the pattern better and come up with better abstraction.

Got you. Will do.

Thanks.
Gilad


> --
> tejun



-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
