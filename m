Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab2DMMyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 08:54:41 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54875 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab2DMMyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 08:54:40 -0400
Date: Fri, 13 Apr 2012 13:57:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Donald" <donald@asix.com.tw>
Cc: "'Greg KH'" <gregkh@linuxfoundation.org>,
        "'open list:USB SUBSYSTEM'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: Patch "USB: serial: mos7840: Supported MCS7810 device"
Message-ID: <20120413135710.32cb3170@pyramind.ukuu.org.uk>
In-Reply-To: <002701cd191c$1077d580$31678080$@com.tw>
References: <005301cd1871$87391a90$95ab4fb0$@com.tw>
	<20120412104936.65dd7683@pyramind.ukuu.org.uk>
	<002701cd191c$1077d580$31678080$@com.tw>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012 10:20:52 +0800
"Donald" <donald@asix.com.tw> wrote:

> Hi Alan,
> 
> Thank you for your reply. As for your comment regarding the LED feature flag, the driver can provide a flag parameter for LED
> feature so that users will be able to set this LED feature at loading the driver, and by default, this flag is set false (LED
> feature is disabled). Could you let me know if this is what exactly matches your comment?

What I mean is that all over the code you have added

if (serial->num_ports == 1 && mos7840_port->...)


If a future device has LEDs and multiple ports, or a future device has
one port and no LED then all of them will need changing.

Instead if you had code in one place at initialisation which did


	if (type == 7840 && serial->num_ports == 1)
			mos7840_port->has_led = true;


then elsewhere did


	if (mos7840_port->has_led && ....)


then it will avoid problems in the future.

