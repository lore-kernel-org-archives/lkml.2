Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab1FAWDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 18:03:39 -0400
Received: from mail.kernelconcepts.de ([212.60.202.196]:36856 "EHLO
	mail.kernelconcepts.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab1FAWDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 18:03:37 -0400
X-Greylist: delayed 2549 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jun 2011 18:03:37 EDT
Message-ID: <4DE6AD3B.4000600@kernelconcepts.de>
Date: Wed, 01 Jun 2011 23:20:59 +0200
From: Simon Budig <simon.budig@kernelconcepts.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Patch to add guarding parentheses to some macros in linux/input.h
X-Enigmail-Version: 1.1.2
Content-Type: multipart/mixed;
 boundary="------------060400010409090601040706"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060400010409090601040706
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi all.

This is a patch to add guarding parentheses around some macro argument
uses. This is good practice to avoid pitfalls like this:

ioctl (fd, EVIOCGABS (have_mt ? ABS_MT_POSITION_X : ABS_X), &abs);

Which currently totally does not do what is expected.

The attached patch adds parentheses to ensure correct operator precedence.

Please consider this for inclusion into the Linux Kernel.

Thanks,
        Simon
- -- 
       Simon Budig                        kernel concepts GbR
       simon.budig@kernelconcepts.de      Sieghuetter Hauptweg 48
       +49-271-771091-17                  D-57072 Siegen

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk3mrToACgkQO2O/RXesiHBWcQCfdYFhFgKGaxvE5szwIJe3vfNO
yy4AoJssXo0zvSYeVJqA/ViOVlq/ITyj
=jtQG
-----END PGP SIGNATURE-----

--------------060400010409090601040706
Content-Type: text/x-patch;
 name="input-fix-macros.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="input-fix-macros.patch"

commit c88a91cb31a158a5e993484d91a0634a2aab1a43
Author: Simon Budig <simon@budig.de>
Date:   Wed Jun 1 23:04:42 2011 +0200

    input: add guarding parentheses to macros
    
    Put parentheses around macro argument uses. This avoids pitfalls
    for the programmer, where the argument expansion does not give the
    expected result.
    
    Signed-off-by: Simon Budig <simon.budig@kernelconcepts.de>

diff --git a/include/linux/input.h b/include/linux/input.h
index 9e5393d..31dd2b8 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -109,19 +109,19 @@ struct input_keymap_entry {
 #define EVIOCSKEYCODE		_IOW('E', 0x04, unsigned int[2])        /* set keycode */
 #define EVIOCSKEYCODE_V2	_IOW('E', 0x04, struct input_keymap_entry)
 
-#define EVIOCGNAME(len)		_IOC(_IOC_READ, 'E', 0x06, len)		/* get device name */
-#define EVIOCGPHYS(len)		_IOC(_IOC_READ, 'E', 0x07, len)		/* get physical location */
-#define EVIOCGUNIQ(len)		_IOC(_IOC_READ, 'E', 0x08, len)		/* get unique identifier */
-#define EVIOCGPROP(len)		_IOC(_IOC_READ, 'E', 0x09, len)		/* get device properties */
-
-#define EVIOCGKEY(len)		_IOC(_IOC_READ, 'E', 0x18, len)		/* get global key state */
-#define EVIOCGLED(len)		_IOC(_IOC_READ, 'E', 0x19, len)		/* get all LEDs */
-#define EVIOCGSND(len)		_IOC(_IOC_READ, 'E', 0x1a, len)		/* get all sounds status */
-#define EVIOCGSW(len)		_IOC(_IOC_READ, 'E', 0x1b, len)		/* get all switch states */
-
-#define EVIOCGBIT(ev,len)	_IOC(_IOC_READ, 'E', 0x20 + ev, len)	/* get event bits */
-#define EVIOCGABS(abs)		_IOR('E', 0x40 + abs, struct input_absinfo)	/* get abs value/limits */
-#define EVIOCSABS(abs)		_IOW('E', 0xc0 + abs, struct input_absinfo)	/* set abs value/limits */
+#define EVIOCGNAME(len)		_IOC(_IOC_READ, 'E', 0x06, (len))	/* get device name */
+#define EVIOCGPHYS(len)		_IOC(_IOC_READ, 'E', 0x07, (len))	/* get physical location */
+#define EVIOCGUNIQ(len)		_IOC(_IOC_READ, 'E', 0x08, (len))	/* get unique identifier */
+#define EVIOCGPROP(len)		_IOC(_IOC_READ, 'E', 0x09, (len))	/* get device properties */
+
+#define EVIOCGKEY(len)		_IOC(_IOC_READ, 'E', 0x18, (len))	/* get global key state */
+#define EVIOCGLED(len)		_IOC(_IOC_READ, 'E', 0x19, (len))	/* get all LEDs */
+#define EVIOCGSND(len)		_IOC(_IOC_READ, 'E', 0x1a, (len))	/* get all sounds status */
+#define EVIOCGSW(len)		_IOC(_IOC_READ, 'E', 0x1b, (len))	/* get all switch states */
+
+#define EVIOCGBIT(ev,len)	_IOC(_IOC_READ, 'E', 0x20 + (ev), (len))	/* get event bits */
+#define EVIOCGABS(abs)		_IOR('E', 0x40 + (abs), struct input_absinfo)	/* get abs value/limits */
+#define EVIOCSABS(abs)		_IOW('E', 0xc0 + (abs), struct input_absinfo)	/* set abs value/limits */
 
 #define EVIOCSFF		_IOC(_IOC_WRITE, 'E', 0x80, sizeof(struct ff_effect))	/* send a force effect to a force feedback device */
 #define EVIOCRMFF		_IOW('E', 0x81, int)			/* Erase a force effect */

--------------060400010409090601040706--
