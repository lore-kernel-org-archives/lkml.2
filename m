Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760268Ab1CDVl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:41:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760219Ab1CDVl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:41:58 -0500
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
 boot
From: Glauber Costa <glommer@redhat.com>
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20110304205512.GB2867@nik-comp.lan>
References: <20110228171550.GA2173@nik-comp.lan> <4D6EF536.305@redhat.com>
	 <20110303070652.GG29840@pcnci.linuxbox.cz> <4D6FFE5D.1030401@redhat.com>
	 <20110303210647.GA27691@nik-comp.lan> <4D700F09.9000002@redhat.com>
	 <20110303220155.GB27691@nik-comp.lan> <4D7101AF.6060009@redhat.com>
	 <20110304182733.GA2867@nik-comp.lan>
	 <1299265762.11618.140.camel@mothafucka.localdomain>
	 <20110304205512.GB2867@nik-comp.lan>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Fri, 04 Mar 2011 18:41:46 -0300
Message-ID: <1299274906.11618.157.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-04 at 21:55 +0100, Nikola Ciprich wrote:
> > Zach,
> > 
> > I don't understand 100 % the logic behind all your tsc changes.
> > But kvm-clock-wise, most of the problems we had in the past were related
> > to the difference in resolution between the tsc and the host clocksource
> > (hpet, acpi_pm, etc), which in his case, it is a non-issue.
> > 
> > It does seem to me like some compensation logic kicked in, dismantling
> > an otherwise good tsc. He does have nonstop_tsc, which means it can't
> > get any better.
> > 
> > One thing I noticed when reading the culprit patch in bisect, is that in
> > vcpu_load(), there were previously a call to  
> > 
> >  kvm_request_guest_time_update(vcpu)
> > 
> > that was removed without a counterpart addition. Any idea about why it
> > was done?
> > 
> > Nikola, does adding that line back alleviate the problem for you ?
> Hello Glauber,
> kvm_request_guest_time_update seems to have been renamed and then
> removed since then, but I've added 
> kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
> instead and now the guest boots!
> So maybe missing clock update is really the culprit here?
> What do You guys think?
> n.

I think although the long term plan is to just do this update once in
your case (stable tsc), this update is needed. 

Why don't you send a patch to re-include it ?

