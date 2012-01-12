Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab2ALOVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 09:21:50 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:37669 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753574Ab2ALOVs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 09:21:48 -0500
From: Rajanikanth H V <rajanikanth.hv@stericsson.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@sude.de" <gregkh@sude.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rajanikanth H V <rajanikanth.hv@stericsson.com>
Date: Thu, 12 Jan 2012 15:20:46 +0100
Subject: RE: tty/serial: Need clarification on Support for 4+M Baudrate
Thread-Topic: tty/serial: Need clarification on Support for 4+M Baudrate
Thread-Index: AczRIBqS6qinYB99QnGaINohe7w6kgAD9xqw
Message-ID: <2B1D156D95AE9B4EAD379CB9E465FE7324AF2A630D@EXDCVYMBSTM005.EQ1STM.local>
References: <20120111121901.GA4034@bnru05>
	<20120111123025.244a9cf5@pyramind.ukuu.org.uk>
	<2B1D156D95AE9B4EAD379CB9E465FE7324AF2A605A@EXDCVYMBSTM005.EQ1STM.local>
 <20120112114913.21809bed@pyramind.ukuu.org.uk>
In-Reply-To: <20120112114913.21809bed@pyramind.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

FYI: I am not using application, rather I have a Bluetooth driver invoking
encode_baud_rate(...), please find log below.

I made sure that c_ispeed = c_ospeed = 4.05M Baud, however I see 
tty_termios_encode_baud_rate(...) is normalizing to 4.0


manual trace log below:
======================================================================================

