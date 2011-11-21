Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab1KUPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 10:25:28 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57328 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab1KUPZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 10:25:26 -0500
Date: Mon, 21 Nov 2011 17:25:06 +0200
From: Johan Hedberg <johan.hedberg@gmail.com>
To: =?iso-8859-15?Q?Tom=E1=A8_Janou=A8ek?= <tomi@nomi.cz>
Cc: Szymon Janc <szymon@janc.net.pl>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] resume takes 10s longer due to e1b6eb3 (Bluetooth:
 Increase HCI reset timeout ...)
Message-ID: <20111121152506.GB15633@fusion.localdomain>
Mail-Followup-To: =?iso-8859-15?Q?Tom=E1=A8_Janou=A8ek?= <tomi@nomi.cz>,
	Szymon Janc <szymon@janc.net.pl>,
	"Gustavo F. Padovan" <padovan@profusion.mobi>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20111118184017.GA5052@nomi.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111118184017.GA5052@nomi.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomá¨,

On Fri, Nov 18, 2011, Tomá¨ Janou¨ek wrote:
> while testing the 3.2-rc kernel, I experienced that resume takes 10 seconds
> more than usual, and bisected this to be caused by e1b6eb3 (Bluetooth:
> Increase HCI reset timeout in hci_dev_do_close).
> 
> My hardware is Lenovo ThinkPad T420, model number 4178-A3G, with a Broadcom
> Bluetooth adapter (I'm attaching the relevant part of lsusb).
> 
> The relevant portion of dmesg is:
> [   76.502818] usb 1-1.4: reset full-speed USB device number 4 using ehci_hcd
> [   76.588225] btusb 1-1.4:1.0: no reset_resume for driver btusb?
> [   76.591870] btusb 1-1.4:1.1: no reset_resume for driver btusb?
> [   86.565269] PM: resume of devices complete after 10486.220 msecs
> 
> My resume scripts did contain a hciconfig hci0 down followed by up, because
> on my previous notebook (and the kernel I used at the time) it was needed for
> BT to work after suspend. On this hardware, however, none of that is needed.
> Bluetooth after suspend works regardless of whether that patch is applied or
> not, and I believe it would wait indefinitely if given large enough timeout.
> 
> Aside from reverting the patch, doing the following before suspend also works
> around the issue:
>     echo disable > /proc/acpi/ibm/bluetooth

It might be worth to try out the two patches I just sent to
linux-bluetooth for HCI command failure tracking. They make sure that
failures are properly caught which should help avoid triggering the
timeout in certain scenarios (and yours might be one of them).

Johan
