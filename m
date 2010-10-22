Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0JVJVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 05:21:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40902 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab0JVJVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 05:21:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Xh5cOJUUuMsx0lIgK1ekW9I5FrlQx9LWwdYdwivgHw4uJIFItdbfODCO/10lCca9n8
         wTxg+a/QyZ+7vVlL2A5SNrVzUfaO6TrnfbCIDY9JTPCKetXlWHqwDfg4ABQ+U0MTsM84
         rm5zAar8jwNW4Fyb0ALy/Mue/p8uyqhFReHrE=
Message-ID: <4CC1577F.9060207@gmail.com>
Date: Fri, 22 Oct 2010 11:21:03 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: DVB: af9015 defunct [was: mmotm 2010-10-20-15-01 uploaded]
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org> <4CC07DB4.20205@gmail.com>
In-Reply-To: <4CC07DB4.20205@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 07:51 PM, Jiri Slaby wrote:
> On 10/21/2010 12:01 AM, akpm@linux-foundation.org wrote:
>> The mm-of-the-moment snapshot 2010-10-20-15-01 has been uploaded to
> 
> Well, this release happens to be a multimedia failure :(.
> 
> I hit another regression against mmotm 2010-10-13-17-13, where
> 0413:6029 (DVB USB tuner) can't be inited when plugged in. Even lsusb
> waits inifitely.

Revert of this commit helps:

commit 99ef217e01780668ac21d600eaf4acd3f7666a02
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Sun Sep 26 22:58:28 2010 -0300

    [media] tda18271: allow restricting max out to 4 bytes

    By default, tda18271 tries to optimize I2C bus by updating all registers
    at the same time. Unfortunately, some devices doesn't support it.

    The current logic has a problem when small_i2c is equal to 8, since
there
    are some transfers using 11 + 1 bytes.

    Fix the problem by enforcing the max size at the right place, and allows
    reducing it to max = 3 + 1.

    Acked-by: Michael Krufky <mkrufky@kernellabs.com>
    Acked-by: Sri Deevi <Srinivasa.Deevi@conexant.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> usb 2-6: new high speed USB device using ehci_hcd and address 5
> dvb-usb: found a 'Leadtek WinFast DTV Dongle Gold' in cold state, will
> try to load a firmware
> dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
> dvb-usb: found a 'Leadtek WinFast DTV Dongle Gold' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software
> demuxer.
> DVB: registering new adapter (Leadtek WinFast DTV Dongle Gold)
> af9013: firmware version:4.95.0.0
> DVB: registering adapter 1 frontend 0 (Afatech AF9013 DVB-T)...
> tda18271 18-00c0: creating new instance
> TDA18271HD/C2 detected @ 18-00c0
> af9015: command failed:1
> tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x0, len = 39,
> i2c_transfer returned: -1
> af9015: command failed:1
> tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x20, len = 1,
> i2c_transfer returned: -1
> af9015: command failed:1
> tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x20, len = 1,
> i2c_transfer returned: -1
> af9015: command failed:1
> tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x20, len = 1,
> i2c_transfer returned: -1
> af9015: command failed:1
> tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x20, len = 1,
> i2c_transfer returned: -1
> af9015: recv bulk message failed:-71
> af9015: bulk message failed:-71 (8/0)
> af9013: I2C read failed reg:d417
> tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x5, len = 11,
> i2c_transfer returned: -1
> af9015: bulk message failed:-71 (8/0)
> af9013: I2C read failed reg:d417
> af9015: bulk message failed:-71 (9/0)
> af9015: bulk message failed:-71 (8/0)
> af9013: I2C read failed reg:d417
> tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x13, len = 1,
> i2c_transfer returned: -71
> af9015: bulk message failed:-71 (8/0)
> af9013: I2C read failed reg:d417
> af9015: bulk message failed:-71 (9/0)
> af9015: bulk message failed:-71 (8/0)
> af9013: I2C read failed reg:d417
> tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x13, len = 1,
> i2c_transfer returned: -71
> 
> regards,
-- 
js
