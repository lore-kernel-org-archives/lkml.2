Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab1HXXEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 19:04:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54334 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab1HXXEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 19:04:30 -0400
Message-ID: <4E55836D.8030209@zytor.com>
Date: Wed, 24 Aug 2011 16:04:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/4] x86: base support for the TS-5500 platform
References: <1314217407-31249-1-git-send-email-vivien.didelot@savoirfairelinux.com> <1314217407-31249-2-git-send-email-vivien.didelot@savoirfairelinux.com> <4E55670F.90102@zytor.com> <20110824180837.6841f3d8@v0nbox> <4E5576CF.2050905@zytor.com> <20110824183814.64abc94c@v0nbox>
In-Reply-To: <20110824183814.64abc94c@v0nbox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 03:38 PM, Vivien Didelot wrote:
> 
> I agree with you. The platform does not provide many identification
> points. We have specific hardware such as the CPU, Ethernet, Cardbus
> and USB controllers; there is no DMI available; no PCI bridge subvendor
> info, only the BIOS provides a 16-bit identification call...
> We discussed that point in https://lkml.org/lkml/2011/5/4/437 without
> success.
> 
> What would be the proper way in your opinion?
> 
> Vivien.

First of all, given that these clowns seem to be selling a product
specifically targeting Linux support, they really need to be given a
clue transfusion.  It is *NOT* acceptable to not provide DMI, and *NOT*
acceptable not to set the subvendor information.

We should arguably push for them to fix that in their BIOSes, but that
is as usual too little, too late.

Probably the best option we have is to look for some kind of magic
string in their BIOS -- i.e. the classic way to detect things before DMI
existed.

If not, you're going to have an explicit switch on the kernel command
line, but that is an absolute last resort.

	-hpa
