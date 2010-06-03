Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640Ab0FCCWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 22:22:00 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39714 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933577Ab0FCCV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 22:21:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XcI+UPtIONu2MgPdEfeWRKlDAB4rrMJlUS2x6okgqA8hJ/YSLyz4/2K1YFbuPwYb9Z
         aOyrdooQiYNNO6ShFRIqzhylqBY5PzQDHnA5ZAAmfIyncdqzH+v/uTg0dz2jVFTfodhQ
         Kqq0mt300lxw9BNs9AlY7P4y8oDxx/MrF+lM4=
Message-ID: <4C0711DC.5030104@gmail.com>
Date: Wed, 02 Jun 2010 19:22:20 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Robert Hancock <hancockrwd@gmail.com>, x86@kernel.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to	pci_reboot_dmi_table.
References: <4C05F3BF.6090503@gmail.com> <AANLkTinyxtHQrsgvV0CMQZnyEelVnrpCTM05PLAj-ZYx@mail.gmail.com> <4C06ECAA.3060708@gmail.com> <4C06ED18.2010400@gmail.com> <4C06F1DD.8060004@gmail.com> <AANLkTilQuun1jQc394YM4QZtDSVeIwh67_Np0mkRDes4@mail.gmail.com> <4C06F6EA.6090701@gmail.com> <20100603013758.GA18755@srcf.ucam.org> <AANLkTik1cjxh1ItnqBXaxNcwa6we7ccJJZny-mAOAUjD@mail.gmail.com> <4C071048.9040209@gmail.com> <20100603021851.GA19546@srcf.ucam.org>
In-Reply-To: <20100603021851.GA19546@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 07:18 PM, Matthew Garrett wrote:
> On Wed, Jun 02, 2010 at 07:15:36PM -0700, Justin P. Mattock wrote:
>> as soon as I change:
>>
>> int main() {
>> 	iopl(3);
>> 	outb(6, 0xcf9);
>> 	usleep(100);
>> 	outb(6, 0xcf9);
>> 	return 0;
>> }
>> (the above gave a command prompt
>> with numerous tries)
>
> Ok, so it's not that straghtforward. Sigh. There's various hacky
> workarounds we could do here, but Windows doesn't seem to do them so I
> lean towards suspecting that there's something wrong with our keyboard
> controller reboot mechanism. I'll try doing some more tracing.
>


I'll keep looking around as well(the best I can)

FWIW not sure if this means anything but


grep PS *.dsl

gives:


SPST,   1,
         PSVT,   8,
         PSCL,   8,
         APPS,   1,
                         PSI0,   8,
                         PSI1,   8,
                             If (PSI0)
                             Store (0x00, PSI0)
                                 Return (CRS (PSI0))
                                 Return (CRSI (PSI0))
                                 Store (SRS (Arg0), PSI0)
                                 Store (SRSI (Arg0), PSI0)
                             If (PSI1)
                             Store (0x00, PSI1)
                                 Return (CRS (PSI1))
                                 Return (CRSI (PSI1))
                                 Store (SRS (Arg0), PSI1)
                                 Store (SRSI (Arg0), PSI1)
                 Method (_PSW, 1, NotSerialized)
                 Name (PSIT, 0x00)
                     Method (_PS0, 0, Serialized)
                     Method (_PS3, 0, Serialized)
                     Method (_PS0, 0, Serialized)
                                 Store (0x00, APPS)
                     Method (_PS3, 0, Serialized)
                                 Store (0x01, APPS)


there's no such thing as a PS/3 is there?

Justin P. Mattock
