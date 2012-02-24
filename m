Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab2BXPnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:43:19 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:45124 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753982Ab2BXPnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:43:18 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Jou8u2AVM1l8w8.1jJJRZbkz3Br264Gv_dm3pB66LetQLin
 HC.fJpc6K8RLcTu4Ho.iphrnJjo6vZUkZtQgKIuisp6NDda39msV66HldSOp
 OKsJ76P04ej5aMANdr3I_sKj6g3uoQtM7KVEhdUr_7Ev5eoEMVOlY5fFsBIh
 fHh6_c9gyNICCda3p3JLcrfXXKm52yHyWH5ThAXTBxOPDGY3mL.UXkO622aY
 B2v7IQu5fLMWLiPYs6tzpwW6tV4ngI29k4y5.0Glo0.rJzIr3BBPenjmsUjF
 DRQnLXNXBL.A1VPoOc_OhGY1k5W1YZOjo_A0DPsRtHTnIKNrs4_FbFMWb5S7
 6PM8DY738_kJ9o_8UuMUZUG6CkCuyauZwAMIFACNDTlEAXc07_waMd6e6vQ1
 QqHnCR5zYUK_BqGQB5pkG1flFOYrCu5CQ3TJc
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 24 Feb 2012 09:43:15 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Torsten Kaiser <just.for.lkml@googlemail.com>
cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: fix generic definition of
 __this_cpu_add_and_return()
In-Reply-To: <CAPVoSvSimdFfkxSqtW3Gzf+J-sPPzVuyyUEf7Zxo4HLmBx9kxw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1202240942510.2621@router.home>
References: <20120219142911.12300.7497.stgit@zurg> <CAPVoSvSimdFfkxSqtW3Gzf+J-sPPzVuyyUEf7Zxo4HLmBx9kxw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1973586058-1330098196=:2621"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-1973586058-1330098196=:2621
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 24 Feb 2012, Torsten Kaiser wrote:

> > =A0#define __this_cpu_sub_return(pcp, val) =A0 =A0 =A0 =A0this_cpu_add_=
return(pcp, -(val))
>
> I think, the same fix should be applied to the lines following this patch=
:
> #define __this_cpu_sub_return(pcp, val) this_cpu_add_return(pcp, -(val))
> #define __this_cpu_inc_return(pcp)      this_cpu_add_return(pcp, 1)
> #define __this_cpu_dec_return(pcp)      this_cpu_add_return(pcp, -1)
>
> Shouldn't these other operations also only give the __ relaxed guarantees=
?
Yes indeed that should also be fixed.
---1463811839-1973586058-1330098196=:2621--
