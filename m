Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab0JVOGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 10:06:45 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46411 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995Ab0JVOGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 10:06:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=sM1u02EzTvLhpjs8MEIfwP9lbkgej7e9VkqrzqrR0IFvuulhnTfOFabSHt7pDnC07Z
         tbfZy7BTmyaeQVVMbrwnMcO3WvAVRzlJtnydV9vpgfpCrDzrNID5ErqvyEC5qEifHayd
         688/49/n1D3efirZ/TgfkBdB8q0jxHb6EtxPE=
Message-ID: <4CC19A6E.8010909@gmail.com>
Date: Fri, 22 Oct 2010 16:06:38 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: DVB: af9015 defunct [was: mmotm 2010-10-20-15-01 uploaded]
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org> <4CC07DB4.20205@gmail.com> <4CC1577F.9060207@gmail.com> <4CC19804.1080109@redhat.com>
In-Reply-To: <4CC19804.1080109@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2010 03:56 PM, Mauro Carvalho Chehab wrote:
> --- a/drivers/media/dvb/dvb-usb/af9015.c
> +++ b/drivers/media/dvb/dvb-usb/af9015.c
> @@ -1144,7 +1144,7 @@ static struct qt1010_config af9015_qt1010_config = {
>  
>  static struct tda18271_config af9015_tda18271_config = {
>  	.gate = TDA18271_GATE_DIGITAL,
> -	.small_i2c = 1,
> +	.small_i2c = TDA18271_16_BYTE_CHUNK_INIT;,

No, it doesn't help (note the i2c line which prints the small_i2c entry):
dvb-usb: found a 'Leadtek WinFast DTV Dongle Gold' in cold state, will
try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
dvb-usb: found a 'Leadtek WinFast DTV Dongle Gold' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (Leadtek WinFast DTV Dongle Gold)
af9013: firmware version:4.95.0.0
DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
af9015_tuner_attach: i2c 16
tda18271 16-00c0: creating new instance
TDA18271HD/C2 detected @ 16-00c0
af9015: command failed:1
tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x0, len = 39,
i2c_transfer returned: -1
af9015: command failed:1
tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x20, len = 1,
i2c_transfer returned: -1
af9015: command failed:1
tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x20, len = 1,
i2c_transfer returned: -1
af9015: command failed:1
tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x20, len = 1,
i2c_transfer returned: -1
af9015: command failed:1
tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x20, len = 1,
i2c_transfer returned: -1
af9015: command failed:1
tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x5, len = 11,
i2c_transfer returned: -1
af9015: command failed:1
tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x13, len = 1,
i2c_transfer returned: -1
af9015: command failed:1
tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x13, len = 1,
i2c_transfer returned: -1
af9015: command failed:1
tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x3, len = 1, i2c_transfer
returned: -1
af9015: command failed:1
tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x5, len = 7, i2c_transfer
returned: -1
af9015: command failed:1
tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x4, len = 1, i2c_transfer
returned: -1
af9015: command failed:1
tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x5, len = 11,
i2c_transfer returned: -1
af9015: command failed:1
tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x3, len = 1, i2c_transfer
returned: -1
af9015: command failed:1
tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x5, len = 7, i2c_transfer
returned: -1
af9015: command failed:1
tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x4, len = 1, i2c_transfer
returned: -1
af9015: command failed:1
tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x5, len = 11,
i2c_transfer returned: -1
af9015: command failed:1
tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x3, len = 1, i2c_transfer
returned: -1
af9015: command failed:1
tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x5, len = 7, i2c_transfer
returned: -1
af9015: command failed:1
tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x4, len = 1, i2c_transfer
returned: -1
af9015: command failed:1
tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x6, len = 1, i2c_transfer
returned: -1
af9015: command failed:1
tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x3, len = 1, i2c_transfer
returned: -1
dvb-usb: Leadtek WinFast DTV Dongle Gold successfully initialized and
connected.
usbcore: registered new interface driver dvb_usb_af9015


regards,
-- 
js
