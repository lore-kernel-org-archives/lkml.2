Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985Ab1EMNRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:17:16 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54413 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758889Ab1EMNRO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:17:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QZ/Rabg6L64x3rpNFSF1MWQsB2jHUOAaOz+dxU4SONyMLvUuTEvp/68yPN3gtn3ESm
         etPgLaUjL6EnYbIcnV23QRHcpbaEjSOwxW0Dv5ZpwCzWUCOSTQcfh8dTEwaIwmAT4LHf
         liyJ/X56PKr01N9MvYmTQz7emIGLR22G7VRhA=
MIME-Version: 1.0
In-Reply-To: <20110513124523.GM13984@redhat.com>
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com>
	<20110513124523.GM13984@redhat.com>
Date: Fri, 13 May 2011 21:17:13 +0800
Message-ID: <BANLkTimoqYZMs15H8wRqEEe=UyBJtAwipw@mail.gmail.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
From: huang ying <huang.ying.caritas@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Don,

On Fri, May 13, 2011 at 8:45 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Fri, May 13, 2011 at 04:23:38PM +0800, Huang Ying wrote:
>> In general, unknown NMI is used by hardware and firmware to notify
>> fatal hardware errors to OS. So the Linux should treat unknown NMI as
>> hardware error and go panic upon unknown NMI for better error
>> containment.
>
> I have a couple of concerns about this patch.  One I don't think BIOSes
> are ready for this.  I have Intel Westmere boxes that say they have a
> valid HEST, GHES, and EINJ table, but when I inject an error there is no
> GHES record.  This leaves me with an unknown NMI and panic.  Yeah, it is a
> BIOS bug I guess, but I think vendors are going to be slow fixing all this
> stuff (my Nehalem box is in even worse shape with this stuff).

Although there is no GHES record, I think the Westmere box behavior is
acceptable, an unknown NMI is used by BIOS to notify hardware error,
this is what we want to deal with in this patch.

> Also, is there any known issues with x86_64 platforms with bad NMIs?  RHEL
> has had unknown NMI's panic on x86_64 since x86_64 first came out, I don't
> recall any exceptions we had to add to handle 'quirky' hardware.
>
> Then for the i686 case, because the 'quirky' hardware is so old, can't we
> just leave it a kernel config option to switch between using a 'printk'
> vs. a 'panic'?  Or even a kernel command line option.
>
> I figure these 'quirky' hardware machines are more the exception nowdays,
> do we really need to add code to whitelist machines?
>
> Granted I am not familiar enough with the quirky hardware (in fact I don't
> think I have seen any mainly because I haven't been around long enough).
> Most cases I see when trolling through the fedora bugzilla list for
> unknown NMIs, is just bad firmware or acpi power configurations.
>
> Just wondering if we could just simplify the patch somehow with better
> assumptions.

So there is still unknown NMIs on real hardware now. I am afraid turn
on panic on unknown NMI by default may be not acceptable for someone.

Best Regards,
Huang Ying
