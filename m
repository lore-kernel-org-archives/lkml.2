Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1EHOFv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 10:05:51 -0400
Received: from smtpout05.highway.telekom.at ([195.3.96.77]:29209 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751109Ab1EHOFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 10:05:50 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: "Joey Lee" <jlee@novell.com>
Subject: Re: i915/kms/backlight-combo mode problem
Date: Sun, 8 May 2011 16:05:46 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.5; KDE/4.6.2; x86_64; ; )
Cc: chris@chris-wilson.co.uk, dri-devel@lists.freedesktop.org, tiwai@suse.de,
        linux-kernel@vger.kernel.org
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com> <201105072222.41807@rk-nord.at> <4DC72A34020000230002C541@novprvlin0050.provo.novell.com>
In-Reply-To: <4DC72A34020000230002C541@novprvlin0050.provo.novell.com>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201105081605.46617@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joey Lee -- Sunday 08 May 2011:
> 於 六，2011-05-07 於 22:22 +0200，Melchior FRANZ 提到：
> > It has turned out that acpi key events seem to be handled correctly
> > and even the state of /sys/class/backlight/acer-wmi/brightness is
> 
> That's interesting for acer-wmi generated brightness interface when this
> machine declare acpi brightness interface in DSDT.

I'm sorry to give contradicting info. Yesterday I saw a subdir acer-wmi
(or acer_wmi) in /sys/class/backlight/ during one of my tests (with/without
acer_wmi, with/without acpi_osi=Linux). Now I left acpi_osi=Linux
away and allow acer_wmi, and it's subdir acpi_video0. Next time I'll
make notes.



> Does it work to you direct control brightness by access
> by /sys/class/backlight/acer-wmi/brightness ?

No. A number written to this virtual file is accepted and remembered,
but it doesn't actually change the brightness. It takes setpci to do
that. 


 
> As I remember, use setpci to control brightness is not recommended
> because BIOS or ACPI will also touch brightness level. That will be
> better control brightness by the function that was provided by BIOS. 
> e.g. ACPI or WMI interface, or direct control by EC.

Well, sounds plausible. And I wouldn't do it if it weren't the only
way at the moment.  :-)



> That means that will be better fix your Fn key control brightness like
> before, you just need press Fn key to change brightness and don't need
> have any workaround.

OK. I have added a lot of debug messages to intel_panel.c yesterday.
All it told me was that it seems to work correctly wiht acpi_osi=Linux.
Except that it doesn't actually change the brightness. Without acpi_osi
the functions aren't called at all and none of my messages showed up.



> Looks like current status is we try to fix bko#31522 but the patch
> causes your brightness no work by press Fn key even with acpi_osi=Linux.
> Does it right?

The history is: with acpi_osi=Linux everything worked with 2.6.38-rc8.
With 2.6.38 the screen stayed black. The patch that only ignored lbpc=0
worked (IIRC) including key adjustment. Later patches broke keys.



> 	replace acpi_osi=Linux by acpi_osi="!Windows 2006"
> 
> Does it also works to you for backlight control?

No, doesn't work.

m.
