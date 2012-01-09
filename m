Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab2AITUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 14:20:54 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36743 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932851Ab2AITUx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 14:20:53 -0500
MIME-Version: 1.0
In-Reply-To: <20120109161456.GC2974@opensource.wolfsonmicro.com>
References: <1326111140.22107.9.camel@sw-eng-lt-dc-vm2>
	<20120109161456.GC2974@opensource.wolfsonmicro.com>
Date: Mon, 9 Jan 2012 19:20:50 +0000
Message-ID: <CAEqHmAte=rvhjGUEdMgNQKfvPxSVTFR5TfWy13VPEhZj0T53KQ@mail.gmail.com>
Subject: Re: drivers/regulator/core.c: Fixes mapping inside
 regulator_mode_to_status() and makes it returning -EINVAL on invalid input.
From: dd diasemi <dd.diasemi@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 4:14 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Jan 09, 2012 at 12:12:20PM +0000, Krystian Garbaciak wrote:
>> Minor fix that makes the function working correctly with
>> REGULATOR_MODE_STANDBY as parameter.
>> Also, on invalid input (bad mode), it is better to return -EINVAL,
>> instead of meaningless 0 value (which actually is interpreted as
>> REGULATOR_STATUS_OFF).
>>
>> ---
>
>>       default:
>> -             return 0;
>> +             return -EINVAL;
>
> This behaviour is deliberate.

For this moment, the only usage is in one file in
wm831x_aldo_get_status() and wm831x_gp_ldo_get_status():
	ret = wm831x_aldo_get_mode(rdev);
	if (ret < 0)
		return ret;
	else
		return regulator_mode_to_status(ret);

The usage mistreats the signed value 'ret' as wm831x_aldo_get_mode()
always returns 0 on communication error. It effects in response as if
the regulator was off.

If that behaviour is deliberate, I would suggest to make it explicit:
 	default:
-		return 0;
+		return REGULATOR_STATUS_OFF;
