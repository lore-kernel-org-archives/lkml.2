Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab2FLPYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:24:08 -0400
Received: from nm23-vm1.bullet.mail.ne1.yahoo.com ([98.138.91.50]:47588 "HELO
	nm23-vm1.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751696Ab2FLPYG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:24:06 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jun 2012 11:24:06 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 410758.67146.bm@omp1060.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=zpbl4SF9zqg9qEahzBbGZXhXPYo9QyPps0Ysgqm2/LNiGlO0j5IyVHZW6I7Oi0zfOSW23ZjisSPCH5W5SrQu7avt0NjxxVK0Zd2ZW1Kz2znjRDgFiRMjbhaEjZ/qSMQOF/GtbS+B24Bvm9UEsv4ZtA+XJaz0ivxyTTfKQFa0Iwk=;
X-YMail-OSG: g9AmcZ8VM1mHMo4NN5XzkmsgaR_XXlkzgVmDdyC_rKzJsdo
 kIlpzfTeZfuDPI8rCjKCgqXEhiZi0nipNBv3AXLS.hBWjEkUqAd4i4g6zYyw
 .AwdhXWYdygwa52CVnKlPECaWURyOhnSm0RBtLNvhZaqlcn4dErY8SS7AX89
 W0euFa6OstiyVuUCRTjD2ssr1GoV8Rxv6.7pa4gEXyjpNIAkwCF8LkZ0HpT8
 oLVaIgjKu2S6VDn_soduidD7BNuJJs7L4ojse.LgETOO5vTGo4hJZW7IJgB9
 6g.T.j5cvaEZILRVrAKDHboRvEfVD0tpJ9cZTyDnUY1SbNBF.u.4X1pIrJi3
 D3PNpsaP9N0AYIrswYE9UnGK0HORE2HB2pX.m050sYUvGukHFUnRK89SHgCV
 Jl2lKiZt065OhWSsVNhY3t3dC.YTAxw9AqPCtIkN8unraPMKR.oN_sUiKxmD
 QIa4tEdvBdx3KKf3b4reIufDP7mXoOb.od3Lz0UBKhjPofXN4bdSELy4MRoo
 n9m0-
X-Mailer: YahooMailWebService/0.8.118.349524
References: <1339493860.10145.YahooMailNeo@web111708.mail.gq1.yahoo.com> <20120612103954.GB10124@x1.osrc.amd.com> <1339508890.39685.YahooMailNeo@web111705.mail.gq1.yahoo.com> <20120612135713.GA10128@x1.osrc.amd.com>
Message-ID: <1339514263.74306.YahooMailNeo@web111722.mail.gq1.yahoo.com>
Date: Tue, 12 Jun 2012 08:17:43 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: Re: CPU MTRRs and linux kernel
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
In-Reply-To: <20120612135713.GA10128@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>If it were me and I didn't have any particular reason to stick with
>2.6.32, I'd always go for the latest kernel
 
One thing is not clear for me. Did you make the following change in the latest version today? I want to know, should I wait until it is pushed in to ubuntu repository?

diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index c5f59d071425..ac140c7be396 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -827,7 +827,7 @@ int __init amd_special_default_mtrr(void)

        if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
                return 0;
-       if (boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x11)
+       if (boot_cpu_data.x86 < 0xf)
                return 0;
        /* In case some hypervisor doesn't pass SYSCFG through: */
        if (rdmsr_safe(MSR_K8_SYSCFG, &l, &h) < 0)



// Naderan *Mahmood;


----- Original Message -----
From: Borislav Petkov <bp@alien8.de>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>; Andreas Herrmann <andreas.herrmann3@amd.com>
Sent: Tuesday, June 12, 2012 6:27 PM
Subject: Re: CPU MTRRs and linux kernel

On Tue, Jun 12, 2012 at 06:48:10AM -0700, Mahmood Naderan wrote:
> Thanks Borislav, I want to know, should I upgrade to the latest kernel
> or it is possible to download the source of 2.6.32-24 from repository
> and modify cleanup.c and then recompile?

Whatever you decide.

If it were me and I didn't have any particular reason to stick with
2.6.32, I'd always go for the latest kernel.

In any case, no matter which kernel you're installing, just make sure it
contains the aforementioned patch which should fix your problem.

HTH.

-- 
Regards/Gruss,
Boris.
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

