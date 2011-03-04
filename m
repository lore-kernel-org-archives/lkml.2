Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab1CDUz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 15:55:28 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:36162 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437Ab1CDUz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 15:55:27 -0500
Date: Fri, 4 Mar 2011 21:55:12 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Glauber Costa <glommer@redhat.com>
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
	boot
Message-ID: <20110304205512.GB2867@nik-comp.lan>
References: <20110228171550.GA2173@nik-comp.lan> <4D6EF536.305@redhat.com> <20110303070652.GG29840@pcnci.linuxbox.cz> <4D6FFE5D.1030401@redhat.com> <20110303210647.GA27691@nik-comp.lan> <4D700F09.9000002@redhat.com> <20110303220155.GB27691@nik-comp.lan> <4D7101AF.6060009@redhat.com> <20110304182733.GA2867@nik-comp.lan> <1299265762.11618.140.camel@mothafucka.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299265762.11618.140.camel@mothafucka.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4719961 records (last update: 20110304)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Zach,
> 
> I don't understand 100 % the logic behind all your tsc changes.
> But kvm-clock-wise, most of the problems we had in the past were related
> to the difference in resolution between the tsc and the host clocksource
> (hpet, acpi_pm, etc), which in his case, it is a non-issue.
> 
> It does seem to me like some compensation logic kicked in, dismantling
> an otherwise good tsc. He does have nonstop_tsc, which means it can't
> get any better.
> 
> One thing I noticed when reading the culprit patch in bisect, is that in
> vcpu_load(), there were previously a call to  
> 
>  kvm_request_guest_time_update(vcpu)
> 
> that was removed without a counterpart addition. Any idea about why it
> was done?
> 
> Nikola, does adding that line back alleviate the problem for you ?
Hello Glauber,
kvm_request_guest_time_update seems to have been renamed and then
removed since then, but I've added 
kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
instead and now the guest boots!
So maybe missing clock update is really the culprit here?
What do You guys think?
n.



> 
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
