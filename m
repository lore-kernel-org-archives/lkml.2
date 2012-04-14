Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab2DNGtf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 02:49:35 -0400
Received: from asix.com.tw ([113.196.140.82]:55394 "EHLO asix.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab2DNGte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 02:49:34 -0400
From: "Donald" <donald@asix.com.tw>
To: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>
Cc: "'Greg KH'" <gregkh@linuxfoundation.org>,
        "'open list:USB SUBSYSTEM'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <005301cd1871$87391a90$95ab4fb0$@com.tw>	<20120412104936.65dd7683@pyramind.ukuu.org.uk>	<002701cd191c$1077d580$31678080$@com.tw> <20120413135710.32cb3170@pyramind.ukuu.org.uk>
In-Reply-To: <20120413135710.32cb3170@pyramind.ukuu.org.uk>
Subject: RE: Patch "USB: serial: mos7840: Supported MCS7810 device"
Date: Sat, 14 Apr 2012 14:48:45 +0800
Message-ID: <001c01cd1a0a$a792e6f0$f6b8b4d0$@com.tw>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac0ZdK/NhXXEQIbOQ9ula3dFjYjxHgAkoqzg
Content-Language: zh-tw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan and Greg,

Thank you for your replies and help in clarifying LED feature handling in driver. I will modify the driver according to your
suggestion and will re-submit the patch again as soon as possible.   

Regards,
Donald

-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] 
Sent: Friday, April 13, 2012 8:57 PM
To: Donald
Cc: 'Greg KH'; 'open list:USB SUBSYSTEM'; 'open list'
Subject: Re: Patch "USB: serial: mos7840: Supported MCS7810 device"

On Fri, 13 Apr 2012 10:20:52 +0800
"Donald" <donald@asix.com.tw> wrote:

> Hi Alan,
> 
> Thank you for your reply. As for your comment regarding the LED 
> feature flag, the driver can provide a flag parameter for LED feature 
> so that users will be able to set this LED feature at loading the driver, and by default, this flag is set false (LED feature is
disabled). Could you let me know if this is what exactly matches your comment?

What I mean is that all over the code you have added

if (serial->num_ports == 1 && mos7840_port->...)


If a future device has LEDs and multiple ports, or a future device has one port and no LED then all of them will need changing.

Instead if you had code in one place at initialisation which did


	if (type == 7840 && serial->num_ports == 1)
			mos7840_port->has_led = true;


then elsewhere did


	if (mos7840_port->has_led && ....)


then it will avoid problems in the future.


