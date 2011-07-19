Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab1GSRyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 13:54:46 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53893 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab1GSRyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 13:54:43 -0400
Date: Tue, 19 Jul 2011 18:54:32 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Jan Beulich <JBeulich@novell.com>, mingo@elte.hu, tglx@linutronix.de,
        hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: serialize EFI time accesses on rtc_lock
Message-ID: <20110719175432.GA23018@srcf.ucam.org>
References: <4E257E33020000780004E319@nat28.tlf.novell.com>
 <CADZ9YHiBkfcM3jjjJVh_Ydn+uJxjYM6SnDZ=5J3Mmki7fp3NbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADZ9YHiBkfcM3jjjJVh_Ydn+uJxjYM6SnDZ=5J3Mmki7fp3NbQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 11:32:05PM +0600, Rakib Mullick wrote:

> If I'm not missing anything, this implementation (serialization) could
> be simpler by holding rtc_lock at the time of calling those functions.
> I mean, holding rtc_lock before calling EFI services
> virt_efi_get/set_time and virt_efi_get/set_wakeup_time - something
> like below:
> 
>              spin_lock_irqsave(&rtc_lock, flags);
>              efi.get_time = virt_efi_get_time;
>              efi.set_time = virt_efi_set_time;
>              efi.get_wakeup_time = virt_efi_get_wakeup_time;
>              efi.set_wakeup_time = virt_efi_set_wakeup_time;
>             spin_unlock_irqrestore(&rtc_lock, flags);

That's just assigning some function pointers, not actually making the 
calls. There's potentially several routes to each of the calls, so it 
makes sense to do the locking there.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
