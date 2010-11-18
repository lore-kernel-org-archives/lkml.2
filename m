Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887Ab0KRQqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:46:37 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54610 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab0KRQqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:46:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=w+M4D88476CxXMOzWfUvIB/Lk8HSgicSntF5YljhkChiKxkz/y97V2YdN/U0cWnRLs
         ff0P9aFaTUIKo37/69SQPwlUfjwWmogWvaq22n1AqR+/3QlRlf6FbqNQexEm01tPbQ+B
         xjw+DXoYpeGiWbTZkHQtGcnFJbPuoGysTCT88=
MIME-Version: 1.0
In-Reply-To: <F46C52ED-8DB8-4347-957D-B9D84406D53F@mit.edu>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com> <F46C52ED-8DB8-4347-957D-B9D84406D53F@mit.edu>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 18 Nov 2010 08:46:11 -0800
X-Google-Sender-Auth: qG2HMB1ZgcurWtPcQ9o9PYYBwyM
Message-ID: <AANLkTinyafwe9MyXhSSe5vxEKnTUeLV0AZDWY_uXsu8f@mail.gmail.com>
Subject: Re: Challenges with doing hardware bring up with Linux first
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
        Charles Marker <Charles.Marker@atheros.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Kevin Hayes <kevin@atheros.com>, Zhifeng Cai <zhifeng.cai@atheros.com>,
        Don Breslin <Don.Breslin@atheros.com>,
        Doug Dahlby <Doug.Dahlby@atheros.com>, Julia Lawall <julia@diku.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 3:11 AM, Theodore Tso <tytso@mit.edu> wrote:
> Luis,
>
> I'm having a little trouble understanding what it is your proposing.

I'm both, explaining why some companies tend to have a hard time
working directly upstream and using 802.11 as an example, and trying
to find ways to help change old habits to help companies work
upstream, even if that means for non 802.11 drivers, but by using
802.11 landscape as an example case study. My goal is to show a clear
path for vendors to work with proper Linux upstream first for bring
up, that is the long term goal I am trying to envision but at the same
time trying to address the other goals companies have to keep
supporting the other OSes and help the ecosystem by coming up with
ways to help guide companies or share more code for the other OSes,
not just for 802.11 but for other subsystems.

> I *think* you are suggesting that
>
> a)  Some portion of the "OS agnostic crap" be relicensed under a BSD or Apache-style license.

Well this is certainly possible, question is if we can gain from
sharing a common OS agnostic API, stuff it into staging and encourage
other vendors to consider using it for staging drivers. For a proper
port we could use spatch patches to then remove the OS agnostic crap
and start skinning the driver. Today in staging we'd do this step by
step by porting over each typedef or struct the vendor used, or we
just re-write the driver.

> And I think what you are suggesting would fall in that camp is the parts of the Linux 802.11 stack?
>
> b)  That the "OS agnostic crap" be moved into staging.
>
> Can we ignore where the code lives for now?   I think (b) doesn't make any sense at all.

But its OK for each staging driver to have their own OS shim stuff.
drivers/staging/ath6kl/os/linux/
Seems a bit at odds to be OK with this but not with a common OS shim
in staging for different drivers.

> And as far as (b) is concerned, I think what you are suggesting isn't so much about the code,
> but trying to somehow encourage, via the carrot of making it easy to push vendors into
> agreeing that the Linux 802.11 wireless API should be considered the OS independent
> interface layer that random vendors creating 802.11 drivers can interface against.

After Broadcom started hacking upstream and seeing TI start to work
upstream I actually believe for 802.11 we're pretty much set on
getting most if not all vendors on board with upstream today :) but I
was using 802.11 as an example of the challenges faced by companies
and old habits held, and hoping to find rational suggestions to
encourage either doing upstream first or helping die out the old
habits with better replacements which can suit us and the community /
vendors.

Sure - for 802.11 a shim wrapper against mac80211 would be ideal for
sure, but we'd then still need a common permissive licensed 802.11
stack for vendors to use, and an OS shim.

> And to make that easy, you want to relicense the 802.11 stack under a BSD/Apache license so
> that it makes life easy for people who are creating drivers for Windows XP.   Do I have that right?

I don't want to change the license of our 802.11 stack but am stating
that if a good 802.11 stack existed which was permissive licensed that
vendors would pick it. Its why a lot of vendors ended up picking
net80211 to base their own 802.11 stacks out of. Sure, if mac80211 was
permissive licensed we can likely get more traction with development
by considering using it as the common 802.11 stack for other OSes that
do not have their own 802.11 stack as well but that doesn't
necessarily have to be the answer. Since a common 802.11 stack is used
and will be used by vendors for years to come I wondered if it made
sense to stuff one for vendors into staging so that they can use for
this purpose. Earlier (not now with ath6kl and brcm80211) 802.11
staging drivers all implemented their own 802.11 stack, so why not
encourage using something more common and shared between vendors. This
is surely not our job as upstream Linux developers, but just pointing
out that these stacks will exist and be maintained for years to come.
I wonder what other type of similar situations there are with other
subsystems.

> Assuming I understand the motivations of your proposal and what it is you were proposing
> in the first place, might another course of action which might prove as efficient, if not more
> so in the long term, is for some volunteer (perhaps at Atheros) to create some freely licensed
> new code that creates a glue layer between the Linux interfaces that wireless drivers use to
> plug into Linux's 802.11 layer, and to the 802.11 layer for Windows 7 and Mac OS X.

Right, this is along with my thinking but I'll note that our ath9k
driver is completely independent and the only code shared today would
be the hardware code, stuff that goes into the ath9k_hw module. But
sure, other things like OS wrappers to help drivers work with
different OSes could potentially be released, if not seen as
competitive advantage. Getting a wrapper to be created for the
different OS 802.11 stacks would certainly help as well but that would
be a bit of a challenge as we'd need to hope for at least some
similarity between 802.11 stacks.

>  Furthermore, to make this glue layer GPL with the exception clauses that allows the glue code to link into Windows 7 and Mac OS X.

For that matter just make it ISC / permissive licensed as this is GPL
Compatible.

> What this provides for is a wonderful leverage for hardware vendors.   If they provide GPL'ed
> code for their core hardware drivers that link against the Linux 802.11 layer, at one fell swoop
> they also get Windows 7 and Mac OS X drivers for free!

Yes, indeed ! That would be ideal indeed, but we'd need then an 802.11
stack which is also permissive licensed and then make APIs for that
802.11 stack to match mac80211's or cfg80211's or bridges between
then. Because ultimately you will still need some 802.11 stack for
some OSes that don't have one.

>  Better yet, it doesn't require getting permission from the Linux world, since what is necessary is the existence
> of new glue code that allows the hardware dependent code that previously was Linux specific, and which now'
> allows it to plug into the glue code which then allows it to become hardware independent code for
> Windows 7 and Mac OS X.

Sure, that can likely work if the APIs don't change as often or we can
find some common ground.

  Luis
