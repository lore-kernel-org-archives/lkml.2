Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab0GMSc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 14:32:59 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46115 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab0GMSc5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 14:32:57 -0400
MIME-Version: 1.0
In-Reply-To: <20100713070741.GB26442@pengutronix.de>
References: <20100630104043.GG11746@pengutronix.de> <20100712155518.GA24144@pengutronix.de> 
	<AANLkTilhI9O6YwnuAylo_jNgwR8VXmpSVJ1kylIYPCGT@mail.gmail.com> 
	<20100712173228.GC9897@n2100.arm.linux.org.uk> <AANLkTinxUqzxClVDTyruJ6kzFTganXUGJJHJ5wRi9Iak@mail.gmail.com> 
	<20100712185029.GB14425@pengutronix.de> <AANLkTinOuU-VVXaMwMp69CBp2Y4wxpoWybEQ34H5j0lJ@mail.gmail.com> 
	<alpine.LFD.2.00.1007121510260.10598@xanadu.home> <AANLkTim-O00n9YPv7w4VCKjN-ETLijyTHomWUn4mZtTV@mail.gmail.com> 
	<AANLkTilDoGbCx_0oKKPOeGG7TKL2VSNVII5ydmnQ77B7@mail.gmail.com> 
	<20100713070741.GB26442@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 13 Jul 2010 12:32:36 -0600
X-Google-Sender-Auth: 1d8OSo5fnG2pfWonEtA1IUviWLo
Message-ID: <AANLkTikudrURTxljZAigppSds0IhbUATA6sm7y-dL4GL@mail.gmail.com>
Subject: Re: ARM defconfig files
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org, Eric Miao <eric.miao@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/13 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> Hi
>
> On Mon, Jul 12, 2010 at 01:50:47PM -0600, Grant Likely wrote:
>> On Mon, Jul 12, 2010 at 1:34 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>> > On Mon, Jul 12, 2010 at 12:17 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
>> >> I think Uwe could provide his script and add it to the kernel tree.
>> >> Then all architectures could benefit from it.  Having the defconfig
>> >> files contain only those options which are different from the defaults
>> >> is certainly more readable, even on x86.
>> >
>> > Quite possible. But maintainers would need to be on the lookout of
>> > people actually using the script, and refusing to apply patches that
>> > re-introduce the whole big thing.
>>
>> I can (partially) speak for powerpc.  If ARM uses this approach, then
>> I think we can do the same.  After the defconfigs are trimmed, I
>> certainly won't pick up any more full defconfigs.
> I just restarted my script on the powerpc defconfigs basing on rc5, I
> assume they complete in a few days time.
>
>> Of course, I'm also operating under the assumption that this is a
>> temporary measure until one of the better solutions is implemented.
> ack
>
>>                                                                      I
>> do suspect that the trimmed defconfigs will tend to be unstable and
>> will still require manual maintenance.  I think the Kconfig fragments
>> approach is the most promising if the dependencies issue can be
>> solved.
> I don't understand what you mean with unstable here.  They are sensible
> to changed defaults in the Kconfig files which you can consider to be
> good or bad.

With the trimmed config, changes to default settings on config items
will immediately picked up regardless of whether or not it was wanted,
and potentially disabling things that were explicitly selected in
defconfig.  But thinking about it more, that isn't really any worse
than the old situation where defconfigs always override Kconfig
defaults.  So either way, defconfigs are simply a broken concept.

> And ack, I like the Kconfig approach, too.

Yeah, the problem goes away with Kconfig fragments.  A programmer can
then explicitly state which CONFIG values need to be overridden.

g.
