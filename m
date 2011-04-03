Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab1DCGSl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 02:18:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:56517 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751468Ab1DCGSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 02:18:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/6zuASACT6GgWgzU8F8ExBKtYcmWabaccjGE2vVw
	UTb38ZPDNQoe/d
Subject: Re: Soft lockup during suspend since ~2.6.36
From: Mike Galbraith <efault@gmx.de>
To: Thilo-Alexander Ginkel <thilo@ginkel.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <AANLkTim5ctAoaB4+BS7Z-+ARUgTEBO22bkYMUvFtGmoN@mail.gmail.com>
References: <AANLkTim5ctAoaB4+BS7Z-+ARUgTEBO22bkYMUvFtGmoN@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 03 Apr 2011 08:18:35 +0200
Message-ID: <1301811515.7592.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds CC to author of fingered commit.

On Sun, 2011-04-03 at 04:03 +0200, Thilo-Alexander Ginkel wrote:
> Hello everyone,
> 
> recently, I upgraded my Linux kernel (running on an Intel Core 2 Quad)
> from 2.6.35 to 2.6.38. Unfortunately, I have been experiencing
> frequent (but sporadic) freezes during suspend (S3) since then, i.e.,
> the system became completely unresponsive (even MagicSysRq stopped
> working) after having spun down the hard disks.
> 
> I performed a bisect, which pointed out the following commit:
> 
> bd25f4dd6972755579d0ea50d1a5ace2e9b00d1a is the first bad commit
> commit bd25f4dd6972755579d0ea50d1a5ace2e9b00d1a
> Author: Arnd Bergmann <arnd@arndb.de>
> Date:   Sun Jul 11 15:34:05 2010 +0200
> 
>     HID: hiddev: use usb_find_interface, get rid of BKL
> 
>     This removes the private hiddev_table in the usbhid
>     driver and changes it to use usb_find_interface
>     instead.
> 
>     The advantage is that we can avoid the race between
>     usb_register_dev and usb_open and no longer need the
>     big kernel lock.
> 
>     This doesn't introduce race condition -- the intf pointer could be
>     invalidated only in hiddev_disconnect() through usb_deregister_dev(),
>     but that will block on minor_rwsem and not actually remove the device
>     until usb_open().
> 
>     Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>     Cc: Jiri Kosina <jkosina@suse.cz>
>     Cc: "Greg Kroah-Hartman" <gregkh@suse.de>
>     Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> :040000 040000 4ae14b3ba486373d7a354874e9ad334858f094e3
> 8041ffda20ca3020a6b60d64235ae179f8186bf0 M      drivers
> 
> Booting with no_console_suspend also brings up a BUG mentioning a soft
> lockup. As my serial console breaks during suspend, I had to take
> photos of the error messages:
>   https://secure.tgbyte.de/dropbox/eaghoh9M.jpg
>   https://secure.tgbyte.de/dropbox/ecae8ieR.jpg
>   https://secure.tgbyte.de/dropbox/vah5ooR9.jpg
> 
> Unfortunately, I have so far been unable to get the complete error
> message in a single screen capture (as the output is either too
> verbose or too scarce).
> 
> This bug is present up to (and including) 2.6.38 (I did not try any
> later version).
> 
> I'd appreciate your help to fix this issue. Let me know if you need
> further details.
> 
> Thanks,
> Thilo
> 
> P.S.: Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=31562
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


