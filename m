Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585Ab2EIO0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:26:14 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45053 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759495Ab2EIO0L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:26:11 -0400
MIME-Version: 1.0
X-Originating-IP: [109.64.13.136]
In-Reply-To: <alpine.DEB.2.00.1205081033450.27713@router.home>
References: <1336056962-10465-1-git-send-email-gilad@benyossef.com>
	<1336056962-10465-6-git-send-email-gilad@benyossef.com>
	<alpine.DEB.2.00.1205071024550.1060@router.home>
	<4FA823A7.9000801@gmail.com>
	<alpine.DEB.2.00.1205071438240.2215@router.home>
	<CAOtvUMf95gmZ4ZTSpTb+5NZdEiDTg_CPtp3L2_notdz+dZWG6A@mail.gmail.com>
	<alpine.DEB.2.00.1205081033450.27713@router.home>
Date: Wed, 9 May 2012 17:26:08 +0300
Message-ID: <CAOtvUMfGkjTwPX7fk_uBvFyd2EpcoksLJoNET-6Ox6y=JN+LeA@mail.gmail.com>
Subject: Re: [PATCH v1 5/6] mm: make vmstat_update periodic run conditional
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Christoph Lameter <cl@linux.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Mike Frysinger <vapier@gentoo.org>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 6:34 PM, Christoph Lameter <cl@linux.com> wrote:
> On Tue, 8 May 2012, Gilad Ben-Yossef wrote:
>
>> > But this would still mean that the vmstat update thread would run on an
>> > arbitrary cpu. If I have a sacrificial lamb processor for OS processing
>> > then I would expect the vmstat update thread to stick to that processor
>> > and avoid to run on the other processor that I would like to be as free
>> > from OS noise as possible.
>> >
>>
>> OK, what about -
>>
>> - We pick a scapegoat cpu (the first to come up gets the job).
>> - We add a knob to let user designate another cpu for the job.
>> - If scapegoat cpus goes offline, the cpu processing the off lining is
>> the new scapegoat.
>>
>> Does this makes better sense?
>
> Sounds good. The first that comes up. If the cpu is isolated then the
> first non isolated cpu is picked.
>

OK, will do.

Thanks,
Gilad


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
