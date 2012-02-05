Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab2BEXae (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 18:30:34 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44472 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab2BEXaJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 18:30:09 -0500
MIME-Version: 1.0
In-Reply-To: <20120205215824.GA5071@comet.dominikbrodowski.net>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
	<1327140517-14811-19-git-send-email-yinghai@kernel.org>
	<20120127102311.6027ea2c@jbarnes-desktop>
	<CAE9FiQXQPFYU45rctaNX4kSqh7JGCnds8U-Bh1N93xVieuqz5Q@mail.gmail.com>
	<20120205215824.GA5071@comet.dominikbrodowski.net>
Date: Sun, 5 Feb 2012 15:30:09 -0800
X-Google-Sender-Auth: k_QzGLLtf9be6DjJTVOd-VaJ9EY
Message-ID: <CAE9FiQXvU-GCDSVMGvUT23WMMVmbyHpQOApuAp5mV+=UOPf_1Q@mail.gmail.com>
Subject: Re: [PATCH 18/21] PCI: Fix cardbus bridge resources as optional size handling
From: Yinghai Lu <yinghai@kernel.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Yinghai Lu <yinghai@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 5, 2012 at 1:58 PM, Dominik Brodowski
<linux@dominikbrodowski.net> wrote:
> On Fri, Jan 27, 2012 at 01:37:44PM -0800, Yinghai Lu wrote:
>> On Fri, Jan 27, 2012 at 10:23 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>> > On Sat, 21 Jan 2012 02:08:34 -0800
>> > Yinghai Lu <yinghai@kernel.org> wrote:
>> >
>> >> We should not set the requested size to -2.
>> >>
>> >> that will confuse the resource list sorting with align when SIZEALIGN is used.
>> >>
>> >> Change to STARTALIGN and pass align from start.
>> >>
>> >> We are safe to do that just as we do that regular pci bridge.
>> >>
>> >> In the long run, we should just treat cardbus like regular pci bridge.
>> >>
>> >> Also fix when realloc is not passed, should keep the requested size.
>> >>
>> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> >
>> > I'd like to see some testing on this one... Dominik?
>>
>> Dominik,
>>
>> Can you please test branch at
>>
>>       git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
>> for-pci2
>
> Tested this on my limited test systems (COUNT=1), and seems to work fine.
>

Thanks a lot.

Thought that you should have bunch of systems (laptop) with pci cardbus slots.

Found another regression by one commit already got into linus' tree.

and should be fixed by

[PATCH] pci: Fix pci cardbus removal

http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=patch;h=29834f2faeed3cb87dea984a3d411337752e6b7c

please double check

git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci3

or

git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-pci-busn-alloc

Yinghai
