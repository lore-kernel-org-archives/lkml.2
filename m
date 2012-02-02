Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab2BBJm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 04:42:28 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35494 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab2BBJm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 04:42:26 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <1328119072.2446.264.camel@twins>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com>
	<1327591185.2446.102.camel@twins>
	<CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com>
	<1328117722.2446.262.camel@twins>
	<1328119072.2446.264.camel@twins>
Date: Thu, 2 Feb 2012 11:42:25 +0200
Message-ID: <CAOtvUMcXjKFKiy1VQPz7WofFaxZMTTDBo-pKwGhVZerht=KCTg@mail.gmail.com>
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>, paulmck <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 7:57 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-02-01 at 18:35 +0100, Peter Zijlstra wrote:
>> On Sun, 2012-01-29 at 10:25 +0200, Gilad Ben-Yossef wrote:
>> >
>> > If this is of interest, I keep a list tracking global IPI and global
>> > task schedulers sources in the core kernel here:
>> > https://github.com/gby/linux/wiki.
>>
>> You can add synchronize_.*_expedited() to the list, it does its best to
>> bash the entire machine in order to try and make RCU grace periods
>> happen fast.
>
> Also anything using stop_machine, such as module unload, cpu hot-unplug
> and text_poke().

Thanks! I've added it to the list together with the clocksource
watchdog, which is registering
a timer on each cpu in a cyclinc fashion.

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
