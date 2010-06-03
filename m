Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964Ab0FCBiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 21:38:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46561 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588Ab0FCBiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 21:38:09 -0400
Date: Thu, 3 Jun 2010 02:37:58 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, x86@kernel.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to
	pci_reboot_dmi_table.
Message-ID: <20100603013758.GA18755@srcf.ucam.org>
References: <20100601212901.GA18390@srcf.ucam.org> <4C057EF0.2030808@gmail.com> <4C05E800.1010400@gmail.com> <4C05F3BF.6090503@gmail.com> <AANLkTinyxtHQrsgvV0CMQZnyEelVnrpCTM05PLAj-ZYx@mail.gmail.com> <4C06ECAA.3060708@gmail.com> <4C06ED18.2010400@gmail.com> <4C06F1DD.8060004@gmail.com> <AANLkTilQuun1jQc394YM4QZtDSVeIwh67_Np0mkRDes4@mail.gmail.com> <4C06F6EA.6090701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C06F6EA.6090701@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 05:27:22PM -0700, Justin P. Mattock wrote:
> On 06/02/2010 05:20 PM, Robert Hancock wrote:
>> #include<unistd.h>
>>
>> int main() {
>>          iopl(3);
>>          outb(2, 0xcf9);
>>          sleep(1);
>>          outb(6, 0xcf9);
>>          return 0;
>> }
>>
>> That's basically what PCI reboot does.
>
> the above code reboot's the machine as it should..
> I can look at that(need to take a break first though)
> and see..

That's pretty infuriating. The ACPI-provided definition doesn't work, 
and there's no ACPI mechanism for expressing the more complex cf9 
behaviour. Windows doesn't appear to special case this, so we're 
probably left trying to figure out why the keyboard controller method 
doesn't work. Sigh.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
