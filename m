Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab2A3WhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:37:24 -0500
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:46551 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607Ab2A3WhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:37:23 -0500
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 0/3] PM / Sleep: Introduce new phases of device suspend/resume
Organization: Texas Instruments, Inc.
References: <201112230029.20174.rjw@sisk.pl> <201201162321.38279.rjw@sisk.pl>
	<8739b4h9o1.fsf@ti.com> <201201252336.36179.rjw@sisk.pl>
Date: Mon, 30 Jan 2012 14:37:18 -0800
In-Reply-To: <201201252336.36179.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Wed, 25 Jan 2012 23:36:35 +0100")
Message-ID: <87ehugrf4x.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Wednesday, January 25, 2012, Kevin Hilman wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>> > Hi,
>> >
>> > On Friday, December 23, 2011, Rafael J. Wysocki wrote:
>> >> Hi,
>> >> 
>> >> On the request of some driver PM developers, that appears to have been quite
>> >> popular lately, this series of patches adds new system suspend/resume (and
>> >> hibernation/restore) callbacks to struct dev_pm_ops and makes the PM core
>> >> use them during system power transitions.
>> >> 
>> >> [1/2] - Introduce "late suspend" and "early resume" of devices.
>> >> [2/2] - Introduce generic callbacks for new device PM phases.
>> >> 
>> >> The series is on top of the linux-next branch of the linux-pm tree.
>> >> 
>> >> These patches have been tested on Toshiba Portege R500 with openSUSE 12.1
>> >> without crashing the box in the process, which looks promising.  Also,
>> >> they shouldn't actually have any impact on the existing setups other than
>> >> adding a very short delay to the system suspend/resume code paths.
>> >
>> > The patches have received some more testing since the were first posted and
>> > I've added a PM domains patch on top of them:
>> >
>> > [3/3] - Make generic PM domains use the new device suspend/resume phases.
>> >
>> > The series applies on top of linux-pm/pm-for-linus (although it should
>> > apply on top of the current mainline too).
>> >
>> > I'm considering these patches as v3.4 material, if there are no objections.
>> 
>> Reviewed-by: Kevin Hilman <khilman@ti.com>
>> 
>> Thanks Rafael for working on this.
>> 
>> So far I've only reviewed it, but I plan to convert my PM domain noirq
>> usage to this and give it some testing as well, hopefully this week.
>
> Great, thanks!
>

OK, I gave it a test on OMAP by converting our _noirq usage to the new
early/late callbacks.  Works great.  Thanks!

Tested-by: Kevin Hilman <khilman@ti.com>

Kevin

