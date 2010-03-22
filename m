Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab0CVPLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 11:11:19 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:51050 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab0CVPLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 11:11:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Byb5nQFfAtsH8BF8j9uFiTlDsdeWR6PnPAIvf1FsKrb5LvI0+O65SQ4L8D0mDU6BFG
         +ctD5R+TQsMCKtvISjBwHej9qiY8cRkkMTWkDAUR3PvFxHEWZz5WvwDx5TpQUOads9wS
         qpgHzLclzyzanPD+OmljeSN0/PenwTa/ebmwQ=
Date: Mon, 22 Mar 2010 18:11:07 +0300
From: Dan Carpenter <error27@gmail.com>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: phy_calibration.c Coding style fixes
	1/2.
Message-ID: <20100322151107.GS21571@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Lars Lindley <lindley@coyote.org>, gregkh@suse.de, greg@kroah.com,
	penberg@cs.helsinki.fi, pavel@ucw.cz, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1269267447-6245-1-git-send-email-lindley@coyote.org> <20100322142924.GA23411@bicker> <4BA783AA.8060108@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA783AA.8060108@coyote.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 03:50:18PM +0100, Lars Lindley wrote:
> On 2010-03-22 15:29, Dan Carpenter wrote:
> > On Mon, Mar 22, 2010 at 03:17:26PM +0100, Lars Lindley wrote:
> >> Whitespace and indentation fixes. Removed "commented away"
> >> code and revision comments.
> >> Checked with Dan Carpenters strip_whitespace.pl and diff.
> >> Compiles fine and .o file is identical before and after.
> >>
> > 
> > 	[ snip ]
> > 
> >> -#ifdef _DEBUG
> >> +	/* e. The result are shown in "adc_dc_cal_i[8:0] and adc_dc_cal_q[8:0]" */
> >> +	#ifdef _DEBUG
> >>  	hw_get_dxx_reg(phw_data, REG_OFFSET_READ, &val);
> >>  	PHY_DEBUG(("[CAL]    REG_OFFSET_READ = 0x%08X\n", val));
> >>  
> >>  	PHY_DEBUG(("[CAL]    ** adc_dc_cal_i = %d (0x%04X)\n",
> >> -			   _s9_to_s32(val&0x000001FF), val&0x000001FF));
> >> +			_s9_to_s32(val & 0x000001FF), val & 0x000001FF));
> >>  	PHY_DEBUG(("[CAL]    ** adc_dc_cal_q = %d (0x%04X)\n",
> >> -			   _s9_to_s32((val&0x0003FE00)>>9), (val&0x0003FE00)>>9));
> >> -#endif
> >> +			_s9_to_s32((val & 0x0003FE00) >> 9), (val & 0x0003FE00) >> 9));
> >> +	#endif
> >>  
> > 
> > #ifdef and #endif shouldn't be indented.
> > 
> > I'm really happy that you're using my script.  It feels more relaxing to 
> > review these when I know that no bugs were introduced.
> > 
> > regard,
> > dan carpenter
> > 
> 
> Hi Dan.
> 
> It feels good to me to.
> When you sit with repetitive editing for a couple of hours you're
> bound to make a mistake or two. :)
> 
> I made a new patch that applies after these two that fixes the indentation.
> When we have acks for all the parts I can combine them into one patch.
> 

Other people may have different ideas but to me it seems cool to just
apply them as a patch series.  This really is an easier way to review
them.

In the last patch we combined them because that was really supposed to
be one patch.  It's silly to apply a patch series where the latter patches
are to fix problems introduced earlier in the same series.

regards,
dan carpenter

