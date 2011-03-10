Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab1CJPcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:32:33 -0500
Received: from smtprelay02.ispgateway.de ([80.67.31.29]:43245 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab1CJPcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:32:31 -0500
Message-ID: <4D78EF5C.5090504@ladisch.de>
Date: Thu, 10 Mar 2011 16:33:48 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Roland Dreier <roland@purestorage.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Micha Nelissen <micha@neli.hopto.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Add support for multiple MSI on x86
References: <4D583E31.4070507@neli.hopto.org> <20110304103634.4641ae36@jbarnes-desktop> <4D714357.3010807@neli.hopto.org> <alpine.LFD.2.00.1103082143460.2787@localhost6.localdomain6> <35bd5f56-658b-48e3-a376-b07350a29cf6@email.android.com> <alpine.LFD.2.00.1103082215300.2787@localhost6.localdomain6> <AANLkTinrzY56cwB6OX6xcAb5ZWJcZC5cr-knLkCDPy6p@mail.gmail.com>
In-Reply-To: <AANLkTinrzY56cwB6OX6xcAb5ZWJcZC5cr-knLkCDPy6p@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> > Yes, but there are MSI devices in the field...
> 
> But do any of them benefit from having multiple interrupt vectors available?
> 
> If I recall correct, willy was motivated by AHCI performance to try this out,
> and in the end things didn't go any faster using multiple MSI.
> 
> The big win with multiple interrupt vectors is when you have independent
> queues that you can point different CPUs at, and give each CPU its own
> interrupt.

And this is how AHCI is designed, but libahci.c currently wraps its
interrupt handler in a device-wide lock.  I don't know if that test also
reorganized the driver code.


Regards,
Clemens
