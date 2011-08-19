Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab1HSAQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 20:16:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58887 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab1HSAQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 20:16:32 -0400
Message-ID: <4E4DAB21.90309@cn.fujitsu.com>
Date: Fri, 19 Aug 2011 08:15:29 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: FNST
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110322 Red Hat/3.1.9-3.el6_0 Thunderbird/3.1.9
MIME-Version: 1.0
To: JJ Ding <jj_ding@emc.com.tw>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 6/6] Input: elantech - add v3 hardware support
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-7-git-send-email-jj_ding@emc.com.tw> <20110818135853.GA28313@thinkpad-t410> <20110818142500.GC28313@thinkpad-t410>
In-Reply-To: <20110818142500.GC28313@thinkpad-t410>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-19 08:15:16,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-19 08:15:17,
	Serialize complete at 2011-08-19 08:15:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2011 10:25 PM, Seth Forshee wrote:
> On Thu, Aug 18, 2011 at 08:58:53AM -0500, Seth Forshee wrote:
>> The case 3 code is nearly identical to case 2. How about this?
>>
>> 	case 2:
>> 		__set_bit(BTN_TOOL_QUADTAP, dev->keybit);
>> 		/* fall through */
>>
>> 	case 3:
>> 		input_set_abs_params(dev, ABS_X, x_min, x_max, 0, 0);
>> 		input_set_abs_params(dev, ABS_Y, y_min, y_max, 0, 0);
>> 		/* range of pressure and width is the same as v2 */
>> 		input_set_abs_params(dev, ABS_PRESSURE, ETP_PMIN_V2,
>> 				     ETP_PMAX_V2, 0, 0);
>> 		input_set_abs_params(dev, ABS_TOOL_WIDTH, ETP_WMIN_V2,
>> 				     ETP_WMAX_V2, 0, 0);
>> 		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
>> 		input_mt_init_slots(dev, 2);
>> 		input_set_abs_params(dev, ABS_MT_POSITION_X, x_min, x_max, 0, 0);
>> 		input_set_abs_params(dev, ABS_MT_POSITION_Y, y_min, y_max, 0, 0);
>> 		break;
>
> Sorry, that should have been:
>
> 	case 2:
> 		__set_bit(BTN_TOOL_QUADTAP, dev->keybit);
> 		/* fall through */
>
> 	case 3:
> 		input_set_abs_params(dev, ABS_X, x_min, x_max, 0, 0);
> 		input_set_abs_params(dev, ABS_Y, y_min, y_max, 0, 0);
> 		if (etd->reports_pressure) {
> 			input_set_abs_params(dev, ABS_PRESSURE, ETP_PMIN_V2,
> 					     ETP_PMAX_V2, 0, 0);
> 			input_set_abs_params(dev, ABS_TOOL_WIDTH, ETP_WMIN_V2,
> 					     ETP_WMAX_V2, 0, 0);
> 		}
> 		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
> 		input_mt_init_slots(dev, 2);
> 		input_set_abs_params(dev, ABS_MT_POSITION_X, x_min, x_max, 0, 0);
> 		input_set_abs_params(dev, ABS_MT_POSITION_Y, y_min, y_max, 0, 0);
> 		break;

simplify, seems good.

Thanks
-Wanlong Gao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

