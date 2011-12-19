Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab1LSRx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 12:53:57 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:51885 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab1LSRxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 12:53:53 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        linux-x86_64@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH] cpu idle ticks show twice in xen pvm guest
References: <ce19ea02-45e6-465a-a4c8-b5d74bf8c2ad@default>
	<20111010155319.GA29140@phenom.oracle.com> <4E934EC9.5030909@goop.org>
	<87vcppbvc4.fsf@tac.ki.iif.hu>
	<20111217214626.GA17841@phenom.dumpdata.com>
Date: Mon, 19 Dec 2011 18:53:38 +0100
In-Reply-To: <20111217214626.GA17841@phenom.dumpdata.com> (Konrad Rzeszutek
	Wilk's message of "Sat, 17 Dec 2011 16:46:26 -0500")
Message-ID: <878vm8bg7x.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:

> On Fri, Dec 09, 2011 at 04:47:39PM +0100, Ferenc Wagner wrote:
>
>> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>> 
>>>> On Wed, Oct 05, 2011 at 10:11:58PM -0700, Zhenzhong Duan wrote:
>>>>
>>>>> Run below test on xen pvm.
>>>>> # x=$(cat /proc/stat | grep cpu0 | awk '{print $5}') && sleep 60  \
>>>>> && y=$(cat /proc/stat | grep cpu0 | awk '{print $5}') \
>>>>> && echo -e  "X:$x\nY:$y\nIDLE:" $(echo "scale=3; ($y-$x)/6000*100" | bc)
>>>>>
>>>>> @ X:58562301
>>>>> @ Y:58574282
>>>>> @ IDLE: 199.600
>>>>>
>>>>> Normal idle percent should be around 100%.
>>>>> xen_timer_interrupt called account_idle_ticks to account hypervisor stolen idle ticks 
>>>>> but these ticks will be accounted again when idle ticks restarted.
>>>>>
>>>>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
>>>>> Signed-off-by: Joe Jin <joe.jin@oracle.com>
>>>
>>> Does this affect the accounting of stolen ticks?  If it does, that's not
>>> necessarily a showstopper for this patch, but we'll need to do some more
>>> thinking about it.  Certainly, accurate accounting for idleness is
>>> important.
>> 
>> Please see also http://thread.gmane.org/gmane.linux.kernel/734441, where
>> I found that the counter doubling isn't always present under 2.6.26.
>> However, after going to 2.6.32 (Debian lenny-backports kernel, 4th of
>> April on the graph below) that instability seems to disappear.  Please
>> note that the following graph shows halved idle and iowait percentages.
>
> What happenend in Feb?

Probably a live migration or a reboot, I can't remember.  See
http://article.gmane.org/gmane.comp.emulators.xen.devel/57771, where I
described a very similar occurence in detail.

>> (I haven't collected steal values, so the numbers don't sum up to 100%.)
>> I'd be grateful if this discrepancy could be cleared up eventually!
>> It's heartening to see some progress after more than three years. :)
>> 
>> Actually, as Munin doesn't half the idle and iowait values, but
>> truncates the (then overflowing) graph at 100%, I was rather surprised
>> to see iowait completely disappear after the kernel upgrade, and
>> concluded that it was somehow converted into buggy-looping in blkfront.
>> Now I see this isn't the case, but the steadily increasing system CPU
>> usage between reboots is still a mystery.  I'll start a separate thread
>> for that, just wanted to provide some motivation for this topic.
>
> Did you add more memory in the system?

I didn't.  Neither in February (when idle and iowait accounting
temporarily doubled), nor in April (since when the accounting is stable
and the system CPU usage is growing between reboots under the new
kernel).
-- 
Thanks,
Feri.
