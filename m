Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab1CFQDp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 11:03:45 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:44770 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab1CFQDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 11:03:44 -0500
Date: Sun, 6 Mar 2011 17:03:28 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Glauber Costa <glommer@redhat.com>, Avi Kivity <avi@redhat.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
	boot
Message-ID: <20110306160328.GA29429@nik-comp.lan>
References: <20110303220155.GB27691@nik-comp.lan> <4D7101AF.6060009@redhat.com> <20110304182733.GA2867@nik-comp.lan> <1299265762.11618.140.camel@mothafucka.localdomain> <20110304205512.GB2867@nik-comp.lan> <1299274906.11618.157.camel@mothafucka.localdomain> <20110304223640.GC2867@nik-comp.lan> <4D718F2D.6080105@redhat.com> <20110305072115.GA2166@nik-comp.lan> <4D739FEF.7000502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D739FEF.7000502@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4781649 records (last update: 20110306)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I did read your mail, but I was working on an old tree... because of  
> that transformation, this fix will unfortunately have to be back and  
> forward ported by hand.
OK, sorry, I didn't mean to be adverse...
>

> Did you try just that change right applied on top of the patch  
> (e48672fa25e879f7ae21785c7efd187738139593) implicated by bisect?
yes, with host running e48672fa25e879f7ae21785c7efd187738139593,
32bit SMP guest doesn't boot, when I add kvm_request_guest_time_update(vcpu),
it helps.

>
> It will be great to know if that change alone fixes the problem, if so,  
> the fix you propose is probably the right one for upstream.
ok, so shell I submit patch adding kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu)?
this fixes things for me for 2.6.37.

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
