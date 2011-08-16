Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab1HPAXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 20:23:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53015 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab1HPAXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 20:23:45 -0400
Message-ID: <4E49B848.9010705@cn.fujitsu.com>
Date: Tue, 16 Aug 2011 08:22:32 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: FNST
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110322 Red Hat/3.1.9-3.el6_0 Thunderbird/3.1.9
MIME-Version: 1.0
To: Yufeng Shen <miletus@chromium.org>
CC: linux-input@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>, linux-kernel@vger.kernel.org,
        Michael Gong <Michael.Gong@atmel.com>,
        Alan Bowens <Alan.Bowens@atmel.com>
Subject: Re: [PATCH v3] Input: atmel_mxt_ts - Report pressure information
 from the driver
References: <1313420550-5885-1-git-send-email-miletus@chromium.org>
In-Reply-To: <1313420550-5885-1-git-send-email-miletus@chromium.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-16 08:22:24,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-16 08:22:24,
	Serialize complete at 2011-08-16 08:22:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2011 11:02 PM, Yufeng Shen wrote:
> Atmel mxt1386 touch controller has the touch pressure information but
> the current driver atmel_mxt_ts does not expose it to the user space.
> This patch makes the driver report the touch pressure information to
> user space.
>
> ChangeLog:
> v2: fixed indentation as commented by Wanlong Gao
> v3: added signed-off-by
>
> Change-Id: Ie0e4683a3cd5ec79222f7682b0ddc24f909af543
> Signed-off-by: Yufeng Shen<miletus@chromium.org>
Acked-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> ---
>   drivers/input/touchscreen/atmel_mxt_ts.c |    8 ++++++++
>   1 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index ae00604..9bdf4e0 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -244,6 +244,7 @@ struct mxt_finger {
>   	int x;
>   	int y;
>   	int area;
> +	int pressure;
>   };
>
>   /* Each client has this additional data */
> @@ -536,6 +537,8 @@ static void mxt_input_report(struct mxt_data *data, int single_id)
>   					finger[id].x);
>   			input_report_abs(input_dev, ABS_MT_POSITION_Y,
>   					finger[id].y);
> +			input_report_abs(input_dev, ABS_MT_PRESSURE,
> +					finger[id].pressure);
>   		} else {
>   			finger[id].status = 0;
>   		}
> @@ -560,6 +563,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
>   	int x;
>   	int y;
>   	int area;
> +	int pressure;
>
>   	/* Check the touch is present on the screen */
>   	if (!(status&  MXT_DETECT)) {
> @@ -584,6 +588,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
>   		y = y>>  2;
>
>   	area = message->message[4];
> +	pressure = message->message[5];
>
>   	dev_dbg(dev, "[%d] %s x: %d, y: %d, area: %d\n", id,
>   		status&  MXT_MOVE ? "moved" : "pressed",
> @@ -594,6 +599,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
>   	finger[id].x = x;
>   	finger[id].y = y;
>   	finger[id].area = area;
> +	finger[id].pressure = pressure;
>
>   	mxt_input_report(data, id);
>   }
> @@ -1125,6 +1131,8 @@ static int __devinit mxt_probe(struct i2c_client *client,
>   			     0, data->max_x, 0, 0);
>   	input_set_abs_params(input_dev, ABS_MT_POSITION_Y,
>   			     0, data->max_y, 0, 0);
> +	input_set_abs_params(input_dev, ABS_MT_PRESSURE,
> +			     0, 255, 0, 0);
>
>   	input_set_drvdata(input_dev, data);
>   	i2c_set_clientdata(client, data);


-- 
Thanks
Wanlong Gao
