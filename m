Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592Ab0FCCFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 22:05:54 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34895 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933549Ab0FCCFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 22:05:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MktQ0SvFW8CYtCkRGB6C8CDgEEnpyCJSiY/IRCzRjLcjGoPP0/bjHEjJhhMhmd9gX0
         besvErCSF/fLavS2Y66d+LCbgAKpApvR4AvODOlg2RFfygIlPaMiAelkB1OgbUDO01LH
         7DaYTF3QdY/WAzXJi4n4vliPFmddpf1q2MqVc=
Message-ID: <4C070E16.6080301@gmail.com>
Date: Wed, 02 Jun 2010 19:06:14 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Robert Hancock <hancockrwd@gmail.com>, x86@kernel.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to	pci_reboot_dmi_table.
References: <4C05E800.1010400@gmail.com> <4C05F3BF.6090503@gmail.com> <AANLkTinyxtHQrsgvV0CMQZnyEelVnrpCTM05PLAj-ZYx@mail.gmail.com> <4C06ECAA.3060708@gmail.com> <4C06ED18.2010400@gmail.com> <4C06F1DD.8060004@gmail.com> <AANLkTilQuun1jQc394YM4QZtDSVeIwh67_Np0mkRDes4@mail.gmail.com> <4C06F6EA.6090701@gmail.com> <20100603013758.GA18755@srcf.ucam.org> <AANLkTik1cjxh1ItnqBXaxNcwa6we7ccJJZny-mAOAUjD@mail.gmail.com> <20100603015659.GA19123@srcf.ucam.org>
In-Reply-To: <20100603015659.GA19123@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 06:56 PM, Matthew Garrett wrote:
> On Wed, Jun 02, 2010 at 07:47:17PM -0600, Robert Hancock wrote:
>> On Wed, Jun 2, 2010 at 7:37 PM, Matthew Garrett<mjg59@srcf.ucam.org>  wrote:
>>> That's pretty infuriating. The ACPI-provided definition doesn't work,
>>> and there's no ACPI mechanism for expressing the more complex cf9
>>> behaviour. Windows doesn't appear to special case this, so we're
>>> probably left trying to figure out why the keyboard controller method
>>> doesn't work. Sigh.
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
>
> #include<sys/io.h>
> #include<unistd.h>
>
> int main() {
> 	iopl(3);
> 	outb(6, 0xcf9);
> 	usleep(100);
> 	outb(6, 0xcf9);
> 	return 0;
> }
>
> and see if that reboots?
>


this thing is wacked out
this just rebooted the system:

int main() {
            iopl(3);
            outb(6, 0xcf9);
            return 0;
}

and now it's motionless
(just a command prompt).

Justin P. Mattock
