Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759838Ab2DKADn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 20:03:43 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:47981 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab2DKADm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 20:03:42 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.4-dev
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
In-Reply-To: Your message of "Mon, 09 Apr 2012 15:10:27 -0700."
             <20120409151027.7f3e0fa5.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20120215143606.GA14037@redhat.com> <20120215160652.GA17680@redhat.com> <20120215162752.GF4533@moon>
            <20120409151027.7f3e0fa5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1334102329_1904P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 10 Apr 2012 19:58:49 -0400
Message-ID: <7939.1334102329@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4F84C93D.005D,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1334102329_1904P
Content-Type: text/plain; charset=us-ascii

On Mon, 09 Apr 2012 15:10:27 -0700, Andrew Morton said:
> Back on to kcmp.

I've totally forgotten what my original comment(s) on this patch were.. :)

> +/*
> + * 0 - equal, i.e. v1 = v2
> + * 1 - less than, i.e. v1 < v2
> + * 2 - greater than, i.e. v1 > v2
> + * 3 - not equal but ordering unavailable (reserved for future)
> + */
> +static int kcmp_ptr(void *v1, void *v2, enum kcmp_type type)
> +{
> +	long ret;
> +
> +	ret = kptr_obfuscate((long)v1, type) - kptr_obfuscate((long)v2, type);

I'm not able to convince myself that "less than" and "greater than" mean
anything - do we have a good proof that for all v1 and v2, the obfuscated
pointers have the same ordering as the original pointers?

Hmm... consider the simplified example  v1 = 5 and v2= 16., and cookies[0] is
also 16. Then obfus(v1) == 21, and obfus(v2) == 0, and the ordering is
different.  So I'm thinking 0 and 3 are the only sane return values?

Or do I need more caffeine?


--==_Exmh_1334102329_1904P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT4TJOQdmEQWDXROgAQIc7w/+PASGPEgIOqBEANcsjAoVrTdpj31NSLIn
+pP0O4T/NDGZpW+zht8Iz5dDfw8wBPiB1G3EqAaTrtbvnCOFmSCpVkgRbxQc/c37
qidDM0xJ0Es1nGGqH4RvWCeSGwkN7WgAX2lcbVwykVDkHZRLlAEQCMRPCikyK0E6
4MUIIsK5YvRVkZeOsZWG4joeeRgfh1VdS5yrzgVDwSbHiy+JbGnxLtAB9yWBrA1l
zQTsj/J2HhhdYj0qw37yQkKsPNBpTMCQkyAy5KVFXgOK9vMBO/FcPvNU93Xve+0t
1UnrazAOSxNLIao7oexuvEM/4Jn5O47FVqe82iRVVDWsHE6/E2mtxQXMlTdcRwXa
Ylpj8aK8KoQXR8yGn//7dF90k9W/21QeW3w66YIM6M/09X80yz+rzzKXuQuylPBH
tB034jXw7c31ENdV8a15Dqrd0L0/yVooQONTPhDJZY3u/+7kKP6/wEao2PFBArtz
vZe0N+96+EFamjAfFDwyuaQ+/IGPk1ohsJO6gyo+DzsTe0Br1TDiG6NKgAShvGh9
DVm1cgnvYC0VIE3eJjrhG9tiZRhLxarRgrI0+gz2oTq2VuIjtKrmVvQNj0821sr0
5bo1N03HYcht7xiZZPRVjrjH6YkqeKRif97LuKxAjd17Nq8xTYDPV6mOIGdZ3yHU
VHylWiAlQsQ=
=T6Qv
-----END PGP SIGNATURE-----

--==_Exmh_1334102329_1904P--

