Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab1ILXhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 19:37:21 -0400
Received: from claw.goop.org ([74.207.240.146]:34541 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559Ab1ILXhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 19:37:19 -0400
Message-ID: <4E6E97AC.8020707@goop.org>
Date: Mon, 12 Sep 2011 16:37:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [GIT PULL] Little bugfix to prevent recursion with tracing timestamps
References: <4E6E92AB.5050504@goop.org>
In-Reply-To: <4E6E92AB.5050504@goop.org>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

[ Sigh, for some reason that doesn't verify.  Let's see if this works.
  Anyway, I pushed a signed tag "upstream-bugfix-for-linus" on that
changeset. - J ]

Hi Linus,

When starting a PV kernel under Xen with full boot-time trace testing
enabled, it crashes due to infinite recursion.  In principle it could
happen at other times too (when just using preempt tracing perhaps?).
This fixes it.

BTW, I think this same problem also affects KVM.

Erm, I'm not sure how to authenticate this github as being really from
me; I'm signing the mail with my long-standing pgp key in the hope that
it helps...  Also, the patch is self-evident.

Thanks,
    J

The following changes since commit b6fd41e29dea9c6753b1843a77e50433e6123bcb:

  Linux 3.1-rc6 (2011-09-12 14:02:02 -0700)

are available in the git repository at:
  git://github.com/jsgf/linux-xen.git upstream/bugfix

Jeremy Fitzhardinge (1):
      xen: use non-tracing preempt in xen_clocksource_read()

 arch/x86/xen/time.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 5158c50..163b467 100644
- - --- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -168,9 +168,10 @@ cycle_t xen_clocksource_read(void)
         struct pvclock_vcpu_time_info *src;
     cycle_t ret;
 
- - -    src = &get_cpu_var(xen_vcpu)->time;
+    preempt_disable_notrace();
+    src = &__get_cpu_var(xen_vcpu)->time;
     ret = pvclock_clocksource_read(src);
- - -    put_cpu_var(xen_vcpu);
+    preempt_enable_notrace();
     return ret;
 }
 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEkBAEBCAAGBQJObpesAAoJEAUkni6MUg7HMnAIP0bR68/akTif/RVfis0Cot/a
ONlz5GsGGA7AlHfp/l/M8GZo5fUIC7Ja+EqTnpUWMNbubLoe5kALt5k/uQwADtoI
cyvi5j2tlXDGDZOgQ900pQQYMBFVwaCm5XwSuDTbysPUx4v7E5Ha/RL2xapbuFnP
txCyO62xx4EsKqkupM4qnTCBId6ksRNo9EVESxFzpJk/l0fabTLM98RigA1KJmdo
+Rr+1SzfNnNQLLXG48EHITthfYaBOw9jyGanbe5i9Iw79J85vjI5V65TMlDztWaN
kyUGiWD9f1i9ixCO31qhszdRire8c2N8hDTTN5z1919Gtlkq93Oj3F8zkUlbapyh
tD4e8GObdA==
=MA3l
-----END PGP SIGNATURE-----

