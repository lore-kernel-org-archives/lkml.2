Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811Ab1CaGlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:41:47 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:35784 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756738Ab1CaGlj (ORCPT
	<rfc822;groupwise-jlee@novell.com:4:1>);
	Thu, 31 Mar 2011 02:41:39 -0400
Message-Id: <4D94BCCF020000230002AA3B@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Thu, 31 Mar 2011 00:41:35 -0600
From: "Joey Lee" <jlee@novell.com>
To: <joe@perches.com>
Cc: <mjg@redhat.com>, <carlos@strangeworlds.co.uk>,
        <linux-kernel@vger.kernel.org>, <platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH 03/23] acer-wmi: pr_<level> cleanups
References: <cover.1301436234.git.joe@perches.com>
 <4c2d34198b3331f0df654f2e75e4e85d6d1b50cb.1301436234.git.joe@perches.com>
In-Reply-To: <4c2d34198b3331f0df654f2e75e4e85d6d1b50cb.1301436234.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 二，2011-03-29 於 15:21 -0700，Joe Perches 提到：
> Convert pr_warning to pr_warn.
> Add some missing newlines to pr_<level> uses.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/platform/x86/acer-wmi.c |   32 ++++++++++++++++----------------
>  1 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> index 5ea6c34..0b23b75 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -1081,7 +1081,7 @@ static acpi_status wmid3_get_device_status(u32 *value, u16 device)
>  		return AE_ERROR;
>  	}
>  	if (obj->buffer.length != 8) {
> -		pr_warning("Unknown buffer length %d\n", obj->buffer.length);
> +		pr_warn("Unknown buffer length %d\n", obj->buffer.length);
>  		kfree(obj);
>  		return AE_ERROR;
>  	}
> @@ -1090,8 +1090,8 @@ static acpi_status wmid3_get_device_status(u32 *value, u16 device)
>  	kfree(obj);
>  
>  	if (return_value.error_code || return_value.ec_return_value)
> -		pr_warning("Get Device Status failed: "
> -			"0x%x - 0x%x\n", return_value.error_code,
> +		pr_warn("Get Device Status failed: 0x%x - 0x%x\n",
> +			return_value.error_code,
>  			return_value.ec_return_value);
>  	else
>  		*value = !!(return_value.devices & device);
> @@ -1317,7 +1317,7 @@ static void acer_wmi_notify(u32 value, void *context)
>  
>  	status = wmi_get_event_data(value, &response);
>  	if (status != AE_OK) {
> -		pr_warning("bad event status 0x%x\n", status);
> +		pr_warn("bad event status 0x%x\n", status);
>  		return;
>  	}
>  
> @@ -1326,12 +1326,12 @@ static void acer_wmi_notify(u32 value, void *context)
>  	if (!obj)
>  		return;
>  	if (obj->type != ACPI_TYPE_BUFFER) {
> -		pr_warning("Unknown response received %d\n", obj->type);
> +		pr_warn("Unknown response received %d\n", obj->type);
>  		kfree(obj);
>  		return;
>  	}
>  	if (obj->buffer.length != 8) {
> -		pr_warning("Unknown buffer length %d\n", obj->buffer.length);
> +		pr_warn("Unknown buffer length %d\n", obj->buffer.length);
>  		kfree(obj);
>  		return;
>  	}
> @@ -1356,11 +1356,11 @@ static void acer_wmi_notify(u32 value, void *context)
>  		}
>  		if (!sparse_keymap_report_event(acer_wmi_input_dev,
>  				return_value.key_num, 1, true))
> -			pr_warning("Unknown key number - 0x%x\n",
> +			pr_warn("Unknown key number - 0x%x\n",
>  				return_value.key_num);
>  		break;
>  	default:
> -		pr_warning("Unknown function number - %d - %d\n",
> +		pr_warn("Unknown function number - %d - %d\n",
>  			return_value.function, return_value.key_num);
>  		break;
>  	}
> @@ -1389,7 +1389,7 @@ wmid3_set_lm_mode(struct lm_input_params *params,
>  		return AE_ERROR;
>  	}
>  	if (obj->buffer.length != 4) {
> -		pr_warning("Unknown buffer length %d\n", obj->buffer.length);
> +		pr_warn("Unknown buffer length %d\n", obj->buffer.length);
>  		kfree(obj);
>  		return AE_ERROR;
>  	}
> @@ -1414,11 +1414,11 @@ static int acer_wmi_enable_ec_raw(void)
>  	status = wmid3_set_lm_mode(&params, &return_value);
>  
>  	if (return_value.error_code || return_value.ec_return_value)
> -		pr_warning("Enabling EC raw mode failed: "
> -		       "0x%x - 0x%x\n", return_value.error_code,
> -		       return_value.ec_return_value);
> +		pr_warn("Enabling EC raw mode failed: 0x%x - 0x%x\n",
> +			return_value.error_code,
> +			return_value.ec_return_value);
>  	else
> -		pr_info("Enabled EC raw mode");
> +		pr_info("Enabled EC raw mode\n");
>  
>  	return status;
>  }
> @@ -1437,9 +1437,9 @@ static int acer_wmi_enable_lm(void)
>  	status = wmid3_set_lm_mode(&params, &return_value);
>  
>  	if (return_value.error_code || return_value.ec_return_value)
> -		pr_warning("Enabling Launch Manager failed: "
> -		       "0x%x - 0x%x\n", return_value.error_code,
> -		       return_value.ec_return_value);
> +		pr_warn("Enabling Launch Manager failed: 0x%x - 0x%x\n",
> +			return_value.error_code,
> +			return_value.ec_return_value);
>  
>  	return status;
>  }

OK to me.

Acked-by: Lee, Chun-Yi <jlee@novell.com>

