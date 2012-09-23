Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab2IWRMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 13:12:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58274 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab2IWRMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 13:12:45 -0400
Date: Sun, 23 Sep 2012 19:12:36 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Antony Pavlov <antonynpavlov@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: Re: [PATCH v2 0/3] MIPS: JZ4740: Move PWM driver to PWM framework
Message-ID: <20120923171236.GA1219@avionic-0098.mockup.avionic-design.de>
References: <1347278719-15276-1-git-send-email-thierry.reding@avionic-design.de>
 <20120922074144.GC2538@avionic-0098.mockup.avionic-design.de>
 <20120923135635.GB13842@linux-mips.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <20120923135635.GB13842@linux-mips.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:42eL0QZmasXQEOhS5q0hpnw0br6uR+qnrEBPslPeZ7w
 8OZ6xSzhXOzNo+pEbTs7ivT0iwqdzxsTD1TJknfeHNI0A0bXaH
 KWuxMTGELzZREWlIqnIx2gwB8+Ll9QUfxvuSI6hS8N+0dh/a2t
 RDkQpJviOCn+1OuHeNWrTL4ebCrkYKngcWYlX/m4ZEvKTQ8n/0
 XLDHjzQ9xmWNYNvLTgV9AFoZE2p+K5hlyVKFV0CSlfiUH0ldtR
 zYcV2ib1tf9eNDEyhrryikMwPO0WUBSveij/cNipxYwT3Jf0PJ
 069ViGH6OXZmd7GrRplxwydE+RX2BjJsb1Lm0nABKKZABEIq1z
 vKftzDZ85dZyIGTn78WpjwejTt3y7arQmzk9gQ29xzO18jlSsT
 7LggpzAbXOU0MMlrZj9s5byZbCmJAd84sI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 23, 2012 at 03:56:35PM +0200, Ralf Baechle wrote:
> On Sat, Sep 22, 2012 at 09:41:45AM +0200, Thierry Reding wrote:
>=20
> > Have you had a chance to look at this? It is the last remaining PWM
> > driver that isn't moved to the PWM framework yet. All the others are
> > either in linux-next already and queued for 3.7 or have recently got
> > Acked-by the respective maintainers (Unicore32). Patches 2 and 3 were
> > already acked and tested by Lars-Peter who did the initial porting.
> > Patch 1 can probably be dropped since I seem to be the only one running
> > into that issue.
> >=20
> > I really want to take this in for 3.7 so I can use the 3.7 cycle to
> > transition from the legacy API to the new API and possibly even get rid
> > of the legacy parts altogether. However I don't want to do this without
> > the Acked-by from the MIPS maintainer.
>=20
> Acked-by: Ralf Baechle <ralf@linux-mips.org>
>=20
> for 2/3 and 3/3.

Alright, thanks. I'll take those through the PWM tree.

