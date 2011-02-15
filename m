Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1BONr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 08:47:57 -0500
Received: from server103.greatnet.de ([83.133.97.6]:56961 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1BONrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 08:47:55 -0500
Message-ID: <4D5A8406.3030703@nachtwindheim.de>
Date: Tue, 15 Feb 2011 14:47:50 +0100
From: Henrik Kretzschmar <henne@nachtwindheim.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
        x86@kernel.org, tj@kernel.org, yinghai@kernel.org, ak@linux.intel.com,
        robert.richter@amd.com, weidong.han@intel.com, gleb@redhat.com
Subject: Re: [PATCH 2/6] x86: ifdef enable_IR_x2apic() out
References: <1297677612-12405-1-git-send-email-henne@nachtwindheim.de> <1297677612-12405-2-git-send-email-henne@nachtwindheim.de> <20110214110340.GC7140@elte.hu>
In-Reply-To: <20110214110340.GC7140@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.02.2011 12:03, schrieb Ingo Molnar:
> 
> 
> * Henrik Kretzschmar <henne@nachtwindheim.de> wrote:
> 
>> +#ifdef CONFIG_X86_64
>>  extern void enable_IR_x2apic(void);
>> +#endif
> 
> Cannot we use the CONFIG_X86_X2APIC Kconfig switch here, instead of CONFIG_X86_64?
> 
> enable_IR_x2apic() is not a 64-bit CPU feature.
> 
> Thanks,
> 
> 	Ingo
> 
> 

Thats what I had liked also.

At the time you moved the apic code from x86/kernel it was exactly that way.
But after that, in commit 937582382c71b75b29fbb92615629494e1a05ac0, it was explicitely moved out of
CONFIG_X86_X2APIC, which made that function also compile on 32bit machines, even if its not used there.

Also commit ce69a784504222c3ab6f1b3c357d09ec5772127a enabled the x2apic without interrupt remapping,
which means that CONFIG_X86_X2APIC depends on CONFIG_INTR_REMAP has been bypassed and so Kconfig is
broken/not representing what happens to the code.

So since I dont have an x2apic and therefore cannot test changes,
I decided for CONFIG_X86_64 without touching code which seems to work.

I wish I could offer something better here.

Greets,
Henrik Kretzschmar




