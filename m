Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab1E3Onw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:43:52 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48155 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab1E3Onu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:43:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RnSstxNOOzO0ESUjV8M/O/OP3/ah02Uv3jy2Et1IqfL1AULH9jtt+W0A1cjNaCqjSC
         GocUE34OU2t6V3LaoH+5HQx+QlIxteNNNX3ldPBnogRMaye21r/SZJPU9QT4RhLVqx9V
         hKhqnnus2jrU8hf0ax2A89GB20QaK67GUwfBw=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=h5f6o3iVK24sQ20xYYQAMbLavMg@mail.gmail.com>
References: <1305248699-2347-1-git-send-email-daniel.blueman@gmail.com>
	<69e8f8a9-4e8b-4c02-b566-304ff837d166@email.android.com>
	<BANLkTi=h5f6o3iVK24sQ20xYYQAMbLavMg@mail.gmail.com>
Date: Mon, 30 May 2011 22:43:49 +0800
Message-ID: <BANLkTik9BtnXxsOGKuhmoUFsKPbhBwXr3A@mail.gmail.com>
Subject: Re: [PATCH] x86: Add Dell E5420 reboot quirk
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi hpa, Thomas, Ingo,

On 13 May 2011 11:16, Daniel J Blueman <daniel.blueman@gmail.com> wrote:
> On 13 May 2011 10:44, H. Peter Anvin <hpa@zytor.com> wrote:
>> Daniel J Blueman <daniel.blueman@gmail.com> wrote:
>>> Rebooting on the Dell E5420 often hangs with the keyboard method, but is
>>> reliable via the PCI method. Signed-off-by: Daniel J Blueman
>>> <daniel.blueman@gmail.com> --- arch/x86/kernel/reboot.c | 8 ++++++++ 1 files
>>> changed, 8 insertions(+), 0 deletions(-) diff --git
>>> a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c index 08c44b0..b16032d
>>> 100644 --- a/arch/x86/kernel/reboot.c +++ b/arch/x86/kernel/reboot.c @@
>>> -411,6 +411,14 @@ static struct dmi_system_id __initdata
>>> pci_reboot_dmi_table[] = { DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"), }, }, + {
>>> + .callback = set_pci_reboot, + .ident = "Dell Latitude E5420", + .matches =
>>> { + DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."), + DMI_MATCH(DMI_PRODUCT_NAME,
>>> "Latitude E5420"), + }, + }, { } }; -- 1.7.4.1
>
>> How does it work with ACPI?
>
> All other reboot methods including ACPI are unreliable and seem to
> demonstrate the same failure probability; PCI is the only reliable
> method alas.
>
> I guess the ACPI reboot method is the supported 'official' vector (and
> is what Windows uses [1]), so there must be some other constraints
> preventing it work as expected, unless the ACPI tables delivered to
> Linux are broken, would you say?
>
> Daniel
>
> [1] http://comments.gmane.org/gmane.linux.kernel/1122388

Without this patch, rebooting is like Russian roulette; with quite a
few of these laptops in the field, perhaps it is better to enable the
quirk unless you think there may be an issue in the kernel preventing
correct behaviour that I could debug?

On the other hand, Dell may later fix the BIOS AML (seen with the
excellent fwts) just as the cure for cancer is found. If they do, I'll
buy whiskey too.

Thanks,
  Daniel
-- 
Daniel J Blueman
