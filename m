Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab0EMVFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:05:55 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:40060 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab0EMVFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:05:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=mrVG/31Or9nEMLGkMwt17ywIowLKO82CwXq5VHpZWOXc2/z/5CQH4hfgrmeXBkKo4t
         DeQ8nirTGahFk9xEAJX2VQEND93u5Cb45O9MId0srGREfR8iKnIYfY5YgGPvHm/sUalt
         gKN/+FejYUkjAqk8cf9o//LflFZgCPepHP3v8=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
Date: Thu, 13 May 2010 14:05:44 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc7; KDE/4.4.2; x86_64; ; )
Cc: lenb@kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20100513075728.GF30110@core.coreip.homeip.net> <20100513181002.GB23708@core.coreip.homeip.net> <alpine.LFD.2.00.1005131232350.3711@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005131232350.3711@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005131405.45732.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 May 2010 12:40:43 pm Linus Torvalds wrote:
> On Thu, 13 May 2010, Dmitry Torokhov wrote:
> > You don't have anything plugged into the ports though, do you?
> 
> No. It's a modern machine. But the port is there, and we've been very good
> at booting up and finding keyboards later (I've done it myself - headless
> machines that you hotplug a PS/2 keyboard into: it's not necessarily
> technically something you're supposed to do, but it has worked fine for
> me).
> 
> > I wonder what your DSDT looks like.

[... pulling LKML back in...]

Lookie, lookie:

                Device (PS2K)
                {
                    Name (_HID, EisaId ("PNP0303"))
                    Name (_CID, EisaId ("PNP030B"))
                    Method (_STA, 0, NotSerialized)
                    {
                        ShiftLeft (One, 0x0A, Local0)
                        If (And (IOST, Local0))
                        {
                            Return (0x0F)
                        }

                        Return (Zero)
                    }
...

                Device (PS2M)
                {
                    Name (_HID, EisaId ("PNP0F03"))
                    Name (_CID, EisaId ("PNP0F13"))
                    Method (_STA, 0, NotSerialized)
                    {

But I guess because there are no devices plugged in ACPI they are "inactive" 
and thus ACPI drop them. I was always wondered by ACPI did that. Len?

-- 
Dmitry
