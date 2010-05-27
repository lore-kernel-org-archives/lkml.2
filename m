Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424Ab0E0Rva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:51:30 -0400
Received: from claw.goop.org ([74.207.240.146]:37785 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759369Ab0E0Rv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:51:27 -0400
Message-ID: <4BFEB11D.9080805@goop.org>
Date: Thu, 27 May 2010 10:51:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Ian Jackson <Ian.Jackson@eu.citrix.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH 11/11] Unplug emulated disks and nics
References: <alpine.DEB.2.00.1005241615300.25605@kaball-desktop>	<1274725657-1149-11-git-send-email-stefano.stabellini@eu.citrix.com>	<4BFC3390.4060503@goop.org>	<alpine.DEB.2.00.1005261325110.25605@kaball-desktop>	<4BFD8BB0.90301@goop.org>	<m2n.s.1OHcBK-0018DA@chiark.greenend.org.uk> <19454.34430.471499.222290@mariner.uk.xensource.com>
In-Reply-To: <19454.34430.471499.222290@mariner.uk.xensource.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2010 07:49 AM, Ian Jackson wrote:
> Stefano Stabellini writes ("[Xen-devel] Re: [PATCH 11/11] Unplug emulated disks and nics"):
>   
>> On Wed, 26 May 2010, Jeremy Fitzhardinge wrote:
>>     
>>> Wow, this interface is perverse.  It reuses the same IO port but changes
>>> function depending on the size of the IO?  Again, wow.
>>>       
>>  
>> Yeah, before you ask, I didn't write it :)
>>     
> Yes, neither did I :-).  However, I did document it and now I also
> maintain the "product number" registry.  Did you find the interface
> spec ?  Enclosed below in case not.
>   

Thanks.  We should probably start a Documentation/xen/ and put this in
there as part of the patch.

> I hereby allocate you ("pvops PV-on-HVM Linux, upstream") product
> number 3.  Does the kernel have a way to distinguish between upstream
> and other versions ?  Eg, there's the kernel version name suffix
> thingy if I remember rightly.  Perhaps we should allocate a different
> number for "some pvops pv-on-hvm Linux with a nonempty kernel version
> name suffix".  Please advise.
>
> You are welcome to use whatever you like for the "build number".
> Perhaps the best thing would a two-byte encoding of the kernel version
> number if that is possible.  As the purpose is logging and
> blacklisting, it's not that critical although it's better to reuse the
> same number for excessively similar builds than to use a random scheme
> which might generate accidental clashes between unrelated versions.
>   

We could include 2 bytes of the HEAD changeset or something, with some
risk of collision.  Or just choose a constant and stick with it until
some interesting qualitative driver change makes it worthwhile bumping
the version.

I guess I can see some value in this info for recording in a log to do
some diagnostics, but the whole blacklist concept seems highly dubious
to me.  Some kind of feature negotiation makes a lot more sense to me...

    J
