Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab0IXLuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 07:50:20 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51532 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab0IXLuS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 07:50:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i8xQ5YkgkynXXcobxefo7aa8f0xgHWGv5GDUjMTF93qqUTv8rTRC+LAJbLNpBD5Z8U
         178m4T6mHHqGe4HNhC+2gDNOeIyGhVQjjJYxEeECPGxL2DIJ2NP8mCQ1pwOCe9j7NwNT
         8uUTlrz9xkBu/6P3K5fpJZVNciS6RDPfGyH/w=
MIME-Version: 1.0
In-Reply-To: <20100923141651.GL26290@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
	<20100921214847.GF26290@redhat.com>
	<b151e9f1ec3a162781b380e026f90711.squirrel@www.firstfloor.org>
	<20100922160705.GK26290@redhat.com>
	<AANLkTi=gYa5aEhrQAgpgfopoyW_1v0TJsnQ7bSbTV52i@mail.gmail.com>
	<20100923141651.GL26290@redhat.com>
Date: Fri, 24 Sep 2010 19:50:16 +0800
Message-ID: <AANLkTi=7kG+PGrQFkWETBSu37SPYxXeXNihB2eBFc6sG@mail.gmail.com>
Subject: Re: [RFC 1/6] x86, NMI, Add symbol definition for NMI magic constants
From: huang ying <huang.ying.caritas@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 10:16 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Thu, Sep 23, 2010 at 05:29:57PM +0800, huang ying wrote:
>> Hi, Don,
>>
>> On Thu, Sep 23, 2010 at 12:07 AM, Don Zickus <dzickus@redhat.com> wrote:
>> > On Wed, Sep 22, 2010 at 12:19:16AM +0200, Andi Kleen wrote:
>> >>
>> >> >
>> >> > I guess adding either another knob to override the hardware error option
>> >> > or tying it in with the panic_on_unknown_error option might make me more
>> >> > comfortable.  That way enterprise customers can always just enable it by
>> >> > default and desktop users (for now) could have it off.
>> >>
>> >> Anything that needs explicit enabling is a bad idea, that
>> >> would lead to a lot of users running in "corrupt my data" mode.
>> >
>> > I know.  But as I said earlier in my emails, I am trying to figure out how
>> > to deal with the fallout from unknown nmis turning into panics.  Today
>> > people see unknown nmis.  They may or may not be corrupting data.  They
>> > usually file a bug.  Currently it is hard for me to diagnosis the problem.
>> > Usually the old 'upgrade your bios/firmware' does the trick.  Sometimes it
>> > doesn't and people feel like their machines still run fine.  So they
>> > ignore it (for good or for bad).
>> >
>> > Turning unknown nmis into panics would break their current setup without
>> > much gain.  So I was trying to propose something temporarily until we
>> > could get a better infrastructure to isolate the source and provide better
>> > info on what to do.
>> >
>> > I agree with you that long term unknown nmis should be panics.  I just get
>> > nervous about doing that now from a support perspective.
>>
>> In fact, we use white list policy here. Only systems with HEST or
>> identified by chipset host bridge PCI ID will panic for unknown NMI.
>> So I think systems you worried about will not have this enabled.
>>
>> >> The code currently uses the presence of a HEST error table
>> >> to detect a server. HEST should be only available on servers.
>> >>
>> >> On servers at least panic should be default.
>> >
>> > Ok.  That's fine. But then what.  What does a developer do with that
>> > panic?  There's no useful info.  That is sorta my problem.  Then again I
>> > do not know much about HEST.
>>
>> On some system, there is some hardware error log in BMC/BIOS. The
>> hardware error log can be gotten via IPMI or BIOS menu. Otherwise, can
>> we get some useful info for unknown NMI? If we can, can we collect the
>> info, then print it on console and save it into flash via ERST (part
>> of APEI too) before panic?
>
> Ok.  Does the BIOS/BMC automatically do this?  Can we just print a message
> on panic saying checking your BIOS/BMC logs for more info?

Yes. BIOS/BMC automatically do that. And I will add it to panic message.

> I would love to add code to gather more useful info for unknown NMIs, but
> is it expected that HEST does some of this?  I guess what I am trying to
> figure out, if we are going to put intelligence to detect a HEST enabled
> machine and panic when unknown NMI comes along (presumably from HEST??),
> then can we leverage HEST at all to understand why the NMI happened or
> point the user to the BIOS/BMC to get more info.  In other words, what
> value do we get HEST other than we detect its there, lets panic.

Yes. HEST can be used to report some hardware error information. I am
working on that now.

>> HEST is defined in ACPI spec 4.0 and later version in section named
>> APEI (ACPI Platform Error Interface). It is used to describe the error
>> sources of system. It should be available only on server platform.
>
> Ok.  Does the kernel have intelligence to use it or the BIOS yet?

HEST works in kernel BIOS cooperative way. I am working on a HEST
driver which will get notified for NMI and collect the error
information reported by BIOS. But It is possible that some systems
have only BMC/BIOS log and do not report that to OS except unknown
NMI. The unknown NMI panic logic is for these systems.

Best Regards,
Huang Ying
