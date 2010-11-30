Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab0K3Vup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:50:45 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:47129 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020Ab0K3Vuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:50:44 -0500
Message-ID: <4CF57197.7070000@euromail.se>
Date: Tue, 30 Nov 2010 22:50:15 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] input: mt: Move tracking and pointer emulation to
 input-mt
References: <1291014802-17061-1-git-send-email-rydberg@euromail.se> <1291014802-17061-4-git-send-email-rydberg@euromail.se>
In-Reply-To: <1291014802-17061-4-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PNY5Z-00076O-BI.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PNY5Z-00076O-BI 0c272ab4ac542c6b8722f066a8c25138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -132,12 +128,10 @@ static void parse_touch(struct w8001 *w8001)

>  			input_report_abs(dev, ABS_MT_POSITION_X, x);
>  			input_report_abs(dev, ABS_MT_POSITION_Y, y);
>  			input_report_abs(dev, ABS_MT_TOOL_TYPE, MT_TOOL_FINGER);
> -			if (w8001->trkid[i] < 0)
> -				w8001->trkid[i] = trkid++ & MAX_TRACKING_ID;
> +			input_report_slot_state(dev, true);


			input_mt_report_slot_state(dev, true);

>  		} else {
> -			w8001->trkid[i] = -1;
> +			input_report_slot_state(dev, false);


			input_mt_report_slot_state(dev, false);

>  		}
> -		input_report_abs(dev, ABS_MT_TRACKING_ID, w8001->trkid[i]);
>  	}
>  
>  	input_sync(dev);


Henrik

