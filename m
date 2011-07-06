Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab1GFHJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 03:09:49 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:17463 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab1GFHJs convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Wed, 6 Jul 2011 03:09:48 -0400
Message-Id: <4E142659020000780004C50D@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 06 Jul 2011 08:09:45 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Cc: <mingo@elte.hu>, <rtc-linux@googlegroups.com>, <dannf@hp.com>,
        <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: enable rtc-efi
References: <4E12DBAB020000780004C1B2@nat28.tlf.novell.com>
 <20110705182913.GA31808@srcf.ucam.org>
In-Reply-To: <20110705182913.GA31808@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 05.07.11 at 20:29, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Jul 05, 2011 at 08:38:51AM +0100, Jan Beulich wrote:
>> Besides a Kconfig change this just requires creating a respective
>> platform device.
> 
> Couple of other issues:
> 
>> +static struct platform_device rtc_efi_dev = {
>> +	.name = "rtc-efi",
>> +	.id = -1,
>> +};
> 
> You haven't removed this from the IA64 code. Isn't that going to result 
> in registering the same device twice?

How would code under arch/ia64/ and code under arch/x86/ ever
manage to register the same device twice?

>> +static int __init rtc_init(void)
>> +{
>> +	if (efi_enabled && platform_device_register(&rtc_efi_dev) < 0)
>> +		printk(KERN_ERR "unable to register rtc device...\n");
> 
> Ought to -ENODEV if efi isn't present? The error message should also be 
> more verbose.

I would agree on the -ENODEV part, but the error message is what
the original ia64 code (which I simply copied over and modified
slightly) has, so if a change is needed it ought to be done there first
I would think. Additionally I can't really see what meaningful addition
to the error message you envision.

Jan

