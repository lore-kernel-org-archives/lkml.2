Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab0ISVnb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 17:43:31 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:49677 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752547Ab0ISVna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 17:43:30 -0400
Date: Sun, 19 Sep 2010 23:43:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pekka Enberg <penberg@kernel.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
        Lars Lindley <lindley@coyote.org>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: Re: [PATCH 1/7] w35und: Kill dead HAL macros in wbhal_f.h
Message-ID: <20100919214322.GD12416@elf.ucw.cz>
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

Aha, I should have read the description.

> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Ruslan Pisarev <ruslan@rpisarev.org.ua>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>
> ---
>  drivers/staging/winbond/phy_calibration.c |   20 --------------------
>  drivers/staging/winbond/wbhal_f.h         |   10 ----------
>  2 files changed, 0 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
> index 5c1f053..2b375ba 100644
> --- a/drivers/staging/winbond/phy_calibration.c
> +++ b/drivers/staging/winbond/phy_calibration.c
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

These are macros that do nothing. ACK the patch.

							Pavel


> --- a/drivers/staging/winbond/wbhal_f.h
> +++ b/drivers/staging/winbond/wbhal_f.h
> @@ -78,14 +78,4 @@ u32 hal_get_bss_pk_cnt(struct hw_data *hw_data);
>  #define hal_get_time_count(_P)		(_P->time_count / 10)
>  #define hal_detect_error(_P)		(_P->WbUsb.DetectCount)
>  
> -/* The follow function is unused for IS89C35 */
> -#define hal_disable_interrupt(_A)
> -#define hal_enable_interrupt(_A)
> -#define hal_get_interrupt_type(_A)
> -#define hal_get_clear_interrupt(_A)
>  #define hal_ibss_disconnect(_A)		(hal_stop_sync_bss(_A))
> -#define hal_join_request_stop(_A)
> -#define hw_get_cxx_reg(_A, _B, _C)
> -#define hw_set_cxx_reg(_A, _B, _C)
> -
> -

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
