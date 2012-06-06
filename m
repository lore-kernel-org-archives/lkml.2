Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284Ab2FFXST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 19:18:19 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63046 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab2FFXSR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 19:18:17 -0400
MIME-Version: 1.0
In-Reply-To: <1339023839.25761.764.camel@lyra>
References: <20120427190033.GA17588@ldl.usa.hp.com>
	<20120606135009.GB1517@srcf.ucam.org>
	<1338999463.25761.630.camel@lyra>
	<20120606162703.GA6779@srcf.ucam.org>
	<1339003956.25761.667.camel@lyra>
	<20120606174202.GA8750@srcf.ucam.org>
	<1339006060.25761.689.camel@lyra>
	<CAL-B5D3Wda7TV_NBJWEbzJm=0eCs=b-wgGLdJUFRTwP_ewXGGg@mail.gmail.com>
	<1339023839.25761.764.camel@lyra>
Date: Wed, 6 Jun 2012 17:18:16 -0600
Message-ID: <CAL-B5D3_MvP8PG_=4vh9oxgBPbpaoDscw3b5PK5Hr5s0Qk9xrg@mail.gmail.com>
Subject: Re: [PATCH] Disable Bus Master on PCI device shutdown
From: Myron Stowe <myron.stowe@gmail.com>
To: Khalid Aziz <khalid.aziz@hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, linux-pci@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 5:03 PM, Khalid Aziz <khalid.aziz@hp.com> wrote:
> On Wed, 2012-06-06 at 14:16 -0600, Myron Stowe wrote:
>> Hay Khalid,
>>
>> I've been following this discussion but still do not understand what the
>> perceived correct fix is for the situation you were originally trying to
>> circumvent - namely, stopping NIC devices from triggering DMA activity
>> upon receipt of an incoming packet.
>>
>> From the discussion it sounds like a driver, upon shutdown, can end
>> all active I/O
>> clearing the I/O queue, and also (?) shut down its DMA engine, and may
>> also go as far as disabling the Bus Master bit.
>>
>> What was occurring in the original issue - was the driver in question not
>> shutting down its DMA engine for some, possibly valid, reason?
>>
>> Thanks,
>>  Myron
>
> Hi Myron,
>
> The last driver issue with kexec was reported on kexec mailing list in
> July of last year and that was with qla driver. From what H Peter Anvin
> described, the driver left DMA engine running.
>
> For the issue I found on an ia64 platform, it was so many years ago that
> you are now taxing my old and decrepit memory :)

Yeah, if it was more than a couple of weeks ago then I'm likely to have
forgotten myself.

If you can find it great but don't spend too much time digging.  I just wanted
some validation of my understanding -
  o  That drivers must consider both "active I/O" and "DMA" (when
shutting down),
  o  That the Bus Master disablement was trying to compensate for a driver not
quiescing "DMA" as it probably should have (I wasn't sure if these were separate
capabilities and/or if there was possibly a valid reason for a driver
leaving "DMA"
in an enabled state upon shutdown - i.e. Wake on LAN or something similar).

Myron

> I am digging through
> old internal bug reports and will let you know once I find that original
> bug report.
>
> ====================================================================
> Khalid Aziz                                         Unix Systems Lab
> (970)898-9214                                        Hewlett-Packard
> khalid.aziz@hp.com                                  Fort Collins, CO
>
