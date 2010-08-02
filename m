Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab0HBVFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 17:05:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49752 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab0HBVFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 17:05:16 -0400
Message-ID: <4C5732DC.8010800@zytor.com>
Date: Mon, 02 Aug 2010 14:04:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: brgerst@gmail.com, Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 6175ddf06b6172046a329e3abfd9c901a43efd2e breaks matroxfb console
References: <201008022150.01037.linux@rainbow-software.org>
In-Reply-To: <201008022150.01037.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 12:49 PM, Ondrej Zary wrote:
> Hello,
> matroxfb (at least with Mystique and Mystique 220) stopped working in 2.6.34 - 
> the screen is completely corrupted. Bisection shows that 
> 6175ddf06b6172046a329e3abfd9c901a43efd2e is first bad commit.
> 
> Reverting 6175ddf06b6172046a329e3abfd9c901a43efd2e in 2.6.34 fixes the problem 
> (1c5b9069e12e20d2fe883076ae0bf73966492108 must be reverted first).
> 

Sounds like another driver which used memcpy_toio() when it should have
used iowrite32_rep() or __iowrite32_copy().

Hmm... is __iowrite32_copy() and iowrite32_rep() redundant?  If so, we
should get rid of the former.

	-hpa

