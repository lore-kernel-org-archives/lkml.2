Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1CJCFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 21:05:53 -0500
Received: from na3sys010aog111.obsmtp.com ([74.125.245.90]:34762 "HELO
	na3sys010aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751995Ab1CJCFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 21:05:50 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1103082215300.2787@localhost6.localdomain6>
References: <4D583E31.4070507@neli.hopto.org> <20110304103634.4641ae36@jbarnes-desktop>
 <4D714357.3010807@neli.hopto.org> <alpine.LFD.2.00.1103082143460.2787@localhost6.localdomain6>
 <35bd5f56-658b-48e3-a376-b07350a29cf6@email.android.com> <alpine.LFD.2.00.1103082215300.2787@localhost6.localdomain6>
From: Roland Dreier <roland@purestorage.com>
Date: Wed, 9 Mar 2011 18:05:26 -0800
Message-ID: <AANLkTinrzY56cwB6OX6xcAb5ZWJcZC5cr-knLkCDPy6p@mail.gmail.com>
Subject: Re: [PATCH] Add support for multiple MSI on x86
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Micha Nelissen <micha@neli.hopto.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Matthew Wilcox <matthew@wil.cx>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, but there are MSI devices in the field...

But do any of them benefit from having multiple interrupt vectors available?

If I recall correct, willy was motivated by AHCI performance to try this out,
and in the end things didn't go any faster using multiple MSI.

The big win with multiple interrupt vectors is when you have independent
queues that you can point different CPUs at, and give each CPU its own
interrupt.  And that type of hardware is pretty certain to support MSI-X.

 - R.
