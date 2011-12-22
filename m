Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab1LVFZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 00:25:57 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:45416 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab1LVFZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 00:25:54 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1112212107550.28597@asgard.lang.hm>
References: <4EF264C3.6000104@am.sony.com>
	<20111221231956.GB23859@suse.de>
	<4EF27B85.9080801@am.sony.com>
	<20111222122026.3a0fae36@notabene.brown>
	<alpine.DEB.2.02.1112212050060.28597@asgard.lang.hm>
	<CANqkERBPayBWjFp2nCDZA2CByJQwHMoeXe62ZutZr8QkWtcTLg@mail.gmail.com>
	<alpine.DEB.2.02.1112212107550.28597@asgard.lang.hm>
Date: Wed, 21 Dec 2011 21:25:52 -0800
Message-ID: <CANqkERCH15aGi5TJwUk6Yg3fnrPA0aiTJa=Nz9sUeZLbWs20HA@mail.gmail.com>
Subject: Re: RFC: android logger feedback request
From: Brian Swetland <swetland@google.com>
To: david@lang.hm
Cc: NeilBrown <neilb@suse.de>, Tim Bird <tim.bird@am.sony.com>,
        Greg KH <gregkh@suse.de>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 9:14 PM,  <david@lang.hm> wrote:
> On Wed, 21 Dec 2011, Brian Swetland wrote:
>>
>> We're really not interested in adding another daemon to the platform
>> -- the logging system we have has served us well, is integrated with
>> our existing development tools, and we're definitely interested in
>> improving it, but throwing it out and replacing it with a userspace
>> solution is not interesting to us right now.
>
> Think very hard before you reject any possibility of doing this in
> userspace, especially with all the things that you are talking about doing
> with logging in the future. I really don't think aht a lot of your
> long-0term plans for logging are going to sit well with the kernel
> developers, and if your justification is "you don't want to change your
> build process", I really doubt that you will get this upstream.
>
> It should be possible to do this without having to change the tools writing
> the logs, any change in logging will change what it takes to read the logs.
>
> I am not saying that you need to have a logging daemon as heavyweight as
> syslog-ng or rsyslog for the low-end phones, but I do think that as android
> moves up the stack a bit into talets and netbooks (especially in
> applications where it will have wifi connectivity almost all the time)
> having the capability to move to a full-blown syslog daemon will make a huge
> amount of sense, so you should look at how big a minimalist daemon would be,
> and what sort of performance it would have.

Long term things could certainly move around, but *right now* we
really don't see the value in gutting what we've got in favor of
writing a new userspace daemon, which is going to require somebody to
do that work, maintain it, chase down any behavioural quirks
introduced by the changes, etc.  Or to throw it out in favor of trying
to bolt our logging infrastructure on top of existing syslogds, etc.

We're happy to maintain the logger driver out of tree as we have for
the past four years.

If all discussions of bringing Android kernel support to mainline end
up as another round of "you should just rewrite it all in userspace"
or "you should use this other subsystem that doesn't actually solve
your problem but we think it's close enough", then there's not a lot
of point to having the discussions in the first place.

If somebody wants to go write a complete compatible replacement that
just drops in, we certainly could take a look at it and see how it
works, but given that the benefits are not clear to us, we're not
interested in going off and doing that work ourselves.

Brian
