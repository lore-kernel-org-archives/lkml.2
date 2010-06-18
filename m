Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761050Ab0FRLzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 07:55:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41301 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761035Ab0FRLzH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 07:55:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r/boULnbmP0mu52nLSep2izxiDIioKnbrCai/VGrOvgdhX1oqTcwcL124UnHym+A5B
         ic78RyaKryLWyRnY93eYFXQ8AT0MvA2t24Pfmuo1Mkdn53uXip4HI/RiCfSLoXZ4wxTk
         f+A9pJUCHm5Cf6IkDkNbxP4BhShz/VRZdTS9U=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006180149120.7628@localhost.localdomain>
References: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain>
	<0F1C0B07-60D6-405B-890B-F9C320820CA5@gmail.com>
	<alpine.LFD.2.00.1006171500260.4214@localhost.localdomain>
	<AANLkTimWfE0WXr558sOnjZFptxpP4k6IvMWriR3seIKu@mail.gmail.com>
	<alpine.LFD.2.00.1006180149120.7628@localhost.localdomain>
Date: Fri, 18 Jun 2010 06:55:04 -0500
Message-ID: <AANLkTimufQp-Mc1QP1w1YxlkfQQZq0t4e_oK_B3O2YBl@mail.gmail.com>
Subject: Re: [linux-pm] RFC: /sys/power/policy_preference
From: Victor Lowther <victor.lowther@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Linux Power Management List <linux-pm@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 12:56 AM, Len Brown <lenb@kernel.org> wrote:
> On Thu, 17 Jun 2010, Victor Lowther wrote:
>
>> > The idea here is to not require user-space to need updating
>> > whenever a future knob is invented.  We can do a great job
>> > at documenting the past, but a poor job of documenting the future:-)
>>
>> Well, I would suggest that the habit of not documenting what is
>> happening with power management in the kernel needs to change, then.
>
> Actually some of the knobs I showed in the examples
> have been documented for *years*, yet are ignored
> by user-space today.  I don't want to insult user-space
> programmers, but the reality is that simpler is usually better.

Let me explain where I am coming from, then.  I maintain pm-utils, one
of the main low-level bodies of userspace code that concerns itself
with power management.  I am currently in the process of standardizing
some of the more common power management tweaks so that they will work
in a cross distro manner, and know from this that the documentation we
have is badly fragmented -- if you know exactly what you are looking
for, you can google or grep for it, but if you do not, there is no
easy way to find a list of all the power management settings you can
tune.

>> Having the documentation and example code for how to tweak the various
>> power management settings from userspace is inherently more flexible
>> than trying to expose a single knob from the kernel to userspace for
>> power management, with little loss of flexibility.
>
> Yes, the ultimate in flexibility is to update user-space whenever
> some new driver or new knob appears in the kernel.  I'm not proposing
> that ability be taken away.  I'm proposing that in many cases it
> is unnecessary.

I disagree.  Most of userspace does not care about how the system is
trying to save power.  I maintain one that does, and I do not like the
idea of adding another knob whose entire purpose is to map other,
already existing knobs onto a line, especially when we can do that in
userspace easily enough if anyone actually wants it.

> The idea is to have the ability to add something to the
> kernel and avoid the need to make any change to user-space.

Userspace in this case consists mainly of
acpi-scripts/pm-utils/laptop-mode-tools, upower,
g-p-m/kpowersave/x-p-m, and X. I can only speak for pm-utils, but the
model pm-utils, acpi-scripts, and laptop-mode-tools use does not map
to your proposed knob at all.  We use a two-state model -- either we
are on AC power and use the kernel's default power state, or we are on
battery power and set power management to a set of distro or user
chosen set of parameters.  I am working on making pm-utils contain
some predefined powersaving policies, but I do not expect them to
change the two-state model much more than changing which power
management tweaks are used in the on-ac and on-battery states.

> thanks,
> -Len Brown, Intel Open Source Technology Center
>
