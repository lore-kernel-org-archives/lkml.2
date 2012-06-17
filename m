Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab2FQI6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 04:58:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43996 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab2FQI6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 04:58:16 -0400
Message-ID: <4FDD9BEE.9010800@gmail.com>
Date: Sun, 17 Jun 2012 18:57:18 +1000
From: Veyrdite <veyrdite@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-console@vger.kernel.org
Subject: Re: wishlist: vnc framebuffer device?
References: <4FDC6874.4070106@afaics.de>
In-Reply-To: <4FDC6874.4070106@afaics.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Harald,

 > To make a headless system "less headless", would it be possible
 > to integrate a vnc framebuffer device into the kernel?

VNC as I understand is more suitable for graphical environments.  For
just text SSH or even telnet/netcat would be more practical.

 > The idea is to have a vnc server instead of a local screen and
 > keyboard to show the boot output and to provide a console login
 > on /dev/tty{1..6}. It would be pretty similar to qemu. No need
 > for fancy graphics, of course. The IP address might either be
 > obtained using DHCP, or it might use an IP address/netmask
 > given on the kernel command line.

As I understand it most init implementations log all of their messages
to a file in /var/log, so you can view them all post-bootup once you
have vnc'd or into the box.  This would be the simplest and most
foolproof solution, but may not be what you want.

If you are going to send your messaged over a trusted LAN or network
( ie not the internet ) then I'd go with the 'netconsole' module for the
kernel.

See https://www.kernel.org/doc/Documentation/networking/netconsole.txt

It (hopefully) would just require an extra kernel command line on the
headless machine and a 'netcat -ul portnumber' on the receiving machine.
  'Hopefully' because I am unsure if your kern

The problem is that everything is sent as unencrypted plaintext.

 > I understand that authentication might be an issue here.

Yes, if you mean the security of the transmitted data.

It is unlikely your ISP and other routing companies will violate your
security, but there is always a risk of someone doing something they
shouldn't be.  It is also *very* unhackerlike to send any plaintext over
the internet, and you should be secretly ashamed deep down if you do so.

If you do need to secure this information, it might be possible to link
SSH to your innitab and have things sent that way.  That is idealistic.

In the worst case scenario, you will just have to write a script that
acts as an init service that delays all bootup until it can make an SSH
connection to another computer and shove the lines of bootup information
from /var/log to the other computer as they appear.

If my words have gone over your head, please tell me.  I have no clue
what you skill level and experience is, and I am making assumptions :)

Regards, William
