Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab1GZTdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 15:33:55 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58600 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab1GZTdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 15:33:53 -0400
Date: Tue, 26 Jul 2011 21:33:36 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>, Ray Lee <ray-lk@madrabbit.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110726193336.GH32536@aftab>
References: <20110724190752.GA13647@aftab>
 <20110724204450.GB18546@elte.hu>
 <20110725200014.GA23986@aftab>
 <20110725200645.GC8302@elte.hu>
 <20110725215328.GA25960@aftab>
 <CADU53JV-aKbRU-iixbqcv_kAci7L6z43GYmP6uw8hZdY4PrBbQ@mail.gmail.com>
 <20110726172801.GC32536@aftab>
 <20110726183430.GA501@elte.hu>
 <20110726183935.GG32536@aftab>
 <20110726184744.GA8422@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="i0/AhcQY5QxfSsSZ"
Content-Disposition: inline
In-Reply-To: <20110726184744.GA8422@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 26, 2011 at 02:47:44PM -0400, Ingo Molnar wrote:
> So, unless i got the stats right, unmodified kernel has like a 75%
> mis-aligned rate, while with the simple fix this goes down to 30%?

Nah, I don't think this workaround has such an impact. Due
to the differing link order and the workaround tweaking
_only_ the start of the VA space of the process (see
http://marc.info/?l=linux-kernel&m=131163083618197), it actually doesn't
change a lot:

Total r-xp mappings: 902, aliasing: 282 (31.264%)

(I know, I know, those are different numbers but the percentage is in
the same ballpark).

> Have you run the numbers on the stock, unmodified kernel by any 
> chance, just to make sure the stats are ok?

attached.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="unmodified-results.txt"

Library					[14:12]	count
=======					=======	=====
/usr/lib/gtk-2.0/2.10.0/engines/libclearlooks.so
					1	1
					2	2
					3	1
					6	2
/usr/lib/libxcb-render-util.so.0.0.0
					0	7
					1	6
					2	5
					3	9
					4	3
					5	11
					6	8
					7	15
/lib/libutil-2.11.2.so
					0	6
					1	3
					2	6
					3	3
					4	1
					5	1
					6	3
					7	4
/usr/lib/libatk-1.0.so.0.3009.1
					0	9
					1	11
					2	9
					3	7
					4	4
					5	7
					6	6
					7	11
[vdso]
					0	7
					1	6
					2	6
					3	8
					4	13
					5	8
					6	8
					7	58
/usr/lib/enchant/libenchant_aspell.so
					1	1
					2	1
					5	1
					6	1
/usr/lib/libical.so.0.44.0
					0	2
					7	2
/usr/lib/libpangocairo-1.0.so.0.2800.3
					0	10
					1	10
					2	5
					3	5
					4	9
					5	12
					6	1
					7	12
/usr/lib/pyshared/python2.6/gtk-2.0/atk.so
					4	2
					6	1
/usr/lib/nss/libsoftokn3.so
					2	1
					7	1
/usr/lib/libICE.so.6.3.0
					0	3
					1	7
					2	7
					3	4
					4	9
					5	5
					6	4
					7	5
/usr/lib/libebook-1.2.so.9.3.1
					0	2
					1	1
					2	1
					4	1
					5	1
					6	1
/usr/lib/libpolkit-gobject-1.so.0.0.0
					2	2
					3	2
					4	2
					5	1
					7	2
/usr/lib/libSM.so.6.0.1
					0	4
					1	5
					2	5
					3	4
					4	6
					5	7
					6	3
					7	10
/usr/lib/libsoup-2.4.so.1.3.0
					1	3
					2	1
					3	2
					5	3
					6	2
					7	2
/usr/lib/libXdamage.so.1.1.0
					0	10
					1	9
					2	10
					3	8
					4	11
					5	5
					6	6
					7	5
/lib/libbz2.so.1.0.4
					0	4
					1	2
					2	5
					3	1
					4	3
					5	4
					6	4
					7	2
/lib/security/pam_limits.so
					1	2
					7	1
/lib/libpthread-2.11.2.so
					0	6
					1	15
					2	15
					3	11
					4	12
					5	12
					6	11
					7	13
/usr/lib/libgailutil.so.18.0.1
					0	1
					1	5
					2	2
					3	2
					4	3
					5	3
					6	1
					7	1
/usr/lib/gstreamer-0.10/libgstossaudio.so
					3	1
					6	1
/lib/security/pam_motd.so
					5	1
					7	2
/usr/lib/libavahi-common.so.3.5.2
					1	4
					2	1
					3	3
					4	3
					5	6
					6	1
					7	2
/usr/lib/liblcms.so.1.0.18
					5	1
					6	1
/usr/lib/libcamel-1.2.so.14.0.1
					1	1
					3	3
					5	1
					6	1
					7	1
/usr/lib/libbonobo-2.so.0.0.0
					0	3
					1	3
					2	1
					3	1
					4	2
					5	1
					7	3
/usr/lib/libtdb.so.1.2.1
					0	5
					1	2
					2	1
					3	1
					5	3
					6	2
					7	3
/usr/lib/libvte.so.9.13.3
					2	1
					7	1
/lib/libcrypt-2.11.2.so
					0	1
					1	4
					2	3
					4	2
					5	3
					7	2
/usr/lib/libX11.so.6.3.0
					0	7
					1	9
					2	7
					3	4
					4	11
					5	7
					6	14
					7	9
/usr/lib/libcairomm-1.0.so.1.4.0
					1	1
					4	1
/usr/lib/libcurl-gnutls.so.4.2.0
					2	1
					4	1
/usr/lib/gtk-2.0/2.10.0/loaders/svg_loader.so
					0	2
					1	2
					3	3
					4	2
					5	1
					7	2
/lib/libnss_files-2.11.2.so
					0	14
					1	9
					2	5
					3	12
					4	13
					5	11
					6	16
					7	11
/usr/lib/libgtkhtml-editor.so.0.0.0
					3	1
					7	1
/lib/security/pam_ck_connector.so
					1	1
					3	2
/usr/lib/liborc-0.4.so.0.0.0
					4	2
					7	1
/usr/lib/libssl3.so.1d
					1	1
					2	1
					3	1
					5	4
					6	1
/lib/libnss_compat-2.11.2.so
					0	8
					1	5
					2	11
					3	14
					4	11
					5	15
					6	11
					7	14
/usr/lib/gtk-2.0/modules/libgail-gnome.so
					0	1
					1	1
					3	1
					4	3
/lib/libdbus-1.so.3.4.0
					0	9
					1	10
					2	9
					3	14
					4	9
					5	7
					6	18
					7	8
/usr/lib/libGL.so.1.2
					0	3
					3	1
					6	1
/usr/lib/libchamplain-gtk-0.4.so.0.3.3
					1	1
					6	1
/usr/lib/libexpat.so.1.5.2
					0	7
					1	5
					2	11
					3	9
					4	9
					5	13
					6	9
					7	9
/usr/lib/libxcb-event.so.1.0.0
					3	2
					4	4
					6	3
					7	2
/usr/lib/libz.so.1.2.3.4
					0	6
					1	9
					2	15
					3	11
					4	11
					5	8
					6	9
					7	17
/usr/lib/libpixman-1.so.0.16.4
					0	12
					1	8
					2	9
					3	5
					4	6
					5	4
					6	14
					7	7
/lib/libresolv-2.11.2.so
					0	15
					1	11
					2	10
					3	11
					4	9
					5	5
					6	9
					7	10
/usr/lib/nss/libfreebl3.so
					2	1
					4	1
/lib/libc-2.11.2.so
					0	14
					1	19
					2	14
					3	19
					4	13
					5	15
					6	11
					7	9
/usr/lib/libnss3.so.1d
					0	1
					1	1
					3	1
					4	1
					5	1
					7	4
/usr/lib/libk5crypto.so.3.1
					0	3
					1	3
					2	2
					3	1
					5	2
					6	1
					7	4
/usr/lib/gconv/ISO8859-1.so
					0	6
					1	12
					2	8
					3	9
					4	5
					5	9
					6	7
					7	4
/lib/security/pam_permit.so
					5	1
					7	2
/usr/lib/libpython2.6.so.1.0
					2	1
					6	1
					7	1
/usr/lib/pyshared/python2.6/gtk-2.0/pango.so
					1	2
					3	1
/usr/lib/enchant/libenchant_hspell.so
					2	1
					3	1
					6	1
					7	1
/usr/lib/libxml2.so.2.7.8
					0	5
					1	9
					2	1
					3	6
					4	5
					5	9
					6	7
					7	5
/usr/lib/libxcb-atom.so.1.0.0
					0	4
					2	3
					3	2
					7	2
/usr/lib/libxkbfile.so.1.0.2
					6	1
					7	1
/usr/lib/libedata-book-1.2.so.2.4.1
					0	1
					5	1
/usr/lib/libgstvideo-0.10.so.0.21.0
					1	1
					2	1
					3	1
					5	1
					6	1
					7	3
/usr/lib/libXau.so.6.0.0
					0	8
					1	9
					2	7
					3	9
					4	8
					5	12
					6	5
					7	11
/usr/lib/libORBit-2.so.0.1.0
					0	12
					1	3
					2	8
					3	9
					4	4
					5	9
					6	10
					7	7
/usr/bin/dbus-daemon
					3	2
					5	1
/usr/lib/libsoup-gnome-2.4.so.1.3.0
					0	1
					2	1
					3	1
					4	1
					5	1
					6	1
					7	1
/usr/lib/librsvg-2.so.2.26.3
					0	6
					1	1
					2	1
					3	3
					4	2
					5	2
					6	4
					7	4
/usr/lib/enchant/libenchant_ispell.so
					0	1
					4	1
					6	1
					7	1
/usr/lib/libjson-glib-1.0.so.0.1000.2
					0	2
					3	1
					6	1
/usr/lib/libgtop-2.0.so.7.2.0
					2	1
					3	1
					4	1
					5	1
/lib/libuuid.so.1.3.0
					0	7
					1	3
					2	6
					3	3
					4	7
					5	5
					6	4
					7	10
/usr/lib/pyshared/python2.6/gtk-2.0/gtk/_gtk.so
					5	1
					6	2
/usr/lib/gtk-2.0/2.10.0/loaders/libpixbufloader-xpm.so
					0	5
					1	2
					2	2
					3	2
					4	1
					5	2
					6	1
					7	3
/usr/lib/libsqlite3.so.0.8.6
					0	2
					2	2
					3	2
					4	2
					5	3
					6	2
					7	1
/usr/lib/libclutter-glx-1.0.so.0.200.12
					4	3
					7	1
/usr/lib/libvorbis.so.0.4.4
					1	3
					2	2
					3	3
					4	5
					5	2
					6	1
					7	1
/usr/lib/libsasl2.so.2.0.23
					1	1
					2	2
					3	1
					4	1
					5	1
/usr/lib/libXrender.so.1.3.0
					0	3
					1	14
					2	6
					3	9
					4	5
					5	6
					6	13
					7	9
/lib/libm-2.11.2.so
					0	12
					1	11
					2	13
					3	5
					4	12
					5	9
					6	6
					7	7
/usr/lib/libtiff.so.4.3.3
					0	1
					2	1
/lib/security/pam_env.so
					1	1
					3	2
/usr/lib/libclutter-gtk-0.10.so.0.0.0
					3	3
					6	1
/usr/lib/libstdc++.so.6.0.13
					0	1
					1	2
					2	1
					3	4
					4	1
					5	2
					6	3
					7	2
/usr/lib/libXext.so.6.4.0
					0	10
					1	11
					2	3
					3	12
					4	5
					5	9
					6	9
					7	6
/usr/lib/libenchant.so.1.6.0
					0	2
					1	2
					2	1
					5	2
					6	1
					7	2
/usr/lib/libgnomeui-2.so.0.2400.3
					0	1
					5	1
/usr/lib/libexif.so.12.3.1
					2	1
					4	1
/lib/libnss_mdns4_minimal.so.2
					0	1
					2	2
					4	3
					6	1
/usr/lib/pyshared/python2.6/gtk-2.0/gconf.so
					4	1
					5	1
					7	1
/usr/lib/libdrm.so.2.4.0
					0	3
					1	1
					4	1
					5	1
/usr/lib/libgdkmm-2.4.so.1.1.0
					0	1
					3	1
/usr/lib/libgdbm.so.3.0.0
					0	1
					4	1
/usr/lib/libdbus-glib-1.so.2.1.0
					0	6
					1	13
					2	9
					3	12
					4	11
					5	7
					6	13
					7	5
/usr/lib/libicalvcal.so.0.44.0
					0	1
					2	1
					3	2
/usr/lib/libgtkmm-2.4.so.1.1.0
					0	1
					2	1
/usr/lib/libtasn1.so.3.1.9
					0	3
					1	3
					2	4
					3	4
					4	4
					5	6
					6	4
					7	4
/lib/libacl.so.1.1.0
					2	1
					3	1
/usr/lib/libgstaudio-0.10.so.0.21.0
					1	1
					4	1
					5	1
					6	1
/usr/lib/gtk-2.0/2.10.0/loaders/libpixbufloader-png.so
					0	7
					1	4
					2	3
					3	3
					4	2
					5	2
					6	1
					7	1
/usr/lib/libXtst.so.6.1.0
					0	1
					3	2
					5	1
					6	1
/usr/lib/libunique-1.0.so.0.100.6
					0	1
					1	1
					3	2
					4	1
					6	2
					7	2
/usr/lib/libldap_r-2.4.so.2.5.6
					1	3
					3	2
					4	1
/usr/lib/pyshared/python2.6/gtk-2.0/gio/unix.so
					2	2
					4	1
/usr/lib/gvfs/libgvfscommon.so
					1	2
					2	1
					4	3
					5	2
					6	2
					7	2
/usr/lib/libegroupwise-1.2.so.13.0.1
					0	1
					5	1
/lib/libdl-2.11.2.so
					0	18
					1	13
					2	9
					3	10
					4	14
					5	10
					6	18
					7	15
/usr/lib/libORBitCosNaming-2.so.0.1.0
					0	4
					1	1
					2	2
					5	3
					6	3
					7	1
/lib/security/pam_nologin.so
					3	1
					5	2
/usr/lib/libproxy.so.0.0.0
					0	1
					2	2
					4	3
					7	1
/usr/lib/libnm-glib.so.2.2.3
					2	1
					3	1
					4	1
					5	1
/usr/lib/libjpeg.so.62.0.0
					0	2
					1	1
					4	1
					5	1
					6	2
					7	4
/lib/libnsl-2.11.2.so
					0	10
					1	7
					2	10
					3	13
					4	12
					5	15
					6	12
					7	12
/usr/lib/libgstinterfaces-0.10.so.0.21.0
					0	1
					2	1
					4	1
					5	1
					7	2
/usr/lib/gstreamer-0.10/libgstgconfelements.so
					0	1
					2	1
/usr/lib/libfontconfig.so.1.4.4
					0	9
					1	6
					2	14
					3	8
					4	7
					5	8
					6	4
					7	8
/usr/lib/libnssutil3.so.1d
					1	1
					3	5
					4	1
					5	1
					7	1
/lib/libpam.so.0.82.2
					0	1
					1	2
					2	1
					4	2
					5	3
					7	1
/usr/lib/libfreetype.so.6.6.0
					0	8
					1	7
					2	7
					3	6
					4	6
					5	12
					6	12
					7	7
/lib/libselinux.so.1
					0	6
					1	10
					2	16
					3	13
					4	8
					5	16
					6	8
					7	10
/usr/lib/libaudiofile.so.0.0.2
					1	2
					3	3
					5	1
					6	2
					7	2
/usr/lib/libgksu2.so.0.0.2
					1	1
					6	1
/usr/lib/libgnome-2.so.0.3000.0
					2	1
					3	2
					4	1
					5	2
					6	3
					7	1
/usr/lib/libgssapi_krb5.so.2.2
					0	5
					1	1
					3	2
					4	2
					5	2
					6	1
					7	3
/usr/lib/libnotify.so.1.2.3
					0	1
					1	1
					2	3
					4	2
					5	1
					6	2
/usr/lib/libXxf86vm.so.1.0.0
					0	3
					1	1
					3	2
					4	1
/usr/lib/libpanel-applet-2.so.0.2.68
					0	1
					1	1
					2	1
					4	1
					5	3
					6	1
/usr/lib/libwnck-1.so.22.3.29
					0	1
					3	1
					6	1
/usr/lib/libnm-util.so.1.3.4
					0	1
					2	1
					4	1
					7	1
/lib/libattr.so.1.1.0
					1	2
					5	2
					6	1
					7	2
/usr/lib/libgdata-google-1.2.so.1.0.0
					2	1
					6	1
/lib/libcom_err.so.2.1
					0	1
					2	3
					3	1
					4	5
					5	4
					6	1
					7	1
/lib/libnss_mdns4.so.2
					0	2
					6	1
/usr/lib/libxcb.so.1.1.0
					0	9
					1	7
					2	7
					3	13
					4	10
					5	5
					6	9
					7	8
/usr/lib/libwebkit-1.0.so.2.17.9
					0	1
					1	1
					4	1
					6	1
					7	1
/usr/lib/libbrasero-utils.so.0.2.0
					2	1
					6	1
/usr/lib/libxcb-render.so.0.0.0
					0	7
					1	6
					2	5
					3	9
					4	3
					5	11
					6	8
					7	15
/usr/lib/libcups.so.2
					0	1
					1	1
					6	1
/usr/lib/libgdk_pixbuf-2.0.so.0.2000.1
					0	4
					1	9
					2	9
					3	9
					4	14
					5	4
					6	7
					7	8
/usr/lib/libbonobo-activation.so.4.0.0
					0	1
					1	2
					2	1
					4	3
					5	3
					6	2
					7	2
/usr/lib/libXi.so.6.1.0
					0	13
					1	5
					2	9
					3	6
					4	6
					5	12
					6	10
					7	4
/usr/lib/libupower-glib.so.1.0.1
					3	1
					4	1
					7	2
/lib/security/pam_unix.so
					1	2
					7	1
/lib/libusb-0.1.so.4.4.4
					4	1
					7	1
/usr/lib/libgmime-2.4.so.2.4.14
					1	1
					4	1
					6	1
					7	1
/usr/lib/libavahi-client.so.3.2.7
					1	2
					2	1
					3	3
					4	3
					5	6
					6	1
					7	2
/usr/lib/libXss.so.1.0.0
					2	1
					7	1
/lib/libglib-2.0.so.0.2400.2
					0	11
					1	7
					2	9
					3	12
					4	7
					5	11
					6	14
					7	8
/usr/lib/libgtkspell.so.0.0.0
					1	1
					5	1
/lib/security/pam_deny.so
					0	2
					6	1
/usr/lib/enchant/libenchant_myspell.so
					1	1
					2	1
					5	1
					6	1
/usr/lib/libXrandr.so.2.2.0
					0	13
					1	5
					2	10
					3	7
					4	6
					5	10
					6	9
					7	4
/usr/lib/libffi.so.5.0.10
					2	2
					3	2
/usr/lib/libnl.so.1.1
					1	1
					5	1
/lib/libwrap.so.0.7.6
					0	2
					1	1
					2	2
					5	1
					6	1
/usr/lib/libv4l2.so.0
					1	1
					7	1
/usr/sbin/sshd
					1	2
					2	1
					7	1
/usr/lib/libgimpmodule-2.0.so.0.600.10
					2	1
					5	1
/usr/lib/libck-connector.so.0.0.0
					0	2
					6	1
/usr/lib/libgnome-desktop-2.so.17.1.0
					3	2
					4	1
					7	2
/usr/lib/gio/modules/libgvfsdbus.so
					0	1
					5	2
/usr/lib/libpangoft2-1.0.so.0.2800.3
					0	10
					1	12
					2	7
					3	10
					4	7
					5	6
					6	6
					7	6
/lib/libudev.so.0.9.3
					0	2
					1	2
					2	1
					3	2
					6	5
					7	1
/usr/lib/libbonoboui-2.so.0.0.0
					0	2
					1	2
					2	1
					4	1
					5	4
/usr/lib/libv4lconvert.so.0
					1	1
					3	1
/usr/lib/libvorbisfile.so.3.3.2
					0	5
					1	2
					2	1
					3	1
					5	3
					6	2
					7	3
/usr/lib/libgobject-2.0.so.0.2400.2
					0	10
					1	12
					2	10
					3	14
					4	7
					5	12
					6	9
					7	5
/usr/lib/libgcrypt.so.11.5.3
					0	3
					1	7
					2	4
					3	7
					4	4
					5	3
					6	5
					7	4
/lib/libpcre.so.3.12.1
					0	10
					1	8
					2	6
					3	8
					4	10
					5	9
					6	17
					7	12
/usr/lib/libesd.so.0.2.39
					1	2
					3	3
					5	1
					6	2
					7	2
/usr/lib/libgimpmath-2.0.so.0.600.10
					3	1
					7	1
/usr/lib/libhunspell-1.2.so.0.0.0
					0	1
					3	1
					4	1
					5	1
					7	1
/lib/libaudit.so.0.0.0
					3	1
					4	1
					5	1
/usr/lib/libicalss.so.0.44.0
					4	1
					6	1
					7	2
/lib/libcap.so.2.19
					2	2
					6	1
/usr/lib/libXinerama.so.1.0.0
					0	5
					1	9
					2	6
					3	6
					4	11
					5	10
					6	4
					7	13
/usr/lib/libxklavier.so.16.0.0
					5	1
					7	1
/usr/lib/libgimpwidgets-2.0.so.0.600.10
					1	1
					7	1
/usr/lib/libgimpbase-2.0.so.0.600.10
					1	1
					3	1
/usr/lib/libedataserver-1.2.so.13.0.1
					1	2
					2	2
					4	2
					5	1
/usr/lib/libicuuc.so.44.1
					1	1
					3	1
					6	3
					7	1
/lib/libnss_nis-2.11.2.so
					0	13
					1	11
					2	15
					3	11
					4	14
					5	8
					6	5
					7	12
/usr/lib/liblber-2.4.so.2.5.6
					2	1
					3	2
					4	1
					5	1
					6	1
/usr/lib/libkrb5.so.3.3
					0	2
					1	1
					3	3
					4	1
					5	3
					6	3
					7	3
/lib/libkeyutils.so.1.3
					0	2
					2	5
					3	3
					4	2
					5	2
					7	2
/lib/libpng12.so.0.44.0
					0	12
					1	9
					2	13
					3	8
					4	7
					5	4
					6	8
					7	3
/usr/lib/libpyglib-2.0-python2.6.so.0.0.0
					2	2
					3	1
/usr/lib/libglibmm-2.4.so.1.3.0
					2	1
					4	1
/usr/lib/libnspr4.so.0d
					0	4
					2	3
					6	2
/usr/lib/libgnutls.so.26.14.12
					0	5
					1	5
					2	5
					3	6
					4	5
					5	1
					6	3
					7	2
/usr/lib/libebackend-1.2.so.0.0.1
					2	1
					3	1
/usr/lib/libart_lgpl_2.so.2.3.21
					1	2
					3	2
					4	1
					5	2
					6	5
/usr/lib/libchamplain-0.4.so.0.3.3
					2	1
					7	1
/usr/lib/libcamel-provider-1.2.so.14.0.1
					0	1
					1	1
/usr/lib/libgsttag-0.10.so.0.21.0
					5	1
					7	1
/usr/lib/lapack/liblapack.so.3gf.0
					0	1
					3	1
/usr/lib/libgnome-keyring.so.0.1.1
					0	1
					1	4
					2	1
					4	5
					5	1
					6	3
					7	1
/lib/librt-2.11.2.so
					0	9
					1	12
					2	12
					3	9
					4	12
					5	8
					6	9
					7	21
/usr/lib/pyshared/python2.6/gtk-2.0/glib/_glib.so
					5	1
					6	2
/usr/lib/evolution/2.30/libeutil.so.0.0.0
					0	1
					1	1
/usr/lib/libXfixes.so.3.1.0
					0	5
					1	7
					2	4
					3	12
					4	8
					5	10
					6	10
					7	9
/lib/security/pam_gnome_keyring.so
					5	1
					7	2
/usr/lib/libtelepathy-glib.so.0.40.0
					0	1
					2	1
					5	1
/usr/lib/pango/1.6.0/modules/pango-basic-fc.so
					0	5
					1	10
					2	6
					3	2
					4	3
					5	5
					6	9
					7	6
/usr/lib/libgudev-1.0.so.0.0.1
					0	1
					1	1
					2	2
					4	2
					5	1
					7	1
/usr/lib/libgsf-1.so.114.0.18
					0	3
					1	4
					2	3
					3	2
					4	6
					5	2
					6	1
					7	2
/lib/libncurses.so.5.7
					0	1
					1	2
					2	1
					4	3
					6	1
					7	1
/usr/lib/libgstpbutils-0.10.so.0.21.0
					1	2
					3	2
					6	1
					7	3
/usr/lib/pyshared/python2.6/gtk-2.0/gobject/_gobject.so
					6	2
					7	1
/usr/lib/libplds4.so.0d
					0	3
					2	4
					4	2
/usr/lib/libgpg-error.so.0.4.0
					0	4
					1	4
					2	4
					3	2
					4	8
					5	3
					6	4
					7	8
/usr/lib/libsmime3.so.1d
					1	1
					3	1
					4	1
					5	4
					6	1
/usr/lib/gstreamer-0.10/libgstalsa.so
					0	1
					6	1
/usr/lib/gio/modules/libgioremote-volume-monitor.so
					0	1
					2	2
					3	1
					5	1
					6	2
					7	1
/usr/lib/libgnomecanvas-2.so.0.3000.1
					2	2
					4	2
					5	2
					6	2
					7	4
/usr/lib/libgstfarsight-0.10.so.0.5.0
					2	1
					5	1
/usr/lib/libcanberra.so.0.2.3
					0	6
					1	1
					2	1
					3	1
					5	5
					6	1
					7	2
/usr/lib/pyshared/python2.6/cairo/_cairo.so
					3	1
					4	1
					7	1
/usr/lib/libcrypto.so.0.9.8
					0	3
					1	1
					2	1
					3	3
					4	2
					5	3
					6	2
/usr/lib/libatkmm-1.6.so.1.1.0
					4	1
					5	1
/usr/lib/libcairo.so.2.10800.10
					0	17
					1	2
					2	4
					3	8
					4	4
					5	8
					6	9
					7	12
/usr/lib/libaspell.so.15.1.4
					0	1
					3	1
					4	1
					7	2
/usr/lib/libgstreamer-0.10.so.0.26.0
					0	1
					1	3
					2	2
					5	3
					7	1
/usr/lib/gtk-2.0/modules/libgail.so
					0	1
					1	1
					3	1
					4	2
					5	1
/usr/lib/libXv.so.1.0.0
					3	1
					6	1
/usr/lib/libgconf2-4/2/libgconfbackend-xml.so
					5	1
					6	1
/usr/lib/libgiomm-2.4.so.1.3.0
					1	1
					4	1
/usr/lib/libXt.so.6.0.0
					2	2
					3	1
					4	1
					5	2
					7	2
/usr/lib/libsigc-2.0.so.0.0.0
					0	1
					4	1
					6	1
/usr/lib/libgeoclue.so.0.0.0
					4	1
					7	1
/usr/lib/libgdk-x11-2.0.so.0.2000.1
					0	13
					1	8
					2	12
					3	7
					4	8
					5	6
					6	7
					7	3
/usr/lib/libgtkhtml-3.14.so.19.1.1
					1	1
					2	1
/usr/lib/libXRes.so.1.0.0
					3	1
					4	1
					6	1
/usr/lib/libidn.so.11.5.44
					2	1
					4	1
/usr/lib/libgthread-2.0.so.0.2400.2
					0	6
					1	11
					2	15
					3	10
					4	12
					5	6
					6	7
					7	12
/usr/lib/libgstbase-0.10.so.0.26.0
					0	1
					1	1
					2	2
					3	1
					4	3
					5	1
/usr/lib/libgio-2.0.so.0.2400.2
					0	4
					1	10
					2	11
					3	8
					4	9
					5	13
					6	12
					7	6
/usr/lib/libedataserverui-1.2.so.8.1.1
					3	1
					5	1
					6	1
/usr/lib/libkrb5support.so.0.1
					1	2
					2	3
					4	5
					5	3
					6	1
					7	2
/usr/lib/libgdata-1.2.so.1.0.0
					3	1
					7	1
/usr/lib/libcroco-0.6.so.3.0.1
					0	2
					1	6
					2	2
					3	1
					4	2
					5	3
					6	4
					7	3
/usr/lib/libogg.so.0.7.0
					0	1
					1	2
					3	3
					4	2
					5	3
					6	5
					7	2
/usr/lib/dri/swrast_dri.so
					1	1
					3	1
					5	1
					6	1
/usr/lib/libgtk-x11-2.0.so.0.2000.1
					0	7
					1	6
					2	9
					3	6
					4	4
					5	13
					6	8
					7	11
/usr/lib/libavahi-glib.so.1.0.2
					0	2
					1	3
					2	1
					4	3
					5	2
					6	1
					7	3
/usr/lib/libdb-4.8.so
					0	1
					1	1
					5	1
					6	2
/usr/lib/libeggdbus-1.so.0.0.0
					0	3
					2	1
					4	2
					5	2
					7	1
/usr/lib/libicui18n.so.44.1
					0	2
					2	1
					5	2
					6	1
/usr/lib/libssl.so.0.9.8
					1	3
					3	1
					4	2
					5	2
					7	1
/usr/lib/libXcursor.so.1.0.2
					0	9
					1	6
					2	5
					3	13
					4	10
					5	4
					6	13
					7	5
/usr/lib/libXcomposite.so.1.0.0
					0	7
					1	4
					2	11
					3	7
					4	10
					5	9
					6	9
					7	7
/usr/lib/nss/libnssckbi.so
					3	1
					5	1
/usr/lib/libltdl.so.7.2.1
					0	2
					1	1
					2	1
					4	3
					5	3
					6	4
					7	5
/usr/lib/libtelepathy-farsight.so.0.1.1
					3	1
					6	1
/usr/lib/libcanberra-gtk.so.0.1.6
					0	6
					1	1
					2	1
					3	1
					5	5
					6	1
					7	2
/lib/libpopt.so.0.0.0
					0	3
					1	2
					2	1
					3	2
					6	1
					7	2
/usr/lib/libgnomevfs-2.so.0.2400.3
					0	1
					1	3
					2	1
					3	1
					4	1
					5	1
					6	3
/usr/lib/python2.6/lib-dynload/pyexpat.so
					2	1
					7	1
/usr/lib/gstreamer-0.10/libgstplaybin.so
					1	1
					7	1
/usr/lib/libavahi-ui.so.0.1.2
					1	1
					3	1
/usr/lib/libgstapp-0.10.so.0.21.0
					1	1
					4	1
					5	3
/usr/lib/libpango-1.0.so.0.2800.3
					0	2
					1	8
					2	10
					3	10
					4	6
					5	12
					6	12
					7	4
/usr/lib/libgconf-2.so.4.1.5
					0	10
					1	2
					2	3
					3	10
					4	5
					5	11
					6	12
					7	7
/usr/lib/gtk-2.0/modules/libatk-bridge.so
					2	1
					3	1
					5	1
					6	2
					7	1
/usr/lib/libasound.so.2.0.0
					1	3
					3	2
					4	1
					5	3
					6	2
					7	1
/lib/libgcc_s.so.1
					0	3
					1	4
					2	1
					3	2
					4	4
					5	4
					6	1
/usr/lib/pyshared/python2.6/gtk-2.0/pangocairo.so
					1	1
					7	2
/usr/lib/libstartup-notification-1.so.0.0.0
					0	1
					2	2
					3	1
					5	3
					6	2
					7	2
/lib/ld-2.11.2.so
					0	8
					1	21
					2	17
					3	11
					4	8
					5	16
					6	15
					7	18
/usr/lib/libblas/libblas.so.3gf.0
					2	1
					7	1
/usr/lib/gstreamer-0.10/libgstcoreelements.so
					4	1
					6	1
/usr/lib/libgfortran.so.3.0.0
					3	1
					7	1
/lib/security/pam_mail.so
					3	1
					5	2
/usr/lib/libXdmcp.so.6.0.0
					0	13
					1	6
					2	12
					3	8
					4	8
					5	7
					6	8
					7	7
/usr/lib/libspi.so.0.10.11
					0	1
					3	1
					4	1
					6	1
					7	3
/usr/lib/libxcb-aux.so.0.0.0
					0	4
					2	3
					3	2
					7	2
/usr/lib/libxslt.so.1.1.26
					0	1
					1	1
					2	1
					3	1
					4	2
					5	1
/usr/lib/libgmodule-2.0.so.0.2400.2
					0	9
					1	5
					2	7
					3	7
					4	8
					5	11
					6	15
					7	16
/usr/lib/libtotem-plparser.so.17.0.0
					0	2
					4	1
/usr/lib/pyshared/python2.6/gtk-2.0/gio/_gio.so
					1	1
					2	1
					4	1
/usr/lib/libplc4.so.0d
					0	3
					4	2
					6	4
/lib/libnss_dns-2.11.2.so
					0	1
					2	2
					4	2
					6	2
/usr/lib/libecal-1.2.so.7.2.2
					5	1
					6	1
					7	2
Total r-xp mappings: 902, aliasing: 282 (31.264%)

--i0/AhcQY5QxfSsSZ--
