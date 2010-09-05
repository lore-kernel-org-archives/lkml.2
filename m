Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab0IEKER (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 06:04:17 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:54840 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752993Ab0IEKEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 06:04:15 -0400
Message-ID: <4C836B10.4040407@euromail.se>
Date: Sun, 05 Sep 2010 12:04:00 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100903 Thunderbird/3.1.3
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] input: wacom: Add support for the Bamboo Touch trackpad
 (rev4)
References: <1283607783-29388-1-git-send-email-rydberg@euromail.se> <1283607783-29388-5-git-send-email-rydberg@euromail.se>
In-Reply-To: <1283607783-29388-5-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OsC4x-0008IC-4b.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1OsC4x-0008IC-4b 7d3108f3ed6e6b19bb2b7f1f98a3504d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2010 03:43 PM, Henrik Rydberg wrote:

[...]

>@@ -955,6 +1007,12 @@ void wacom_setup_device_quirks(struct wacom
> 	if (features->type == TABLETPC || features->type == TABLETPC2FG ||
> 	    features->type == BAMBOO_PT)
> 		features->quirks |= WACOM_QUIRK_MULTI_INPUT;
>+
>+	/* quirks for bamboo touch */
>+	if (features->type == BAMBOO_PT) {

This line should have "&& features->device_type == BTN_TOOL_TRIPLETAP" appended
to it, to only target the touch device of Pen & Touch.

>+		features->pressure_max = 256;
>+		features->pressure_fuzz = 16;
>+	}
> }

Henrik
