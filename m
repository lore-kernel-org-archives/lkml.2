Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab1GSLTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 07:19:45 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57045 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab1GSLTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 07:19:44 -0400
Date: Tue, 19 Jul 2011 12:19:34 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: serialize EFI time accesses on rtc_lock
Message-ID: <20110719111933.GA13122@srcf.ucam.org>
References: <4E257E33020000780004E319@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E257E33020000780004E319@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 11:53:07AM +0100, Jan Beulich wrote:
> The EFI specification requires that callers of the time related runtime
> functions serialize with other CMOS accesses in the kernel, as the EFI
> time functions may choose to also use the legacy CMOS RTC.
> 
> Besides fixing a latent bug, this is a prerequisite to safely enable
> the rtc-efi driver for x86, which ought to be preferred over rtc-cmos
> on all EFI platforms.

ACK in principle, although I've just merged this and the IA64 code 
together which makes that more awkward. I can fix it up, though.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
