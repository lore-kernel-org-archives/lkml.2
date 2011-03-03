Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1CCHI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 02:08:57 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:53842 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab1CCHI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 02:08:56 -0500
Date: Thu, 3 Mar 2011 08:06:52 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
	boot
Message-ID: <20110303070652.GG29840@pcnci.linuxbox.cz>
References: <20110225104823.GD29840@pcnci.linuxbox.cz> <4D67C077.6060108@redhat.com> <20110227172052.GB2474@nik-comp.lan> <4D6BA85B.7080908@redhat.com> <20110228143247.GE29840@pcnci.linuxbox.cz> <4D6BBC84.6020408@redhat.com> <20110228152823.GF29840@pcnci.linuxbox.cz> <4D6BC5CA.8060004@redhat.com> <20110228171550.GA2173@nik-comp.lan> <4D6EF536.305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6EF536.305@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4703390 records (last update: 20110302)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No worries.  What mess?
twice sending the same mail, nevermind :)

>
> I have two things you can try:
>
> first is running a single VCPU guest, if you have not done so already.
yup, UP guest is fine, just SMP doesn't work.

> Second is adding the bootparameter "clocksource=acpi_pm" to your guest  
> kernel.
yes, this makes SMP work too! I just realized when You were asking about current
clocksource, I told You only host source, not the guest. So I checked now,
and (at least for UP, I guess for SMP it's the same), the clocksource is
kvm-clock! So seems like it got broken with the TSC changes?


>
> If either of those fixes the problem, it very well have to do with this  
> change and not that you may be missing later dependent patches.  This  
> change should be nearly a 1-1 transformation, and if it is not,  
> something is wrong.
>
> What branch are you bisecting on, the kvm branch or the kernel tree  
> itself?  It would be helpful to see the exact code in case any  
> surrouding logic changed.
I was bisecting linus' linux-2.6.git main branch, between 2.6.36..2.6.37

>
> Thanks,
>
> Zach
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
