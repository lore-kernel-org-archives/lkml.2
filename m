Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030719Ab2CTQaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:30:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34320 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420Ab2CTQaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:30:07 -0400
Date: Tue, 20 Mar 2012 16:30:02 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] ACPI / Video: blacklist some samsung laptops
Message-ID: <20120320163002.GB6811@srcf.ucam.org>
References: <1332233594-13099-1-git-send-email-corentin.chary@gmail.com>
 <1332233594-13099-2-git-send-email-corentin.chary@gmail.com>
 <20120320160537.GB6192@srcf.ucam.org>
 <CAHR064gLwW32y511tAEf4x59QEaWQzy-i=K7jF8YYC3GS4JHow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHR064gLwW32y511tAEf4x59QEaWQzy-i=K7jF8YYC3GS4JHow@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 05:28:06PM +0100, Corentin Chary wrote:
> On Tue, Mar 20, 2012 at 5:05 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > Are the hotkeys delivered via ACPI or via the Samsung device? If the
> > latter, you can just do unregister_acpi_video() instead in the samsung
> > driver and avoid having more machine-specific quirks in the ACPi code.
> 
> I wasn't aware of acpi_video_unregister(). The issue with that
> solution is that it makes it harder to respect acpi_video= parameter.
> 
> On these machines, the ACPI Video device is broken (I don't know how,
> I don't have the hardware, I just know it doesn't work at all), and I
> want the default to be acpi_backlight=vendor, but it is still a good
> idea to let users force acpi_backlight=video.

If it's broken then I don't think there's a great argument for providing 
an argument just to let people re-break their kernel :)

> But if the policy is to use acpi_video_unregister() when the video
> module is known to be broken, let's do that.

As long as ACPI isn't being used to deliver brightness keys, then this 
is fine.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
