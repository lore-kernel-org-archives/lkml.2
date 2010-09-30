Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab0I3Mua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 08:50:30 -0400
Received: from cmx.wol.de ([193.158.62.4]:45010 "EHLO cmx.wol.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821Ab0I3Mua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 08:50:30 -0400
Subject: Re: [PATCH] Fix capi devicenames
From: "Marc - A. Dahlhaus" <mad@wol.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        isdn@linux-pingi.de
In-Reply-To: <20100930122928.19e5ee84@lxorguk.ukuu.org.uk>
References: <4CA391B3.1030806@wol.de>
	 <20100930103010.1a6a7785@lxorguk.ukuu.org.uk>
	 <1285843077.748.32.camel@marc>
	 <AANLkTi=d+5uDVK9RHguSmwFhKLVUPXvzo=G3s=NKKDW3@mail.gmail.com>
	 <20100930122928.19e5ee84@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Thu, 30 Sep 2010 14:50:24 +0200
Message-Id: <1285851024.748.97.camel@marc>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 30.09.2010, 12:29 +0100 schrieb Alan Cox:
> > In any case devices.txt should be fixed, it has not much to do with
> > the real world.
> 
> If some distros chose not to follow devices.txt that is their problem.
> 
> devices.txt is the specification, and its ABI.
> 
> It is fixed and the kernel behaviour is to follow it. Those who didn't
> follow it, or who didn't propose a change back when it was specified in
> the first place have only themselves to blame.
> 
> It isn't changing, and the ISDN code should follow the spec.
> 
> How you sort out your userspace is a problem for those who dug holes and
> jumped down them.

Well, i doubt that any distro or hand crafted setup out there is using
anything else than the /dev/capi20 and /dev/capi/[0-9]+ devices for capi
interaction. Because the userspace (libcapi20 & capiinit) handle just
this devices. (i checked debian/ubuntu, fedora rawhide and gentoo and
all are not using other device node names...)

<minorrant>

The only setup that could get broken by this is the setup that uses udev
to handle the devices and gives the nodes different access rights or
something.

And that already happened by the time the rules used to create the capi
devices got removed from udev and it was right to remove them from udev
IMO.

What is a specification in devices.txt worth if nobody actually cares
about it in this case because it has evolved long time ago and nobody
cared to update the devices.txt file by then?

capifs is already deprecated and scheduled for removal soon because udev
is able to replace its functionality and fedora has a patch in srpm that
removes the capifs load from capiinit.

Userspace expects the capifs device nodes.

We are stuck by now. No matter what the specification states,
no setup will work with an up to date version of linux kernel, udev and
isdn4linux userspace now.

</minorrant>

Well, in the end, i don't get it:

How could we brake an already broken thing by fixing an broken
specification and make upstream respect what any distro out there does?

I could send a patch that "fixes" the device names according to the
broken specification in devices.txt and also send a rule for udev to
create symlinks that the userspace expects.

We would get useless kernel suggested devices for capi that nobody needs
because userspace will not use them, period. A well polluted /dev is the
end if this would be the right way to fix this case. Nice, isn't it ;)

I know the rules are made out of noble intends, but IMO the rule will
defeat the logical right fix for the problem that will not brake anyones
setup and there should be exception from the rule for this one case
because the things are how they are now. The spec will not help anyone
out there who is trying to use eg. his B1-ISDN card to receive a
faximile or to provide an old school dial-in access in cases where the
internet carrier is down once the upstream versions are used in the
distros...

Marc

