Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab0EQSyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:54:13 -0400
Received: from smtp115.plus.mail.re1.yahoo.com ([69.147.102.78]:40801 "HELO
	smtp115.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752266Ab0EQSyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:54:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=yc89GT6GeUffvze0ID6hmyKWoKA7fCBZmm3wkBUC/RxCRxk6dOi28WbdmKP+ipQqdZXZCCqFPBD2sBrHD3fUcems/CSu9+dG6gHQqT3VV38WwNx2HClBUDk1lxMnFjv/ulNoq4I41Fb3XiheuYjKf/V2HYYStXl9C9YLuzuBNJ4=  ;
X-Yahoo-SMTP: 7VYQSIiswBBpfI3oQQ5mbefGCpOrHbDC5qsO
X-YMail-OSG: IjzkFmEVM1n0Jy5TxkAhjk3ug3CvMwLI8AWfNGzdfQwGF9x
 DuUZWvKPuSbnX2YBYZHmCGLqg5f5R8JhQDkFcW3YgjpYO3GoIMxaRK6NIp7A
 FxAihLszEAdFOcyXMxiS2y6LSPwp_eF6OhchO1c5qfYtl9yFjTuNKkrsMRKs
 WxOiJGm.UL932JDMwMVMlPHUAo90L.Zv1y0b3h_ZnS3nQmudzQc3T0BIRKwC
 N1XedEtObfxFQhnnwRFilM9cLVw50h2W.Oye3OcpgvfWJmvjVBM_tHAqar96
 Exwp8BjbtHIU4ALTa9NRMREQzcNVfpbfprG9ALMU3x8LKGf8f1QkYzI.wlqe
 JCyt_b2VdlTJ.74dtFLEm5oIW7Hfot.P1JnEeqSs99.hMjzIMQnvjQnX_xsz
 uaqqtLTBzFIqciAVRaGAJ72HRSOq16.joGDbCx1lM4LNhQU5nzQhzxNY0MTp
 uFN0t_A--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4BF190CF.80408@yahoo.co.uk>
Date: Mon, 17 May 2010 19:54:07 +0100
From: Don Prince <dhprince.devel@yahoo.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100422 Mandriva/3.0.4-0.4mdv2010.0 (2010.0) Thunderbird/3.0.4
MIME-Version: 1.0
To: Robert Schedel <r.schedel@yahoo.de>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.34-rc7 v4] HID: hid-samsung: add support for Creative
 Desktop Wireless 6000
References: <4BF11D9F.80605@yahoo.co.uk> <4BF178BD.2000209@yahoo.de>
In-Reply-To: <4BF178BD.2000209@yahoo.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/05/10 18:11, Robert Schedel wrote:
> Hello,
>
> sorry for one late observation:
>
> On 17.05.2010 12:42, Don Prince wrote:
>   
>> Add support for the multimedia buttons of the Creative Desktop Wireless
>> 6000 keyboard/mouse combo which are not currently handled by the
>> default/samsung HID driver.
>>
>> Signed-off-by: Don Prince <dhprince-devel@yahoo.co.uk>
>>
>> ---
>>
>> Added comments as requested by Robert Schedel <r.schedel@yahoo.de>
>>
>> As requested by Jiri Kosina, made key mapping code more concise
>> i.e. ignored checkpatch.pl's wingeing about code style.
>>     
> [...]
>   
>> +	switch (usage->hid & HID_USAGE) {
>> +	/* report 2 */
>> +	case 0x0b5: samsung_kbd_mouse_map_key_clear(KEY_NEXTSONG); break;
>> +	case 0x0b6: samsung_kbd_mouse_map_key_clear(KEY_PREVIOUSSONG); break;
>> +	case 0x0b7: samsung_kbd_mouse_map_key_clear(KEY_STOPCD); break;
>> +	case 0x0cd: samsung_kbd_mouse_map_key_clear(KEY_PLAYPAUSE); break;
>> +	case 0x0e2: samsung_kbd_mouse_map_key_clear(KEY_MUTE); break;
>> +	case 0x0e9: samsung_kbd_mouse_map_key_clear(KEY_VOLUMEUP); break;
>> +	case 0x0ea: samsung_kbd_mouse_map_key_clear(KEY_VOLUMEDOWN); break;
>>     
> Those seven are identical to hid-input.c mapping (HUT 1.1 compliant) and could simply be deleted. Daisy chaining via default case below, right?
>
>   
Yes they (the seven) are redundant. They work with default behaviour.
>> +	case 0x183: samsung_kbd_mouse_map_key_clear(KEY_MEDIA); break;
>> +	case 0x195: samsung_kbd_mouse_map_key_clear(KEY_EMAIL);	break;
>> +	case 0x196: samsung_kbd_mouse_map_key_clear(KEY_CALC); break;
>> +	case 0x197: samsung_kbd_mouse_map_key_clear(KEY_COMPUTER); break;
>> +	case 0x22b: samsung_kbd_mouse_map_key_clear(KEY_SEARCH); break;
>> +	case 0x22c: samsung_kbd_mouse_map_key_clear(KEY_WWW); break;
>> +	case 0x22d: samsung_kbd_mouse_map_key_clear(KEY_BACK); break;
>> +	case 0x22e: samsung_kbd_mouse_map_key_clear(KEY_FORWARD); break;
>> +	case 0x22f: samsung_kbd_mouse_map_key_clear(KEY_FAVORITES); break;
>> +	case 0x230: samsung_kbd_mouse_map_key_clear(KEY_REFRESH); break;
>> +	case 0x231: samsung_kbd_mouse_map_key_clear(KEY_STOP); break;
>> +	default:
>> +		return 0;
>>     
> Regards,
> Robert Schedel
>
>   


		
___________________________________________________________ 
Yahoo! Messenger - with free PC-PC calling and photo sharing. http://uk.messenger.yahoo.com
