Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab0K2WLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:11:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50620 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab0K2WLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:11:47 -0500
Message-ID: <4CF424D1.50509@zytor.com>
Date: Mon, 29 Nov 2010 14:10:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] x86/PCI: never allocate PCI space from the last 1M below
 4G
References: <20101129183009.11256.33739.stgit@bob.kio> <201011291432.51264.bjorn.helgaas@hp.com> <4CF41C89.9060708@zytor.com> <201011291504.40536.bjorn.helgaas@hp.com>
In-Reply-To: <201011291504.40536.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2010 02:04 PM, Bjorn Helgaas wrote:
>>
>>> We might still want a patch like this current one because it could
>>> work around some BIOS defects, and because I think it's too late to
>>> fix the ACPI resource problem for .37.  But I'm not convinced we
>>> should reserve more than Windows does, because that may keep us from
>>> discovering other important Linux problems.
>>
>> I'm not so sure about that... it feels like a pretty weak argument that
>> we might work on some machines even though our code isn't perfect.
> 
> I think we're talking about whether to reserve the top 1MB or top 2MB.
> I freely admit I don't know the right answer.  My point is merely that
> since we're using a heuristic anyway, copying Windows is a pretty good
> starting point.  In my mind, doing something different requires a
> stronger argument than "it might fix some machines where Windows is
> broken."
> 

Of course.  I did, however, point out the reason *why* in this case:
there are a lot of platforms known (including quite probably *ALL*
pre-E820 systems) to decode 2 MiB for the ROM, due to A20 masking.
Windows doesn't care about those older systems.

	-hpa
