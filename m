Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab1LSAP4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 19:15:56 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50198 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab1LSAPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 19:15:53 -0500
MIME-Version: 1.0
In-Reply-To: <1324243556.2844.22.camel@deadeye>
References: <1324142068.2825.341.camel@deadeye>
	<CAA9_cmd9KMS3UBsQJ0WxT0rtQJVWceVwxvyXtRD+PuzwjUHUGA@mail.gmail.com>
	<1324243556.2844.22.camel@deadeye>
Date: Sun, 18 Dec 2011 16:15:53 -0800
X-Google-Sender-Auth: NdYVkwMEC1W-OAUgy0yXZbmb4Bk
Message-ID: <CAA9_cmdSE7njUQgEZkA+WKP=0is3fRiaxCMvPxg7i=vgn1Auuw@mail.gmail.com>
Subject: Re: [RFC][PATCH linux-firmware] isci: Add firmware blob and sources
From: Dan Williams <dan.j.williams@intel.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 18, 2011 at 1:25 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Sun, 2011-12-18 at 10:59 -0800, Dan Williams wrote:
>> On Sat, Dec 17, 2011 at 9:14 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
>> > isci requires a parameter blob which is usually found in NVRAM, but it
>> > can fall back to loading with request_firmware().  These files are
>> > taken from the Linux source tree where they were wrongly added in
>> > Linux 3.0.
>>
>> Oh, I was of the impression that the external firmware tree was for
>> license incompatible firmware images?
>
> firmware/README.AddingFirmware doesn't say that the licence makes a
> difference.

Sorry, missed that readme.  Yes, should have been added to
firmware.git directly.

>> > ---
>> > I'm a bit unclear on the purpose and use of isci_firmware.bin.  Is it
>> > needed for production hardware?
>>
>> It's a stop gap for platforms with missing or broken oem parameters.
>> It is meant to become vestigial once the platform revisions quiet
>> down.
>>
>> > Does it need to be customised
>> > per-system, or are module parameters sufficient for that?  (If not, why
>> > isn't it built into the driver?)
>>
>> It is customized per system to meet EMI and signal integrity targets
>> of a given platform.
>
> Given this, does it make sense to distribute a binary at all?
>

It defaults to something that is reasonable for a reference platform
and if you end up needing to customize it is easier to distribute a
new binary then move all these settings to module parameters.  That
said, the intent was to start using WARN_TAINT_ONCE() if it ever got
used and phase it out once the platform support stabilized.  It was
certainly convenient to have it in the same tree in the early days of
the driver.  Its use should be waning now.

--
Dan
