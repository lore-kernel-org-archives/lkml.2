Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab1LROBo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 09:01:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab1LROBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 09:01:40 -0500
From: Thomas Renninger <trenn@suse.de>
To: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH 2/4] toshiba_acpi: Support alternate hotkey interfaces
Date: Sun, 18 Dec 2011 15:01:35 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5-5.99.12.5343e5f-desktop; KDE/4.4.4; x86_64; ; )
Cc: Azael Avalos <coproscefalo@gmail.com>, Matthew Garrett <mjg@redhat.com>,
        Len Brown <lenb@kernel.org>, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1323972371-13189-1-git-send-email-seth.forshee@canonical.com> <CAGdLNWFeRD=K0YWwr=r2Rznr1N4B6HMPOUF4vWv1aOZbDy+rEQ@mail.gmail.com> <20111217150742.GA6916@ubuntu-mba>
In-Reply-To: <20111217150742.GA6916@ubuntu-mba>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112181501.36299.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 December 2011 16:07:42 Seth Forshee wrote:
> On Sat, Dec 17, 2011 at 04:32:14AM -0700, Azael Avalos wrote:
> > 2011/12/17 Thomas Renninger <trenn@suse.de>:
> > > On Thursday 15 December 2011 19:06:09 Seth Forshee wrote:
> > > ...
> > >> +static bool toshiba_acpi_i8042_filter(unsigned char data, unsigned char str,
> > >> +                                   struct serio *port)
> > >> +{
> > >> +     if (str & 0x20)
> > >> +             return false;
> > >> +
> > >> +     if (unlikely(data == 0xe0))
> > >> +             return false;
> > >> +
> > >> +     if ((data & 0x7f) == TOS1900_FN_SCAN) {
> > >> +             schedule_work(&toshiba_acpi->hotkey_work);
> > >> +             return true;
> > >> +     }
> > > What have you tried to check whether some other kind of ACPI event
> > > is happening?
> > > Do any acpi/SCI interrupts happen?:
> > > watch -n1 "cat /proc/interrupts |grep acpi"
> > 
> > I already did this, no events whatsoever, I was using a Satellite X205
> > at the time
> 
> I've done similar checks on the NB505, no events.
Ok.

> > > Could it by chance be an EC or other device GPE/SCI?
> > >
> > 
> > Seth mentioned me something about this, but w/o proper docs from
> > Toshiba, we are blindly shooting.
> > 
> > Seth?
> 
> In the DSDTs I've inspected there is an EC query method that looks like
> it handles events for the hotkeys, but I've never been able to find
> anything that will cause the GPE to trigger when the hotkeys are
> pressed.
Be careful, those EC event notifications do not show up in:
/sys/firmware/acpi/interrupts/gpe*
If no acpi irqs are happening (you said you've tried already):
watch -n1 "cat /proc/interrupts |grep acpi"
filtering the key events sounds appropriate.
I see you dig quite a bit already:

> Interestingly, I also saw that the Windows hotkey driver for the NB505
> logs some messages that indicate it's also filtering Fn key presses, and
> I also found that the binary contains the NTFY string. That's not proof
> of anything, but it does suggest that the Windows driver might be doing
> something similar to support hotkeys. Which makes me wonder if the GPE
> works at all.

Nice work.

   Thomas