> Regards
> Lars
> 
> 
> 
> 
> 
> [PATCH] staging: winbond: phy_calibration.c de-indent #ifdefs etc.
> 
> Removed indentation of the #ifdefs etc.
> This applies after patch in:
> Message-Id: <1269267447-6245-2-git-send-email-lindley@coyote.org>
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>
> ---
>  drivers/staging/winbond/phy_calibration.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
> index 5e53af3..cfc2c3a 100644
> --- a/drivers/staging/winbond/phy_calibration.c
> +++ b/drivers/staging/winbond/phy_calibration.c
> @@ -394,7 +394,7 @@ void _rxadc_dc_offset_cancellation_winbond(struct hw_data *phw_data, u32 frequen
>  	hw_set_dxx_reg(phw_data, REG_MODE_CTRL, val);
>  
>  	/* e. The result are shown in "adc_dc_cal_i[8:0] and adc_dc_cal_q[8:0]" */
> -	#ifdef _DEBUG
> +#ifdef _DEBUG
>  	hw_get_dxx_reg(phw_data, REG_OFFSET_READ, &val);
>  	PHY_DEBUG(("[CAL]    REG_OFFSET_READ = 0x%08X\n", val));
>  
> @@ -402,7 +402,7 @@ void _rxadc_dc_offset_cancellation_winbond(struct hw_data *phw_data, u32 frequen
>  			_s9_to_s32(val & 0x000001FF), val & 0x000001FF));
>  	PHY_DEBUG(("[CAL]    ** adc_dc_cal_q = %d (0x%04X)\n",
>  			_s9_to_s32((val & 0x0003FE00) >> 9), (val & 0x0003FE00) >> 9));
> -	#endif
> +#endif
>  
>  	hw_get_dxx_reg(phw_data, REG_MODE_CTRL, &val);
>  	val &= ~MASK_ADC_DC_CAL_STR;
> @@ -926,10 +926,10 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
>  void _tx_iq_calibration_winbond(struct hw_data *phw_data)
>  {
>  	u32	reg_agc_ctrl3;
> -	#ifdef _DEBUG
> +#ifdef _DEBUG
>  	s32	tx_cal_reg[4];
>  
> -	#endif
> +#endif
>  	u32	reg_mode_ctrl;
>  	u32	val;
>  	u8	result;
> @@ -1036,7 +1036,7 @@ void _tx_iq_calibration_winbond(struct hw_data *phw_data)
>  	reg_agc_ctrl3 &= ~(MASK_LNA_FIX_GAIN | MASK_AGC_FIX);
>  	hw_set_dxx_reg(phw_data, REG_AGC_CTRL3, reg_agc_ctrl3);
>  
> -	#ifdef _DEBUG
> +#ifdef _DEBUG
>  	if (phw_data->revision == 0x2002) { /* 1st-cut */
>  		hw_get_dxx_reg(phw_data, 0x54, &val);
>  		PHY_DEBUG(("[CAL]    ** 0x54 = 0x%08X\n", val));
> @@ -1342,10 +1342,10 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
>  
>  void _rx_iq_calibration_winbond(struct hw_data *phw_data, u32 frequency)
>  {
> -	#ifdef _DEBUG
> +#ifdef _DEBUG
>  	s32	rx_cal_reg[4];
>  	u32	val;
> -	#endif
> +#endif
>  
>  	u8	result;
>  
> @@ -1389,7 +1389,7 @@ void _rx_iq_calibration_winbond(struct hw_data *phw_data, u32 frequency)
>  		}
>  	}
>  
> -	#ifdef _DEBUG
> +#ifdef _DEBUG
>  	hw_get_dxx_reg(phw_data, 0x54, &val);
>  	PHY_DEBUG(("[CAL]    ** 0x54 = 0x%08X\n", val));
>  
> @@ -1409,7 +1409,7 @@ void _rx_iq_calibration_winbond(struct hw_data *phw_data, u32 frequency)
>  	PHY_DEBUG(("[CAL]       rx_cal_reg[1] = %d\n", rx_cal_reg[1]));
>  	PHY_DEBUG(("[CAL]       rx_cal_reg[2] = %d\n", rx_cal_reg[2]));
>  	PHY_DEBUG(("[CAL]       rx_cal_reg[3] = %d\n", rx_cal_reg[3]));
> -	#endif
> +#endif
>  }
>  
>  void phy_calibration_winbond(struct hw_data *phw_data, u32 frequency)
> -- 
> 1.7.0.2