4.05M Arbitrary Baud Setting Sequence:
[    9.664703] alloc_set_baud_rate_cmd Setting arbitrary baudrate using BOTHER baudrate:89 c_cflag:020000016262
[    9.774658] XXXXXX_hci_uart_set_baudrate c_cflag:020000016262 baud:4050000
[    9.781646] XXXXXX_hci_uart_set_baudrate arb flag set
[    9.786956] tty_termios_encode_baud_rate c_ispeed:4050000 c_ospeed:4050000
[    9.794006] tty_termios_encode_baud_rate checking precise weird baudrate:0x80001cb2
[    9.802032] tty_termios_encode_baud_rate checking precise weird baudrate c_cflag:020000006260
[    9.810943] tty_termios_encode_baud_rate did we find close match? i:31 n_baud_table31 ifound:30 ofound:30
[    9.820739] tty_termios_encode_baud_rate BOTHER, c_cflag:020000016277
[    9.827209] tty_termios_baud_rate c_cflag:020000016277 cbaud:010017
[    9.833648] tty_termios_baud_rate:(Arb'ry baud BOTHER not set) c_cflag:020000016277 cbaud:010017
[    9.842773] tty_termios_baud_rate:cbaud:036 baud_val:4000000
[    9.848480] tty_termios_baud_rate c_cflag:020000016277 cbaud:010017
[    9.855499] tty_termios_baud_rate:(Arb'ry baud BOTHER not set) c_cflag:020000016277 cbaud:010017
[    9.864471] tty_termios_baud_rate:cbaud:036 baud_val:4000000
[    9.864501] pl011_set_termios baud:4000000 uart_clk:38400000 port:0 IBRD:1 FBRD:13
[   10.674652] XXXXXX-uart XXXXXX-uart.0: Failed to set new baud rate (4)
[   10.681213] XXXXXX-uart XXXXXX-uart.0: Set chip power: DISABLE
[   10.692596] tty_termios_encode_baud_rate c_ispeed:0 c_ospeed:0
[   10.698822] tty_termios_encode_baud_rate checking precise weird baudrate:0x80001cbf
[   10.706756] tty_termios_encode_baud_rate checking precise weird baudrate c_cflag:020000006260
[   10.715698] tty_termios_encode_baud_rate did we find close match? i:31 n_baud_table31 ifound:0 ofound:0
[   10.725769] tty_termios_encode_baud_rate BOTHER, c_cflag:020000006260
[   10.732574] tty_termios_baud_rate c_cflag:020000006260 cbaud:00
[   10.739929] tty_termios_baud_rate:(Arb'ry baud BOTHER not set) c_cflag:020000006260 cbaud:00
[   10.749176] tty_termios_baud_rate:cbaud:00 baud_val:0
[   10.754638] tty_termios_baud_rate c_cflag:020000006260 cbaud:00
[   10.761505] tty_termios_baud_rate:(Arb'ry baud BOTHER not set) c_cflag:020000006260 cbaud:00
[   10.770660] tty_termios_baud_rate:cbaud:00 baud_val:0

4.05 is failing:

alloc_set_baud_rate_cmd Setting arbitrary baudrate using BOTHER baudrate:89 c_cflag:020000016262
[    9.325225] av8100_hdmi av8100_hdmi.3: HDMI display probed
[    9.334686] XXXXXX_hci_uart_set_baudrate c_cflag:020000016262 baud:4050000, ispeed:4050000 ospeed:4050000
[    9.345275] tty_termios_encode_baud_rate c_ispeed:4050000 c_ospeed:4050000
[    9.352539] tty_termios_encode_baud_rate checking precise weird baudrate:0x80001cb2
[    9.360717] tty_termios_encode_baud_rate checking precise weird baudrate c_cflag:020000006260
[    9.369659] tty_termios_encode_baud_rate did we find close match? i:31 n_baud_table31 ifound:30 ofound:30
[    9.380035] tty_termios_encode_baud_rate BOTHER, c_cflag:020000016277
[    9.387237] tty_termios_baud_rate c_cflag:020000016277 cbaud:010017
[    9.393829] pl011_set_termios i_speed:4050000 o_speed:4050000
[    9.399993] tty_termios_baud_rate c_cflag:020000016277 cbaud:010017


4.8M Arbitrary BaudSetting Sequence:

[   10.004699] alloc_set_baud_rate_cmd Setting arbitrary baudrate using BOTHER baudrate:90 c_cflag:020000016262
[   10.114624] XXXXXX_hci_uart_set_baudrate c_cflag:020000016262 baud:4800000
[   10.122009] XXXXXX_hci_uart_set_baudrate arb flag set
[   10.127624] tty_termios_encode_baud_rate c_ispeed:4800000 c_ospeed:4800000
[   10.134887] tty_termios_encode_baud_rate checking precise weird baudrate:0x80001cb2
[   10.143218] tty_termios_encode_baud_rate checking precise weird baudrate c_cflag:020000006260
[   10.154113] tty_termios_encode_baud_rate did we find close match? i:31 n_baud_table31 ifound:-1 ofound:-1
[   10.172149] tty_termios_encode_baud_rate BOTHER, c_cflag:020000016260
[   10.178833] tty_termios_baud_rate c_cflag:020000016260 cbaud:010000
[   10.185424] tty_termios_baud_rate (Arb'ry baud set) c_cflag:020000016260 cbaud:010000
[   10.193572] i_speed:4800000 o_speed:4800000
[   10.197845] tty_termios_baud_rate c_cflag:020000016260 cbaud:010000
[   10.204620] tty_termios_baud_rate (Arb'ry baud set) c_cflag:020000016260 cbaud:010000
[   10.212799] pl011_set_termios baud:4800000 uart_clk:38400000 port:0 IBRD:1 FBRD:0
[   10.220764] XXXXXX-uart XXXXXX-uart.0: Baud rate changed to 4800000 baud
[   10.973632] Bluetooth: XXXXXX BT core is enabled
[   11.101867] Bluetooth: XXXXXX BT core is disabled


======================================================================================

Thanks,
Rajanikanth


-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] 
Sent: Thursday, January 12, 2012 5:19 PM
To: Rajanikanth H V
Cc: linux-serial@vger.kernel.org; linux-kernel@vger.kernel.org; gregkh@sude.de; linux-arm-kernel@lists.infradead.org
Subject: Re: tty/serial: Need clarification on Support for 4+M Baudrate

On Thu, 12 Jan 2012 10:49:38 +0100
Rajanikanth H V <rajanikanth.hv@stericsson.com> wrote:

> Alan,
> 
> Thanks for your response, suggested modification helped to get 4.8M baud
> but not 4.05M as this is being approximated to 4.0M baud which happens in
> tty_termios_encode_baud_rate(...).

Only if you don't have the BOTHER flag set and only for returned data to
user space.

When you do a TCSETS2 ioctl and have BOTHER set as the rate as well as a
c_ispeed/c_ospeed the exactly value is given to the driver.

Alan
