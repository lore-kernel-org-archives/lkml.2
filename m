Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845Ab2BHXtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 18:49:18 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52361 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab2BHXtR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 18:49:17 -0500
MIME-Version: 1.0
In-Reply-To: <10120.1328731572@turing-police.cc.vt.edu>
References: <4F27120A.4040106@suse.cz> <CAPXgP12Sr2KzGJ9RA13QBOCkctb-z3O4+1uHOjANgMDDv2pxaQ@mail.gmail.com>
 <4F27C54F.1010107@suse.cz> <CAPXgP11=U_Y3LvJB2LRnXQ53y1WQQTqc0j1c7iva6ZXvF97wEw@mail.gmail.com>
 <20120204021457.GA25386@khazad-dum.debian.net> <CAPXgP12yZ74679JNwRB-pDfnjOBaxMzL2=krSDK31jM1mjXfuA@mail.gmail.com>
 <20120208020038.GE13296@khazad-dum.debian.net> <CAPXgP12ExDub9ML0=DcWRwyQP23GXDJ75jiNnw+BTXY17tEa8Q@mail.gmail.com>
 <14373.1328683324@turing-police.cc.vt.edu> <CAPXgP10-W+yeHJMENzWi7FBkYOaXw6ccMMMT=K9X2bf_Tigitw@mail.gmail.com>
 <10120.1328731572@turing-police.cc.vt.edu>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 9 Feb 2012 00:48:56 +0100
Message-ID: <CAPXgP13j1abG-ncaGeRgTpZdPc964Q4Yz3XLk8YQm4z5Q07Hkg@mail.gmail.com>
Subject: Re: network regression: cannot rename netdev twice
To: Valdis.Kletnieks@vt.edu
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Jiri Slaby <jslaby@suse.cz>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ML netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 8, 2012 at 21:06,  <Valdis.Kletnieks@vt.edu> wrote:
> On Wed, 08 Feb 2012 11:57:18 +0100, Kay Sievers said:
>> On Wed, Feb 8, 2012 at 07:42,  <Valdis.Kletnieks@vt.edu> wrote:
>
>> > Or is this sort of thing in /etc/udev/rules.d/70-persistent-net.rules
>> > SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:25:90:0b:f2:80", ATTR{type}=="1", KERNEL=="eth*", NAME="eth0"
>> > what you are trying to move to, and my systems are already onboard and
>> > I should just move along, nothing to see here? ;)
>>
>> Yeah, that's what we did in the past. It works fine if you never have
>> to swap names like eth0 and eth1, with need to free one of the the
>> names with a temporary rename.
>
> Well, if I had my druthers, I'd stick name="net-mgt", "net-pub", and "net-10g"
> in the udev rules, and not care about 1/2/3 and race conditions, because
> meaningful names are easier to not screw up (just last week found a system that
> had eth1 and eth2 reversed in some iptables rules, wouldn't have happened if
> they were -mgt and -pub).
>
> Only thing stopping me is getting iptables to accept '-i net-10g', and the
> distro /etc/sysconfig/network scripts like ifup and ifdown playing nice....
>
> So it sounds like what I want as a sysadmin is the same thing you want
> as a maintainer...

Yeah, that sounds very much like it is.

I want to push some responsibility to the admin, do less automagic,
and personally want to be less responsible for all the unintended
screw-up the automagic is causing everywhere.

Sure, the intention to keep the names like they always have been was
good, but a good intention and a broken model to deliver it, and
continue to pretend we can solve it, is the worst things we can do. :)

Kay
