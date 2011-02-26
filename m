Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab1BZNuH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 08:50:07 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53046 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab1BZNuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 08:50:05 -0500
Message-ID: <4D69050B.2050504@linux.vnet.ibm.com>
Date: Sat, 26 Feb 2011 08:50:03 -0500
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: preining@logic.at,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        "debora@linux.vnet.ibm.com" <debora@linux.vnet.ibm.com>
Subject: Re: [PATCH] tpm_tis: Re-enable interrupts upon resume
References: <1298404199.25819.15.camel@d941e-10> <4D68E80B.90001@gmail.com>
In-Reply-To: <4D68E80B.90001@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2011 06:46 AM, Jiri Slaby wrote:
> On 02/22/2011 08:49 PM, Stefan Berger wrote:
>> Below patch applies to the tip of the git tree.
>>
>> This patch makes sure that if the TPM TIS interface is run in interrupt
>> mode (rather than polling mode) that the interrupts are enabled in the
>> TPM's interrupt enable register which may either have been cleared by
>> the TPM's TIS loosing its state during device sleep in ACPI S3 (suspend)
>> or by the BIOS, which upon resume sends a TPM_Startup() command to the
>> TPM, and may run the TPM in polling mode and leave the TIS interrupts
>> disabled once it transfers control to the OS again.
>>
>> Problem is, I don't currently have a machine running the TPM in
>> interrupt mode. I found this through a self-built TPM device model for
>> Qemu and SeaBIOS patches, where this does resolve a problem upon resume.
>>
>> You may want to check if your TPM runs with interrupts by doing
>>
>> cat /proc/interrupts | grep -i tpm
> No, this is empty output.
Ok. That's what most TPM seem to do now -- they run in polling mode.

   Stefan

