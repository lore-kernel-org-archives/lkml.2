Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab2EINqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:46:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60605 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab2EINqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:46:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] mach-shmobile: Emma Mobile EV2 SMP prototype code
Date: Wed, 9 May 2012 13:45:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "olof@lixom.net" <olof@lixom.net>
References: <20120509075407.5991.60556.sendpatchset@w520> <201205091212.08239.arnd@arndb.de> <4FAA6DE6.3040001@arm.com>
In-Reply-To: <4FAA6DE6.3040001@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205091345.34404.arnd@arndb.de>
X-Provags-ID: V02:K0:hMJLafwHxGRINVF0rZ6x7UX3BJc7vUXEAqoB2wJNNnh
 a34iOhpzuSHUlcWMnzoJD5G+Dx7YiPfcl5nDbN6iTyLqGk2C0w
 yNOJjuJkDm3xTsiQT6x5vw7zDaI6FkfXJI8J0dwUbeSVDiAlTq
 +fUwC0t93c4iqlixtU5Xr6kGYwD/kz/oR579jo9CTUMI44zYot
 9nv9hiM1/0F5iGp+v8xXVevS7fzbG5iRYJRUMaLP/dm/ssLXA7
 UfAlwbb+IkgAr+cGrQvbvlQPidDzMajYI44++0HHINrc+TuL0o
 HhZOKO+gUdaSdN4aHSIHjmQ+Yp0LcKpkaXZz2V9C+W7vIRbcMH
 bku4HLeFI3T/XWy7fdY4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 May 2012, Marc Zyngier wrote:
> On 09/05/12 13:12, Arnd Bergmann wrote:
> > On Wednesday 09 May 2012, Magnus Damm wrote:
> >>  static unsigned int __init shmobile_smp_get_core_count(void)
> >>  {
> >> @@ -31,6 +32,9 @@ static unsigned int __init shmobile_smp_
> >>  	if (is_r8a7779())
> >>  		return r8a7779_get_core_count();
> >>  
> >> +	if (is_emev2())
> >> +		return emev2_get_core_count();
> >> +
> >>  	return 1;
> >>  }
> >>  
> >> @@ -41,6 +45,9 @@ static void __init shmobile_smp_prepare_
> >>  
> >>  	if (is_r8a7779())
> >>  		r8a7779_smp_prepare_cpus();
> >> +
> >> +	if (is_emev2())
> >> +		emev2_smp_prepare_cpus();
> >>  }
> >>  
> >>  int shmobile_platform_cpu_kill(unsigned int cpu)
> >> ...
> > 
> > This shows that we really want an abstraction for soc-specific SMP ops
> > even within one platform, and we'll need the same thing for multiplatform.
> > 
> > Marc Zyngier already proposed a solution for this last year, but I
> > think we couldn't agree on the details back then before he lost interest.
> > I think we should pick that up again and get it into 3.6 so the code above
> > can be simplified and we can do the multiplatform solution. We'll probably
> > discuss the details in Hong Kong in a couple of weeks, so there is no
> > point in changing it now, but I'd hope that you can migrate this to
> > whatever we come up with in the following merge window.
> 
> I'm happy to revive the series if there is an interest.

Ok, good. I think we were almost there the last time, but I don't
know if Russell still had any objections. Magnus, can you comment on
the "[PATCH v6 09/15] ARM: SoC: convert shmobile SMP to SoC descriptor"
patch from February to see if it fits your needs?

FWIW, I would actually prefer merging the 'struct arm_soc_desc', 'struct
arm_soc_smp_init_ops' and 'struct arm_soc_smp_ops' structures into a
single 'struct smp_ops' for simplicity. While that would no longer allow
us to put more stuff in there, I also don't see an urgent need to do so.
I also don't mind the code that we had in version 6.

	Arnd
