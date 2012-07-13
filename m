Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab2GMK3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 06:29:37 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44675 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152Ab2GMK3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 06:29:36 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B13B4A9@HASMSX103.ger.corp.intel.com>
References: <CA+icZUVorJNMQ3wyz8WuZop_fwwOuBo38wZg9s9RJizhM0yc-w@mail.gmail.com>
	<5B8DA87D05A7694D9FA63FD143655C1B13B4A9@HASMSX103.ger.corp.intel.com>
Date: Fri, 13 Jul 2012 12:29:34 +0200
Message-ID: <CA+icZUUHQsUqSnKBwUxG2yoiTAfatgPSZBT974_u95DkVZ5S6w@mail.gmail.com>
Subject: Re: [3.5-rc6+] mei: irq: request_threaded_irq is missing the
 IRQF_ONESHOT flag
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Roland Dreier <roland@purestorage.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM List <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 12:15 PM, Winkler, Tomas
<tomas.winkler@intel.com> wrote:
>
>
>> -----Original Message-----
>> From: Sedat Dilek [mailto:sedat.dilek@gmail.com]
>> Sent: Friday, July 13, 2012 12:48 PM
>> To: Winkler, Tomas
>> Cc: Thomas Gleixner; LKML; Greg Kroah-Hartman; Roland Dreier
>> Subject: [3.5-rc6+] mei: irq: request_threaded_irq is missing the
>> IRQF_ONESHOT flag
>>
>> Hi,
>>
>> while dealing with [1], I saw this mei-related infos in dmesg when doing a
>> suspend + resume (see [1] for more logs):
>
> The fix is included in this post pull request http://marc.info/?l=linux-kernel&m=134201523903406&w=2
>

[ CC Rafael @ linux-pm ML ]

Hmm, I have this commit in my local GIT buil-tree already:

$ git log --oneline | grep "mei: pci_resume: set IRQF_ONESHOT for msi
request_threaded_irq"
16a50b1 mei: pci_resume: set IRQF_ONESHOT for msi request_threaded_irq

Dunno, if it's a PM related problem? As I see this:

[17047.460520] PM: Device 0000:00:16.0 failed to resume async: error -22

BTW, what is "wd:" and what means if it "failed"?

[   23.646041] mei 0000:00:16.0: irq 47 for MSI/MSI-X
[   23.650677] mei 0000:00:16.0: wd: failed to find the client

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=16a50b1270455a6d41f9f6d8f99a72cf9d76824a

> Thanks
> Tomas
>
>
