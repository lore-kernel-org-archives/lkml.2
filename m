Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab2KPDQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 22:16:29 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:58742 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab2KPDQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 22:16:28 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: IRQ_FORCED_THREADING - possible build issue?
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1353035774_61307P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 15 Nov 2012 22:16:15 -0500
Message-ID: <61883.1353035775@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.50A5AFFF.006E,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1353035774_61307P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <61872.1353035766.1@turing-police.cc.vt.edu>

While trying to clean old cruft out of grub.conf, I
chased down a 'threadirqs' parameter.

kernel/irq/manage.c has this in it:

#ifdef CONFIG_IRQ_FORCED_THREADING
__read_mostly bool force_irqthreads;

static int __init setup_forced_irqthreads(char *arg)
{
        force_irqthreads = true;
        return 0;
}
early_param("threadirqs", setup_forced_irqthreads);
#endif

but the references to that variable in irq_thread() and
irq_setup_forced_threading() and elsewhere don't seem to
be similarly guarded.  This can lead to a compile error if
IRQ_FORCED_THREADING isn't in the .config.  Is this actually
being forced on all archs now?  If so, the ifdef/endif is
probably superfluous.  If not, what happens on archs that
don't force it?

(I tried to  build-test it for myself and see, but apparently X86
selects the symbol and I haven't managed to figure out how to
get a compile that doesn't define it. Kbuild kept re-running config
and re-setting it.  'make ARCH=something allnoconfig' for some
value of something that doesn't do it?)


--==_Exmh_1353035774_61307P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUKWv/gdmEQWDXROgAQKcDw/+M/MgGTmMHPs8xlBJGtfk2LsvtqWP3z5j
PA+u97qSnzCZjprgwT8iSbge1v3koKN9RzjDN/dlAQTlz/p86PLNQo0kFb0tFgrS
LxQuWzgR6Z3VFAO6mA65dkMRy4ATjjCM8I6NE4oxZrc+OxgIGGOhMTjsMUWX03aY
+Bb4r74tbbAhhT374hVDbFWXgXDJdefP79CgVgfUEivIUXt3CvWvDW50oSpA5E9h
FuktQSzGyIPEL1mlEI8AQjm4pGyK1v84c774Or1fZ7UAkV7ACEnwC1KZwLmeo97V
0bFsXeucCecDirt7KpNnf4giCV23cH2TzFUCjXbznbKsZQ5UIIIctJ0zOQqJZk8L
JVAC0Js35ilFTqK9/2yeOaJeIb2bzb6BXzKR2lkUsJ1S9DHQpFFziomvgpQ7u6t+
/iDUL3MO56da6V6/UOzlBydMz1c4Wd6B7OexArWNeA5CLg5R2uWpGu+Nzl8fpS8R
3de9twoGTs7etrzRYfI7Z3dX2sCCvh+w9KG7RNAZkGB5QYYwz3N/RMVCRn2IecEI
bkuI8GDnABi7jP3iIvwCHKF/JOe7d70HjgjwTqh0FRnV4WKGt6Lgypr+ZOADGh25
e1s8IyEh37KBgGp7xqo/NXNAq8pu2oV5KIsskkcBb8s2onYNF9nQwfPJDaB50T2r
mukUXrdzhNg=
=aUNl
-----END PGP SIGNATURE-----

--==_Exmh_1353035774_61307P--

