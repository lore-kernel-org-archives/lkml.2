Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab1HNRRm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 13:17:42 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44849 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab1HNRRi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 13:17:38 -0400
MIME-Version: 1.0
In-Reply-To: <20110814170124.GC12747@elie.gateway.2wire.net>
References: <20110414094447.GA1611@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1104211629300.24613@xanadu.home>
 <201104261605.26791.arnd@arndb.de> <201104261904.45923.rjw@sisk.pl>
 <20110426181508.GB1908@redhat.com> <20110813154638.GA1494@elie.gateway.2wire.net>
 <20110813190246.GA10412@elie.gateway.2wire.net> <20110813211142.GA1536@redhat.com>
 <20110814170124.GC12747@elie.gateway.2wire.net>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sun, 14 Aug 2011 19:17:18 +0200
Message-ID: <CAPXgP102fk_7WPUY1QKq9izJuWH4saGeCVmYO5tJCReegTAEkA@mail.gmail.com>
Subject: Re: [BUG?] Moving drivers to drivers/cpufreq/ causes all to be loaded
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mattia Dongili <malattia@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 19:01, Jonathan Nieder <jrnieder@gmail.com> wrote:
> (-cc: ARM/etc people; +cc: Kay)
>
> Dave Jones wrote:
>
>> If we have to move stuff again, we could do drivers/cpufreq/x86/ etc..
>
> Unfortunately the old script used "find", not "ls", so that wouldn't
> work. :/
>
>> What we used to do in Fedora grew more and more complex over time.
>> Here's the last incarnation: http://fpaste.org/uvDb/
>
> The main difference from Debian seems to be that this script loads the
> module corresponding to the chosen governor, while Debian's init
> script loads all governor modules early (using a heuristic I would
> like to avoid that involves running "find" to list them) and chooses
> the governor to use later.

Right, loading cpufreq drivers from userspace is fragile, and can not
properly work today. Only the kernel itself know which driver to try
to bind in which order. Modular cpufreq kernel modules make no real
sense here with the infrastructure we have available today.

>> In an ideal world, we'd auto-load the right module on a hotplug event
>> from a cpu, but we're not there yet. I believe Kay is working on that.
>
> Yes, that is what I was hoping for.  Are there patches to test?

Yeah, it's on the TODO list, I just get too many 'really broken'
things get sorted on top all time. :) But it will happen in the next
months.

> The comment at
> http://thread.gmane.org/gmane.linux.kernel/796450/focus=796874 also
> looks promising.

That could work, but we better go right for the CPU specific aliases
and do not try to load all of them, even when for completely different
systems. That would just encode another workaround into kernel
modules, which we better solve properly.

Kay
