Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab1GLQr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 12:47:57 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:24171 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753972Ab1GLQr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 12:47:56 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: AJpcxcYVM1kTcWmECv5g9zgGrTf81dQij0GlvwBzV0C8iSm
 ukQVPA5qBvBbojSjJrIMbMvnQ96d1qoEfviB103dtD2RYJGR0QcXDKfxCrsN
 WscTFg.E3blqCLSMLg3qVBzRrja2vHVywRAoKHDOuBOYyXpfgWR021U60Xz7
 w2Q4gIfmTUPpqa7MJFtRms.OIcbkQRa3MliVJ6BTew.Cdb2EzLiX_up8ZDRm
 J4Hhg_zVBrPPDaJndRwX1S.MZM3ZMK51_v3q00t7FC285WgxFZMlegQE._3r
 mYMz2s5WT0wMoCh8cq_sbtkAZDgiQBfadgoKFWRcze_p7HEMJ022s6n32psf
 kWqNg1IpgZ48eSh0CUkHD.j04
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 12 Jul 2011 11:47:53 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv7 06/17] slub: Add cmpxchg_double_slab()
In-Reply-To: <1310486781.2871.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1107121146080.3937@router.home>
References: <20110601172543.437240675@linux.com>  <20110601172615.286693377@linux.com>  <1310414100.2860.6.camel@edumazet-laptop>  <alpine.DEB.2.00.1107121057550.2931@router.home> <1310486781.2871.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-785980978-1310489274=:3937"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-785980978-1310489274=:3937
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 12 Jul 2011, Eric Dumazet wrote:

> Le mardi 12 juillet 2011 =C3=A0 10:59 -0500, Christoph Lameter a =C3=A9cr=
it :
>
> > We do not need to have _count included. This is just there because the
> > field is in the way on 64 bit and we can only do 2x 64 bit cmpxchges.  =
On
> > 32 bi we can drop _count from "counters".
> >
>
> OK, thanks for clarification.

Still I'd like to get some ideas on how to make the whole thing much
cleaner. Isnt there some way to convert a struct to an unsigned long
without going through a union? And a way to convert a struct + 32 bit
atomic_t into a 64 bit unsigned long? Would simplify things significantly.

---1463811839-785980978-1310489274=:3937--
