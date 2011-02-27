Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab1B0P46 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 10:56:58 -0500
Received: from 75-145-127-229-Colorado.hfc.comcastbusiness.net ([75.145.127.229]:51263
	"EHLO gw.co.teklibre.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752383Ab1B0P4u convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 10:56:50 -0500
X-Greylist: delayed 1506 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Feb 2011 10:56:50 EST
From: d@taht.net (Dave =?utf-8?Q?T=C3=A4ht?=)
To: sedat.dilek@gmail.com
Cc: "John W. Linville" <linville@tuxdriver.com>,
        bloat-devel@lists.bufferbloat.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ANNOUNCE: debloat-testing kernel git tree
Organization: Teklibre - http://www.teklibre.com
References: <20110225222210.GA3618@tuxdriver.com>
	<AANLkTingkcc-dvs_8Nr0vYXdXvuDHEn6sz14tnHzLp8W@mail.gmail.com>
	<87fwr9jxya.fsf@cruithne.co.teklibre.org>
	<AANLkTinpG-xAC-VV-j7EBJB522+BqCyyFd_6N3KEr2Cf@mail.gmail.com>
Date: Sun, 27 Feb 2011 08:56:48 -0700
In-Reply-To: <AANLkTinpG-xAC-VV-j7EBJB522+BqCyyFd_6N3KEr2Cf@mail.gmail.com>
	(Sedat Dilek's message of "Sun, 27 Feb 2011 16:38:17 +0100")
Message-ID: <8739n9ii7z.fsf@cruithne.co.teklibre.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat Dilek <sedat.dilek@googlemail.com> writes:

> On Sun, Feb 27, 2011 at 4:31 PM, Dave Täht <d@taht.net> wrote:
>>
>> Sedat Dilek <sedat.dilek@googlemail.com> writes:
>>
>>> On Fri, Feb 25, 2011 at 11:22 PM, John W. Linville
>>> <linville@tuxdriver.com> wrote:
>>>> Announcement
>>>>
>>>> The bufferbloat project [1] is pleased to announce the availability
>>>> of the debloat-testing Linux kernel git tree:
>>>>
>>>>   git://git.infradead.org/debloat-testing.git
>>
>> ----snip----

>> Excellent. At moment I would recommend building "low latency preempt
>> desktop" kernels with a high HZ value (400 or 1000), enabling highres
>> timers, and compiling in SFB as a module. (I'd like the default for SFB
>> to be "m" rather than "n", too)
>>

> These "debloat guys" are fast :-).  I was just preparing my
> build-system (which I normally use to debianize linux-next kernels).
> Any other recommendation for kernel-config options?  For example:
> linux-next has already CONFIG_NET_SCH_CHOKE (but I have unset it).

Enable CHOKe.

The HZ value change is due to my worry that we've smashed latency so
much in the driver/mac layer that it's interacting with the higher
layers somewhat badly... So we need to add more hooks to the servo loops
involved in order to have a normal HZ. 

> Which commits are in debloat-testing GIT but not in linux-next tree?

The current list was in the release announcement. More on the way
(mostly embedded drivers at this point) git pull early and often!

> Are you planning debloat feature for 2.6.39?

Depends on how many testers we get and what the results are. 

I feel the eBDP stuff will not be ready during this release cycle. SFB
and CHOKe are in net-next, so, probably. Various driver patches -
particularly those that increase the available dynamic range via
ethtool, (e.g lowering the bottommost TX queue limit to, like, 4,
especially for home gateways) may make it out if people look harder into
the issue.

>
> - Sedat -

-- 
Dave Taht
http://nex-6.taht.net
