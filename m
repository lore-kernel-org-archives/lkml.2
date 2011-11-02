Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab1KBIxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 04:53:47 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:46264 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751325Ab1KBIxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 04:53:46 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: wlDd9vwVM1kNiCY8Zy4Fl5ZsZtb3JoD26NJ0pUWJFJUUpfJ
 hpvWnTxwFf8iv9Y_jlBgi3ovVRw.iO1Rxbw3Oq4cx56Rarws3Prph8rtptM6
 fKlGBkZvvWJeETfX5WcY7USBMi_rcJpDe5Vll6JMxkz6cv3JqWh6kOwZ_FLA
 JeHMn4oUPsarJtnCVT8V2mn3FNRgAXqGvsmHsOIoV.ZEHY.EKIKioLLl95lx
 V9mORI3WfHV2TiMWVevvyskjQT4kHsv6T87tZsfUUbxVmx97EPSbqsVs5dYV
 xCaRdqb_tMWlPRiSXEieCzCwwK.cf1VRO5AjAplcmnVgnfvcWp79dP4gEsnk
 mZX1BWUr4UHErMo_A7_eDE.VTd8P0fYWh255hOy9ZuW8ZN4VC9MBONtBpPdE
 pXSwUvHAzPpQfWbgjWC9OfPk-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 2 Nov 2011 03:53:42 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH v2 4/6] mm: Only IPI CPUs to drain local pages if they
 exist
In-Reply-To: <CAOtvUMd8Z_jbs__+cVG2+ZkPZLqGkJGym402RMRYGDDjT73bkg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1111020352210.23788@router.home>
References: <1319385413-29665-1-git-send-email-gilad@benyossef.com> <1319385413-29665-5-git-send-email-gilad@benyossef.com> <4EAAD351.70805@redhat.com> <CAOtvUMd8Z_jbs__+cVG2+ZkPZLqGkJGym402RMRYGDDjT73bkg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1496498453-1320224024=:23788"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-1496498453-1320224024=:23788
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 29 Oct 2011, Gilad Ben-Yossef wrote:

> >> +/* Which CPUs have per cpu pages =A0*/
> >> +cpumask_var_t cpus_with_pcp;
> >> +static DEFINE_PER_CPU(unsigned long, total_cpu_pcp_count);
> >
> > Does the flushing happen so frequently that it is worth keeping this
> > state on a per-cpu basis, or would it be better to check each CPU's
> > pcp info and assemble a cpumask at flush time like done in patch 5?
> >
>
> No, I don't  believe it is frequent at all. I will try to re-work the
> patch as suggested.

The draining of the pcp pages is done from the vmstat callback which
occurs every second. Only if there is something to clean in the caches
will the flush happen.


---1463811839-1496498453-1320224024=:23788--
