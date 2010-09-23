Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab0IWJaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 05:30:00 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57023 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab0IWJ36 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 05:29:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hKmr0v5dix3/4oq2mIzkgmYngCq8100gVbxslzOqDncgp9/Y8+N5Q5SA6A1CBJrCI4
         lQHf65vS9WYRxzHTnncBn6HRHzXsWVPwby7XPhGEIpV+j2ejJx5GckKGOtu2rzvrkp2E
         n1YXzSjL1zB4+AK/GGl5YMLfX8/Tsnt6CtGKQ=
MIME-Version: 1.0
In-Reply-To: <20100922160705.GK26290@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
	<20100921214847.GF26290@redhat.com>
	<b151e9f1ec3a162781b380e026f90711.squirrel@www.firstfloor.org>
	<20100922160705.GK26290@redhat.com>
Date: Thu, 23 Sep 2010 17:29:57 +0800
Message-ID: <AANLkTi=gYa5aEhrQAgpgfopoyW_1v0TJsnQ7bSbTV52i@mail.gmail.com>
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

Hi, Don,

On Thu, Sep 23, 2010 at 12:07 AM, Don Zickus <dzickus@redhat.com> wrote:
> On Wed, Sep 22, 2010 at 12:19:16AM +0200, Andi Kleen wrote:
>>
>> >
>> > I guess adding either another knob to override the hardware error option
>> > or tying it in with the panic_on_unknown_error option might make me more
>> > comfortable.  That way enterprise customers can always just enable it by
>> > default and desktop users (for now) could have it off.
>>
>> Anything that needs explicit enabling is a bad idea, that
>> would lead to a lot of users running in "corrupt my data" mode.
>
> I know.  But as I said earlier in my emails, I am trying to figure out how
> to deal with the fallout from unknown nmis turning into panics.  Today
> people see unknown nmis.  They may or may not be corrupting data.  They
> usually file a bug.  Currently it is hard for me to diagnosis the problem.
> Usually the old 'upgrade your bios/firmware' does the trick.  Sometimes it
> doesn't and people feel like their machines still run fine.  So they
> ignore it (for good or for bad).
>
> Turning unknown nmis into panics would break their current setup without
> much gain.  So I was trying to propose something temporarily until we
> could get a better infrastructure to isolate the source and provide better
> info on what to do.
>
> I agree with you that long term unknown nmis should be panics.  I just get
> nervous about doing that now from a support perspective.

In fact, we use white list policy here. Only systems with HEST or
identified by chipset host bridge PCI ID will panic for unknown NMI.
So I think systems you worried about will not have this enabled.

>> The code currently uses the presence of a HEST error table
>> to detect a server. HEST should be only available on servers.
>>
>> On servers at least panic should be default.
>
> Ok.  That's fine. But then what.  What does a developer do with that
> panic?  There's no useful info.  That is sorta my problem.  Then again I
> do not know much about HEST.

On some system, there is some hardware error log in BMC/BIOS. The
hardware error log can be gotten via IPMI or BIOS menu. Otherwise, can
we get some useful info for unknown NMI? If we can, can we collect the
info, then print it on console and save it into flash via ERST (part
of APEI too) before panic?

HEST is defined in ACPI spec 4.0 and later version in section named
APEI (ACPI Platform Error Interface). It is used to describe the error
sources of system. It should be available only on server platform.

Best Regards,
Huang Ying
