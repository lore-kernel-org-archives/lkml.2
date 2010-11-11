Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab0KKBeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 20:34:11 -0500
Received: from smtp-out-135.synserver.de ([212.40.180.135]:1024 "HELO
	smtp-out-135.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932078Ab0KKBeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 20:34:10 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 22700
Message-ID: <4CDB47FB.1050004@metafoo.de>
Date: Thu, 11 Nov 2010 02:33:47 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Rhyland Klein <rklein@nvidia.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Andrew Chew <AChew@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] POWER: Add gpio charger driver
References: <1287663957-30099-1-git-send-email-lars@metafoo.de> <1287676501-23254-1-git-send-email-lars@metafoo.de> <20101021162617.GA10447@oksana.dev.rtsoft.ru> <4CC07CB4.9060108@metafoo.de> <E88A1D35AF5437468E5B14C7C4BA61C702D3E13FB3@HQMAIL01.nvidia.com> <20101104174746.GA16349@oksana.dev.rtsoft.ru> <E88A1D35AF5437468E5B14C7C4BA61C702D41B4F4F@HQMAIL01.nvidia.com>
In-Reply-To: <E88A1D35AF5437468E5B14C7C4BA61C702D41B4F4F@HQMAIL01.nvidia.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rhyland Klein wrote:
>> From: Anton Vorontsov [mailto:cbouatmailru@gmail.com]
>> Sent: Thursday, November 04, 2010 10:48 AM
>> To: Rhyland Klein
>> Cc: Lars-Peter Clausen; broonie@opensource.wolfsonmicro.com; Andrew Chew;
>> olof@lixom.net; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH v2] POWER: Add gpio charger driver
>>
>> On Thu, Oct 28, 2010 at 02:17:41PM -0700, Rhyland Klein wrote:
>> [...]
>>>> Hm... I guess it can be, but on the other hand most platform bus
>> chargers
>>>> type
>>>> devices can be, because the pda_power driver is keep pretty generic
>> with
>>>> custom init,
>>>> status and exit callbacks.
>>>>
>>>> - Lars
>>> I didn't see any more discussion on this. Is the plan to integrate
>>> the gpio-charger driver as is or to instead try to integrate support
>>> for this into pda_power?
>> Sorry for the delayed response, and thanks for the pings! ;-)
>>
>> The main thing I'm afraid of is duplication. I.e. someday you
>> will want debouncing (include/linux/pda_power.h's wait_for_status,
>> wait_for_charger parameters) support, regulators support etc.
>>
>> And your gpio driver will look very similar to pda_power.
>>
>> So I'd vote for adding the GPIO functionality to pda_power, and
>> refactoring it if needed.
>>
>> Though, if there are strong objections against this idea, I
>> can merge the GPIO driver, and let's see how things will evolve.
>>
>> Thanks!
>>
>> --
>> Anton Vorontsov
>> email: cbouatmailru@gmail.com
>> irc://irc.freenode.net/bd2
> 
> My guess, is that since no one has responded, no one is working on integrating the functionality into pda-power?
> 
> -rhyland

hi

Well I'm still not convinced that both drivers should be merged, yet I'm not totally
opposed to it. In my opinion we are in some kind of dilemma here.
I can see Antons point regarding to introducing code duplication, but on the other
hand you'll always have code duplication amongst similar drivers. This will
especially stand out if the setup functions take up a relatively large part of the
whole code size.
One way to avoid this is by putting everything into one driver which handles all
different cases. But the next time yet another sort of similar driver comes along
another if-else-branch is added to the pda-power driver. And slowly over time things
will get messy.
Another option to solve the problem is to add another level of indirection. For
example in form of a simple_charger driver which will take callbacks for add, remove
and status. The gpio-charger and pda-power could then instantiate such a driver and
provide their callbacks. But by adding more and more levels of indirection things
will slowly get messy as well.
One solution that might could work is to provide library functions which aim at
providing aid for implementing (simple) charger drivers.

- Lars
