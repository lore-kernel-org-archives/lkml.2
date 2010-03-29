Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab0C2EdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 00:33:01 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47740 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750898Ab0C2EdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 00:33:00 -0400
Date: Mon, 29 Mar 2010 06:32:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: wbhal_f.h Coding style fixes.
Message-ID: <20100329043247.GB22696@elf.ucw.cz>
References: <1269796259-8671-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269796259-8671-1-git-send-email-lindley@coyote.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-03-28 19:10:59, Lars Lindley wrote:
> I fixed all checkpatch problems and also converted the
> function arguments from hungarian notation and CamelCase.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>

ACK.

> ---
>  drivers/staging/winbond/wbhal_f.h |  137 +++++++++++++++++++++----------------
>  1 files changed, 79 insertions(+), 58 deletions(-)
> 
> diff --git a/drivers/staging/winbond/wbhal_f.h b/drivers/staging/winbond/wbhal_f.h
> index 64a008d..401c024 100644
> --- a/drivers/staging/winbond/wbhal_f.h
> +++ b/drivers/staging/winbond/wbhal_f.h
> @@ -1,70 +1,91 @@
> -//=====================================================================
> -// Device related include
> -//=====================================================================
> +/*
> + * =====================================================================
> + * Device related include
> + * =====================================================================
> +*/
>  #include "wb35reg_f.h"
>  #include "wb35tx_f.h"
>  #include "wb35rx_f.h"
>  
>  #include "core.h"
>  
> -//====================================================================================
> -// Function declaration
> -//====================================================================================
> -void hal_remove_mapping_key(  struct hw_data * pHwData,  u8 *pmac_addr );
> -void hal_remove_default_key(  struct hw_data * pHwData,  u32 index );
> -unsigned char hal_set_mapping_key(  struct hw_data * adapter,  u8 *pmac_addr,  u8 null_key,  u8 wep_on,  u8 *ptx_tsc,  u8 *prx_tsc,  u8 key_type,  u8 key_len,  u8 *pkey_data );
> -unsigned char hal_set_default_key(  struct hw_data * adapter,  u8 index,  u8 null_key,  u8 wep_on,  u8 *ptx_tsc,  u8 *prx_tsc,  u8 key_type,  u8 key_len,  u8 *pkey_data );
> -void hal_clear_all_default_key(  struct hw_data * pHwData );
> -void hal_clear_all_group_key(  struct hw_data * pHwData );
> -void hal_clear_all_mapping_key(  struct hw_data * pHwData );
> -void hal_clear_all_key(  struct hw_data * pHwData );
> -void hal_set_power_save_mode(  struct hw_data * pHwData,  unsigned char power_save,  unsigned char wakeup,  unsigned char dtim );
> -void hal_get_power_save_mode(  struct hw_data * pHwData,   u8 *pin_pwr_save );
> -void hal_set_slot_time(  struct hw_data * pHwData,  u8 type );
> -#define hal_set_atim_window( _A, _ATM )
> -void hal_start_bss(  struct hw_data * pHwData,  u8 mac_op_mode );
> -void hal_join_request(  struct hw_data * pHwData,  u8 bss_type ); // 0:BSS STA 1:IBSS STA//
> -void hal_stop_sync_bss(  struct hw_data * pHwData );
> -void hal_resume_sync_bss(  struct hw_data * pHwData);
> -void hal_set_aid(  struct hw_data * pHwData,  u16 aid );
> -void hal_set_bssid(  struct hw_data * pHwData,  u8 *pbssid );
> -void hal_get_bssid(  struct hw_data * pHwData,  u8 *pbssid );
> -void hal_set_listen_interval(  struct hw_data * pHwData,  u16 listen_interval );
> -void hal_set_cap_info(  struct hw_data * pHwData,  u16 capability_info );
> -void hal_set_ssid(  struct hw_data * pHwData,  u8 *pssid,  u8 ssid_len );
> -void hal_start_tx0(  struct hw_data * pHwData );
> -#define hal_get_cwmin( _A ) ( (_A)->cwmin )
> -void hal_set_cwmax(  struct hw_data * pHwData,  u16 cwin_max );
> -#define hal_get_cwmax( _A ) ( (_A)->cwmax )
> -void hal_set_rsn_wpa(  struct hw_data * pHwData,  u32 * RSN_IE_Bitmap , u32 * RSN_OUI_type , unsigned char bDesiredAuthMode);
> -void hal_set_connect_info(  struct hw_data * pHwData,  unsigned char boConnect );
> -u8 hal_get_est_sq3(  struct hw_data * pHwData,  u8 Count );
> -void hal_descriptor_indicate(  struct hw_data * pHwData,  struct wb35_descriptor *pDes );
> -u8 hal_get_antenna_number(  struct hw_data * pHwData );
> -u32 hal_get_bss_pk_cnt(  struct hw_data * pHwData );
> -#define hal_get_region_from_EEPROM( _A ) ( (_A)->reg.EEPROMRegion )
> -#define hal_get_tx_buffer( _A, _B ) Wb35Tx_get_tx_buffer( _A, _B )
> -#define hal_software_set( _A )		(_A->SoftwareSet)
> -#define hal_driver_init_OK( _A )	(_A->IsInitOK)
> -#define hal_rssi_boundary_high( _A ) (_A->RSSI_high)
> -#define hal_rssi_boundary_low( _A ) (_A->RSSI_low)
> -#define hal_scan_interval( _A )		(_A->Scan_Interval)
> -
> -#define PHY_DEBUG( msg, args... )
> -
> -#define hal_get_time_count( _P )	(_P->time_count/10)	// return 100ms count
> -#define hal_detect_error( _P )		(_P->WbUsb.DetectCount)
> -
> -//-------------------------------------------------------------------------
> -// The follow function is unused for IS89C35
> -//-------------------------------------------------------------------------
> +/* =====================================================================
> + * Function declaration
> + * =====================================================================
> + */
> +void hal_remove_mapping_key(struct hw_data *hw_data, u8 *mac_addr);
> +void hal_remove_default_key(struct hw_data *hw_data, u32 index);
> +unsigned char hal_set_mapping_key(struct hw_data *adapter, u8 *mac_addr,
> +				  u8 null_key, u8 wep_on, u8 *tx_tsc,
> +				  u8 *rx_tsc, u8 key_type, u8 key_len,
> +				  u8 *key_data);
> +unsigned char hal_set_default_key(struct hw_data *adapter, u8 index,
> +				  u8 null_key, u8 wep_on, u8 *tx_tsc,
> +				  u8 *rx_tsc, u8 key_type, u8 key_len,
> +				  u8 *key_data);
> +void hal_clear_all_default_key(struct hw_data *hw_data);
> +void hal_clear_all_group_key(struct hw_data *hw_data);
> +void hal_clear_all_mapping_key(struct hw_data *hw_data);
> +void hal_clear_all_key(struct hw_data *hw_data);
> +void hal_set_power_save_mode(struct hw_data *hw_data, unsigned char power_save,
> +			     unsigned char wakeup, unsigned char dtim);
> +void hal_get_power_save_mode(struct hw_data *hw_data, u8 *in_pwr_save);
> +void hal_set_slot_time(struct hw_data *hw_data, u8 type);
> +
> +#define hal_set_atim_window(_A, _ATM)
> +
> +void hal_start_bss(struct hw_data *hw_data, u8 mac_op_mode);
> +
> +/* 0:BSS STA 1:IBSS STA */
> +void hal_join_request(struct hw_data *hw_data, u8 bss_type);
> +
> +void hal_stop_sync_bss(struct hw_data *hw_data);
> +void hal_resume_sync_bss(struct hw_data *hw_data);
> +void hal_set_aid(struct hw_data *hw_data, u16 aid);
> +void hal_set_bssid(struct hw_data *hw_data, u8 *bssid);
> +void hal_get_bssid(struct hw_data *hw_data, u8 *bssid);
> +void hal_set_listen_interval(struct hw_data *hw_data, u16 listen_interval);
> +void hal_set_cap_info(struct hw_data *hw_data, u16 capability_info);
> +void hal_set_ssid(struct hw_data *hw_data, u8 *ssid, u8 ssid_len);
> +void hal_start_tx0(struct hw_data *hw_data);
> +
> +#define hal_get_cwmin(_A)	((_A)->cwmin)
> +
> +void hal_set_cwmax(struct hw_data *hw_data, u16 cwin_max);
> +
> +#define hal_get_cwmax(_A)	((_A)->cwmax)
> +
> +void hal_set_rsn_wpa(struct hw_data *hw_data, u32 *rsn_ie_bitmap,
> +		     u32 *rsn_oui_type , unsigned char desired_auth_mode);
> +void hal_set_connect_info(struct hw_data *hw_data, unsigned char bo_connect);
> +u8 hal_get_est_sq3(struct hw_data *hw_data, u8 count);
> +void hal_descriptor_indicate(struct hw_data *hw_data,
> +			     struct wb35_descriptor *des);
> +u8 hal_get_antenna_number(struct hw_data *hw_data);
> +u32 hal_get_bss_pk_cnt(struct hw_data *hw_data);
> +
> +#define hal_get_region_from_EEPROM(_A)	((_A)->reg.EEPROMRegion)
> +#define hal_get_tx_buffer(_A, _B)	Wb35Tx_get_tx_buffer(_A, _B)
> +#define hal_software_set(_A)		(_A->SoftwareSet)
> +#define hal_driver_init_OK(_A)		(_A->IsInitOK)
> +#define hal_rssi_boundary_high(_A)	(_A->RSSI_high)
> +#define hal_rssi_boundary_low(_A)	(_A->RSSI_low)
> +#define hal_scan_interval(_A)		(_A->Scan_Interval)
> +
> +#define PHY_DEBUG(msg, args...)
> +
> +/* return 100ms count */
> +#define hal_get_time_count(_P)		(_P->time_count / 10)
> +#define hal_detect_error(_P)		(_P->WbUsb.DetectCount)
> +
> +/* The follow function is unused for IS89C35 */
>  #define hal_disable_interrupt(_A)
>  #define hal_enable_interrupt(_A)
> -#define hal_get_interrupt_type( _A)
> +#define hal_get_interrupt_type(_A)
>  #define hal_get_clear_interrupt(_A)
> -#define hal_ibss_disconnect(_A) hal_stop_sync_bss(_A)
> +#define hal_ibss_disconnect(_A)		(hal_stop_sync_bss(_A))
>  #define hal_join_request_stop(_A)
> -#define hw_get_cxx_reg( _A, _B, _C )
> -#define hw_set_cxx_reg( _A, _B, _C )
> +#define hw_get_cxx_reg(_A, _B, _C)
> +#define hw_set_cxx_reg(_A, _B, _C)
>  
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
