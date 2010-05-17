Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab0EQRLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 13:11:55 -0400
Received: from smtp131.mail.ukl.yahoo.com ([77.238.184.62]:38943 "HELO
	smtp131.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751467Ab0EQRLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 13:11:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=p5cFMXtsz6wA4+2eDNzottHC5mjdV+5+wuOFfSGqEUPWPJneFTv+aXnlefeMexgJ00uwQAQgyO22+HjduxkQxHN1c3NVDqU4nzKJWg3SLq/CQA3oDfihbYph14ssH5V6uQ53QvKNzcyegDEhWzMrK5XMY5oY/iZqSo96ySQ3JEM=  ;
X-Yahoo-SMTP: pBUX04qswBBDzuR5UAvE0Uc4jpf04Q--
X-YMail-OSG: a8NOIzkVM1moHDmg_OcTYfS4_qCw2jCAJP.uLAWSA5R1it0LgM4xXQ0vnPlXI747QlYGBrswF4tq80kkOZ2FEebLeg7MTB1ffYTzSodcjOdW0N0WnTEfDsjgl_22n6.SNrkJD1hb0_laDjOkBTaUhY.9PgosNBZRdMU799w8znCi1L5gBe2mnxaL__EWDgzYwlPIwA7U8o1UBwOl8q8zw3se3iaZXtY2js9oGwhVra0.iO1HDHuyIuXbhQ--
X-Yahoo-Newman-Property: ymail-5
Message-ID: <4BF178BD.2000209@yahoo.de>
Date: Mon, 17 May 2010 19:11:25 +0200
From: Robert Schedel <r.schedel@yahoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100411 Thunderbird/3.0.4
MIME-Version: 1.0
To: dhprince.devel@yahoo.co.uk, Jiri Kosina <jkosina@suse.cz>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.34-rc7 v4] HID: hid-samsung: add support for Creative
 Desktop Wireless 6000
References: <4BF11D9F.80605@yahoo.co.uk>
In-Reply-To: <4BF11D9F.80605@yahoo.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

sorry for one late observation:

On 17.05.2010 12:42, Don Prince wrote:
> Add support for the multimedia buttons of the Creative Desktop Wireless
> 6000 keyboard/mouse combo which are not currently handled by the
> default/samsung HID driver.
> 
> Signed-off-by: Don Prince <dhprince-devel@yahoo.co.uk>
> 
> ---
> 
> Added comments as requested by Robert Schedel <r.schedel@yahoo.de>
> 
> As requested by Jiri Kosina, made key mapping code more concise
> i.e. ignored checkpatch.pl's wingeing about code style.
[...]
> +	switch (usage->hid & HID_USAGE) {
> +	/* report 2 */
> +	case 0x0b5: samsung_kbd_mouse_map_key_clear(KEY_NEXTSONG); break;
> +	case 0x0b6: samsung_kbd_mouse_map_key_clear(KEY_PREVIOUSSONG); break;
> +	case 0x0b7: samsung_kbd_mouse_map_key_clear(KEY_STOPCD); break;
> +	case 0x0cd: samsung_kbd_mouse_map_key_clear(KEY_PLAYPAUSE); break;
> +	case 0x0e2: samsung_kbd_mouse_map_key_clear(KEY_MUTE); break;
> +	case 0x0e9: samsung_kbd_mouse_map_key_clear(KEY_VOLUMEUP); break;
> +	case 0x0ea: samsung_kbd_mouse_map_key_clear(KEY_VOLUMEDOWN); break;

Those seven are identical to hid-input.c mapping (HUT 1.1 compliant) and could simply be deleted. Daisy chaining via default case below, right?

> +	case 0x183: samsung_kbd_mouse_map_key_clear(KEY_MEDIA); break;
> +	case 0x195: samsung_kbd_mouse_map_key_clear(KEY_EMAIL);	break;
> +	case 0x196: samsung_kbd_mouse_map_key_clear(KEY_CALC); break;
> +	case 0x197: samsung_kbd_mouse_map_key_clear(KEY_COMPUTER); break;
> +	case 0x22b: samsung_kbd_mouse_map_key_clear(KEY_SEARCH); break;
> +	case 0x22c: samsung_kbd_mouse_map_key_clear(KEY_WWW); break;
> +	case 0x22d: samsung_kbd_mouse_map_key_clear(KEY_BACK); break;
> +	case 0x22e: samsung_kbd_mouse_map_key_clear(KEY_FORWARD); break;
> +	case 0x22f: samsung_kbd_mouse_map_key_clear(KEY_FAVORITES); break;
> +	case 0x230: samsung_kbd_mouse_map_key_clear(KEY_REFRESH); break;
> +	case 0x231: samsung_kbd_mouse_map_key_clear(KEY_STOP); break;
> +	default:
> +		return 0;

Regards,
Robert Schedel
