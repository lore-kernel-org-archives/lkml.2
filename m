Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1GHHKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 03:10:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54385 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1GHHKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 03:10:07 -0400
Date: Fri, 8 Jul 2011 08:09:52 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: mingo@elte.hu, rtc-linux@googlegroups.com, dannf@hp.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: enable rtc-efi
Message-ID: <20110708070952.GA3004@srcf.ucam.org>
References: <4E16B5DB0200007800072A2D@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E16B5DB0200007800072A2D@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 07:46:35AM +0100, Jan Beulich wrote:

>    Having thought some more about this, I don't think this should be
>    handled in the RTC driver. Instead, arch/x86/platform/efi/efi.c ought
>    to be handling this - also for all other eventual callers of the time
>    related calls. In other words, the bug has been existing before my
>    patch (and it just exposes it by introducing callers of the incompletely
>    implemented backing functions).

I'm in the process of removing this code from arch/x86, since it's 
functionally identical to the IA64 version. That's probably going to 
complicate this approach a little, but you're right that it makes sense 
for the locking to be at the backend rather than in rtc-efi.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
