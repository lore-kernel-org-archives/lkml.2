Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937073Ab0COXAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 19:00:19 -0400
Received: from claw.goop.org ([74.207.240.146]:49609 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932386Ab0COXAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 19:00:14 -0400
Message-ID: <4B9EBBEE.9020107@goop.org>
Date: Mon, 15 Mar 2010 15:59:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Sheng Yang <sheng@linux.intel.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH][v9 4/6] xen/hvm: Xen PV extension of HVM
 initialization
References: <1268362647-5317-1-git-send-email-sheng@linux.intel.com> <1268362647-5317-5-git-send-email-sheng@linux.intel.com> <4B9AA5A9.20609@goop.org> <201003150945.09548.sheng@linux.intel.com> <alpine.DEB.2.00.1003151108151.27222@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1003151108151.27222@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2010 05:04 AM, Stefano Stabellini wrote:
>> But we should make sure Xen have ability to support such kind of operation.
>> The CPUID would show if Xen have such ability, and if it does, the feature
>> would be enabled unconditionally. Guest kernel always enable all features it
>> can do unconditionally, but Xen should offer the support for them.
>>
>>      
> In my opinion once the guest knows that is running on Xen HVM (that is
> from xen_cpuid_base() or xen_para_available()) it should assume
> that the pv clocksource is available, therefore XEN_HVM_PV_CLOCK_ENABLED
> should not be needed.
> In other words the mere presence of Xen should imply
> XEN_HVM_PV_CLOCK_ENABLED.
>    

The only reason why we wouldn't want to do this is if we want to 
withdraw this feature at some point in the future.  We're stuck with it 
indefinitely for PV, but I don't know if that's necessarily going to be 
the case for HVM.  On the other hand, if other - better - mechanisms 
become available, we can give them their own clocksource driver with a 
higher priority than the Xen pvclock one, and users can still select 
clocksources on the kernel command line.

> Do you mean write generic code now, then introduce the 64 bit
> limitation later? Or the other way around?
> I don't have a strong opinion here so I am OK with both approaches, but
> I would prefer to add the limitation later (maybe we'll be able to make
> it work on 32 bit too...).
>    

Seems like making it work for both 32 and 64-bit is the easiest thing to do.

     J
