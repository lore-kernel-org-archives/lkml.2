Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab0ISVmg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 17:42:36 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:49654 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752547Ab0ISVmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 17:42:35 -0400
Date: Sun, 19 Sep 2010 23:42:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pekka Enberg <penberg@kernel.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
        Lars Lindley <lindley@coyote.org>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: Re: [PATCH 1/7] w35und: Kill dead HAL macros in wbhal_f.h
Message-ID: <20100919214227.GC12416@elf.ucw.cz>
References: <1284888523-9625-1-git-send-email-penberg@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284888523-9625-1-git-send-email-penberg@kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Fixes an uninitialized variable access in _rx_iq_calibration_loop_winbond():
> 
>     CC [M]  drivers/staging/winbond/phy_calibration.o
>   drivers/staging/winbond/phy_calibration.c: In function ???_rx_iq_calibration_loop_winbond???:
>   drivers/staging/winbond/phy_calibration.c:1138: warning: ???val??? is used uninitialized in this function
> 

Are you sure this is correct?

> @@ -1132,18 +1132,6 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
>  	PHY_DEBUG(("[CAL] -> [5]_rx_iq_calibration_loop()\n"));
>  	PHY_DEBUG(("[CAL] ** factor = %d\n", factor));
>  
> -
> -/* RF Control Override */
> -	hw_get_cxx_reg(phw_data, 0x80, &val);
> -	val |= BIT(19);
> -	hw_set_cxx_reg(phw_data, 0x80, val);
> -

We pass pointer to val somewhere, set a bit, write it back. Seems ok
to me...?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
