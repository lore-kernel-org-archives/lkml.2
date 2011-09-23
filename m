Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751064Ab1IWRhD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 13:37:03 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57316 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab1IWRhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 13:37:00 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: frank.rowand@am.sony.com
Cc: tglx@linutronix.de, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] preempt-rt: allow immediate Magic SysRq output for PREEMPT_RT_FULL
In-Reply-To: Your message of "Thu, 22 Sep 2011 14:05:56 PDT."
             <4E7BA334.2050003@am.sony.com>
From: Valdis.Kletnieks@vt.edu
References: <4E7BA334.2050003@am.sony.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316799377_4577P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 23 Sep 2011 13:36:17 -0400
Message-ID: <7186.1316799377@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4E7CC393.007A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316799377_4577P
Content-Type: text/plain; charset=us-ascii

On Thu, 22 Sep 2011 14:05:56 PDT, Frank Rowand said:
> Change from V1 to V2:  add drivers/tty/serial/8250.c

>  drivers/tty/serial/cpm_uart/cpm_uart_core.c |    2 	1 +	1 -	0 !
>  drivers/tty/serial/mfd.c                    |    2 	1 +	1 -	0 !
>  drivers/tty/serial/nwpserial.c              |    2 	1 +	1 -	0 !
>  drivers/tty/serial/omap-serial.c            |    2 	1 +	1 -	0 !
>  drivers/tty/serial/sunhv.c                  |    4 	2 +	2 -	0 !
>  drivers/tty/serial/sunsab.c                 |    2 	1 +	1 -	0 !
>  drivers/tty/serial/sunsu.c                  |    2 	1 +	1 -	0 !
>  drivers/tty/serial/sunzilog.c               |    2 	1 +	1 -	0 !
>  drivers/tty/serial/uartlite.c               |    2 	1 +	1 -	0 !
>  drivers/tty/serial/xilinx_uartps.c          |    2 	1 +	1 -	0 !

>  	if (up->port.sysrq)
>  		locked = 0;
> -	else if (oops_in_progress) {
> +	else if (oops_in_progress || sysrq_in_progress) {
>  		locked = spin_trylock(&up->port.lock);
>  	} else
>  		spin_lock(&up->port.lock);

Is it time to create a helper function for this chunk of code that appears
in almost identical form in a dozen drivers?

--==_Exmh_1316799377_4577P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOfMORcC3lWbTT17ARAk7NAJ4wqIbhIfDMRACv1Orkhp6dZedVjwCbBJ9t
EiyvDJoaO2ICQ9s/u/IFZlw=
=ToPM
-----END PGP SIGNATURE-----

--==_Exmh_1316799377_4577P--

