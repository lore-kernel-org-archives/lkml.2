Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595Ab0FCCGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 22:06:36 -0400
Received: from mail-yw0-f179.google.com ([209.85.211.179]:64999 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933519Ab0FCCGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 22:06:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qn7KJ0behlQuO70++mJUXPA1t3lCag6l7Ce71XTFidKWc8+w2t0qAPyxrHXD70xAVz
         Zw07KofVjkzV0lmPZhestYfUqjn+L1GivKz8/OOVNWWNh5ojA6satx0Npz9VzIz8+iG/
         b5h5liqtNqbJ99V6DPWEyrEMm3Yfs17mm0gbs=
MIME-Version: 1.0
In-Reply-To: <20100603015659.GA19123@srcf.ucam.org>
References: <4C05E800.1010400@gmail.com>
	<4C05F3BF.6090503@gmail.com>
	<AANLkTinyxtHQrsgvV0CMQZnyEelVnrpCTM05PLAj-ZYx@mail.gmail.com>
	<4C06ECAA.3060708@gmail.com>
	<4C06ED18.2010400@gmail.com>
	<4C06F1DD.8060004@gmail.com>
	<AANLkTilQuun1jQc394YM4QZtDSVeIwh67_Np0mkRDes4@mail.gmail.com>
	<4C06F6EA.6090701@gmail.com>
	<20100603013758.GA18755@srcf.ucam.org>
	<AANLkTik1cjxh1ItnqBXaxNcwa6we7ccJJZny-mAOAUjD@mail.gmail.com>
	<20100603015659.GA19123@srcf.ucam.org>
Date: Wed, 2 Jun 2010 20:06:33 -0600
Message-ID: <AANLkTiliIp3QiIoMBx0cwsu-komxUbye-JLwRq_IN3n7@mail.gmail.com>
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to pci_reboot_dmi_table.
From: Robert Hancock <hancockrwd@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, x86@kernel.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 7:56 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Jun 02, 2010 at 07:47:17PM -0600, Robert Hancock wrote:
>> On Wed, Jun 2, 2010 at 7:37 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> > That's pretty infuriating. The ACPI-provided definition doesn't work,
>> > and there's no ACPI mechanism for expressing the more complex cf9
>> > behaviour. Windows doesn't appear to special case this, so we're
>> > probably left trying to figure out why the keyboard controller method
>> > doesn't work. Sigh.
>>
>> Do these Macs even have a PC keyboard controller? A recent thread on
>> PS/2 keyboard/mouse controller probing suggests they may not..
>
> Possibly an SMM trap...
>
>> Justin, what happens if you try the simple outb(6, 0xcf9) test program
>> multiple times, does that do anything?
>
> Huh. That might work, yes. Windows does the ACPI write, an i8042 write,
> the ACPI write, another i8042 write and then gives up. If that happens
> sufficiently quickly, this might get us somewhere. Justin, can you try:

If that's the sequence Windows is using then I'm thinking that's
likely what we should be doing as well..