> I now can reproduce the build error that 1/3 is supposed to fix.  The iss=
ue
> is not as first suspected an odd bug in just your compiler.  The tree
> (I was testing on today's -next) is building fine when compiling in-tree
> but fails out of tree:

Okay, that makes sense. I rarely if even build in-tree nowadays.

>   CC      arch/mips/jz4740/irq.o
> In file included from /home/ralf/src/linux/linux-jz4740/arch/mips/include=
/asm/irq.h:18:0,
>                  from /home/ralf/src/linux/linux-jz4740/include/linux/irq=
=2Eh:27,
>                  from /home/ralf/src/linux/linux-jz4740/include/asm-gener=
ic/hardirq.h:12,
>                  from /home/ralf/src/linux/linux-jz4740/arch/mips/include=
/asm/hardirq.h:16,
>                  from /home/ralf/src/linux/linux-jz4740/include/linux/har=
dirq.h:7,
>                  from /home/ralf/src/linux/linux-jz4740/include/linux/int=
errupt.h:12,
>                  from /home/ralf/src/linux/linux-jz4740/arch/mips/jz4740/=
irq.c:19:
> /home/ralf/src/linux/linux-jz4740/arch/mips/jz4740/irq.h:20:39: error: =
=E2=80=98struct irq_data=E2=80=99 declared inside parameter list [-Werror]
> /home/ralf/src/linux/linux-jz4740/arch/mips/jz4740/irq.h:20:39: error: it=
s scope is only this definition or declaration, which is probably not what =
you want [-Werror]
> /home/ralf/src/linux/linux-jz4740/arch/mips/jz4740/irq.h:21:38: error: =
=E2=80=98struct irq_data=E2=80=99 declared inside parameter list [-Werror]
> In file included from /home/ralf/src/linux/linux-jz4740/include/linux/irq=
=2Eh:356:0,
>                  from /home/ralf/src/linux/linux-jz4740/include/asm-gener=
ic/hardirq.h:12,
>                  from /home/ralf/src/linux/linux-jz4740/arch/mips/include=
/asm/hardirq.h:16,
>                  from /home/ralf/src/linux/linux-jz4740/include/linux/har=
dirq.h:7,
>                  from /home/ralf/src/linux/linux-jz4740/include/linux/int=
errupt.h:12,
>                  from /home/ralf/src/linux/linux-jz4740/arch/mips/jz4740/=
irq.c:19:
> /home/ralf/src/linux/linux-jz4740/include/linux/irqdesc.h:73:33: error: =
=E2=80=98NR_IRQS=E2=80=99 undeclared here (not in a function)
> /home/ralf/src/linux/linux-jz4740/arch/mips/jz4740/irq.c: In function =E2=
=80=98jz4740_cascade=E2=80=99:
> /home/ralf/src/linux/linux-jz4740/arch/mips/jz4740/irq.c:49:39: error: =
=E2=80=98JZ4740_IRQ_BASE=E2=80=99 undeclared (first use in this function)
> /home/ralf/src/linux/linux-jz4740/arch/mips/jz4740/irq.c:49:39: note: eac=
h undeclared identifier is reported only once for each function it appears =
in
> /home/ralf/src/linux/linux-jz4740/arch/mips/jz4740/irq.c: At top level:
> /home/ralf/src/linux/linux-jz4740/arch/mips/jz4740/irq.c:62:6: error: con=
flicting types for =E2=80=98jz4740_irq_suspend=E2=80=99
> In file included from /home/ralf/src/linux/linux-jz4740/arch/mips/include=
/asm/irq.h:18:0,
>                  from /home/ralf/src/linux/linux-jz4740/include/linux/irq=
=2Eh:27,
>                  from /home/ralf/src/linux/linux-jz4740/include/asm-gener=
ic/hardirq.h:12,
>                  from /home/ralf/src/linux/linux-jz4740/arch/mips/include=
/asm/hardirq.h:16,
>                  from /home/ralf/src/linux/linux-jz4740/include/linux/har=
dirq.h:7,
>                  from /home/ralf/src/linux/linux-jz4740/include/linux/int=
errupt.h:12,
>                  from /home/ralf/src/linux/linux-jz4740/arch/mips/jz4740/=
irq.c:19:
> /home/ralf/src/linux/linux-jz4740/arch/mips/jz4740/irq.h:20:13: note: pre=
vious declaration of =E2=80=98jz4740_irq_suspend=E2=80=99 was here
> /home/ralf/src/linux/linux-jz4740/arch/mips/jz4740/irq.c:68:6: error: con=
flicting types for =E2=80=98jz4740_irq_resume=E2=80=99
> In file included from /home/ralf/src/linux/linux-jz4740/arch/mips/include=
/asm/irq.h:18:0,
>                  from /home/ralf/src/linux/linux-jz4740/include/linux/irq=
=2Eh:27,
>                  from /home/ralf/src/linux/linux-jz4740/include/asm-gener=
ic/hardirq.h:12,
>                  from /home/ralf/src/linux/linux-jz4740/arch/mips/include=
/asm/hardirq.h:16,
>                  from /home/ralf/src/linux/linux-jz4740/include/linux/har=
dirq.h:7,
>                  from /home/ralf/src/linux/linux-jz4740/include/linux/int=
errupt.h:12,
>                  from /home/ralf/src/linux/linux-jz4740/arch/mips/jz4740/=
irq.c:19:
> /home/ralf/src/linux/linux-jz4740/arch/mips/jz4740/irq.h:21:13: note: pre=
vious declaration of =E2=80=98jz4740_irq_resume=E2=80=99 was here
> /home/ralf/src/linux/linux-jz4740/arch/mips/jz4740/irq.c: In function =E2=
=80=98arch_init_irq=E2=80=99:
> /home/ralf/src/linux/linux-jz4740/arch/mips/jz4740/irq.c:91:41: error: =
=E2=80=98JZ4740_IRQ_BASE=E2=80=99 undeclared (first use in this function)
>=20
> Which (while your patch is probably fine, I haven't tested) this seems to
> be a build system issue, so should be preferably be fixed there.
>=20
> Marek, the whole email exchange is archived at
> http://www.linux-mips.org/archives/linux-mips/2012-09/threads.html

Okay. I think I mentioned in the commit message for patch 1 that the
include order seems to cause this. Maybe it's just a matter of
rearranging those.

Thierry

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQX0MEAAoJEN0jrNd/PrOh8QgP/085xg8zk4F13Gb9g4ur5lxY
WkQmcdPjpdVbKAGsZIlNdM0gnONQlqeTX0DgqmKX1uqQBQRtaVHRDHIz6PnwnN8s
NkBa1U63ffljEVfh4p05XXfTZUCRFUH2I24KTNZeirEIBwcsKictjALf0pJDLwtJ
jlkcOk/P869DxQeQuGLrqBqb+RWAlCyGYAj/ZG0jUMLsD74yo8MZqMbGxV/hROGM
ZfAB9TILAk9i46YAxrH+VdUxPcX+Piws01IcnV9jwcafg93gVA63XEua62oqLbw6
S8hwqNq5VLwjSMLqYrUTmXtCRFhxClMLpyAZ6YuT6IAsFApTLhQWG2LfDEQ6Tlmn
VBS35MWiV3QaIY30ze0JrCbJE0WaSu9TtoUrYN4AMR7syK7LTfaA99F78nXKiRaw
pup6zSD1rpT76zSPBfqyLGrzDS9Ma0RTO2xsgID7l0T6F1P2yiApOdE8/iHQEARD
dhUvebODim2iAaaJaEVwm+fFErhHLTDqoeEVxUCnkDv4fghvhkhGHblrXG0vxcoV
xXYrDB4F5QFv00+5fx2BtA/UFCvrapFwvaxwAewgqD4fqDNfW9089AV5Yu7QgVii
eljnNr3WQtj/Fac/DijBmhKpLCKjOoIjy5R4UsD5yTMjsLrUKmYW5AlAmay6JiWA
hnyERLjdjWyRtznTwR1D
=urqc
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
