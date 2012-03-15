Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965423Ab2COToz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:44:55 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:40088 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965399Ab2COTox convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:44:53 -0400
MIME-Version: 1.0
Message-ID: <accb8b79-4642-4ab0-9e8e-27db775675ad@default>
Date: Thu, 15 Mar 2012 12:44:40 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Akshay Karle <akshay.a.karle@gmail.com>,
        Konrad Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ashu tripathi <er.ashutripathi@gmail.com>,
        nishant gulhane <nishant.s.gulhane@gmail.com>,
        Shreyas Mahure <shreyas.mahure@gmail.com>,
        amarmore2006 <amarmore2006@gmail.com>,
        mahesh mohan <mahesh6490@gmail.com>
Subject: RE: [RFC 1/2] kvm: host-side changes for tmem on KVM
References: <1331225648.2585.27.camel@aks>
 <20120315165400.GL30250@phenom.dumpdata.com> <1331836868.2215.43.camel@aks>
In-Reply-To: <1331836868.2215.43.camel@aks>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4F6246B4.007F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Akshay Karle [mailto:akshay.a.karle@gmail.com]
> Subject: Re: [RFC 1/2] kvm: host-side changes for tmem on KVM
> 
> >> Working at host:
> >> Once the guest exits to the kvm host, the host determines that the guest exited
> >> to perform some tmem operation(done at kvm_emulate_hypercall)and then
> >> we use zcache to implement this required operations(performed by kvm_pv_tmem_op).
> >
> > Do you need any modifications to the Kconfig file to reflect the KVM dependency?
> 
> Yeah, the Kconfig of zcache now needs to be modified to reflect the KVM and the KVM_INTEL or
> KVM_AMD dependency. The Kconfig can also be modified to support tmem for the guest kernels,
> as the zcache code is not at all used in the guest, only the kvm-tmem, cleancache and
> frontswap(if present) code is used in the guest. But, in the host its necessary to enable zcache.
> So the Kconfig can be modified to have the following new field:
> "Transcendent memory support for kvm guests".... Which would compile just the kvm-tmem code.
> And we can add Cleancache and Frontswap as dependencies(similar to zcache).
> 
> But it should be made sure that the host kernel has zcache enabled..

If the host kernel does not have zcache enabled, it may return
the value for "unimplemented hypercall".  The kvm tmem code in
the guest should be prepared for that as it may even be running
on an older kvm host.
