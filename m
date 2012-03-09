Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab2CIRiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:38:54 -0500
Received: from service88.mimecast.com ([195.130.217.12]:41471 "EHLO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab2CIRix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:38:53 -0500
X-Greylist: delayed 82277 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Mar 2012 12:38:52 EST
Message-ID: <4F5A401E.3070008@arm.com>
Date: Fri, 9 Mar 2012 17:38:38 +0000
From: Richard Earnshaw <Richard.Earnshaw@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Dave Martin <dave.martin@linaro.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH-WIP 01/13] xen/arm: use r12 to pass the hypercall number
 to the hypervisor
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop> <1330019314-20865-1-git-send-email-stefano.stabellini@eu.citrix.com> <1330360043.8557.302.camel@zakaz.uk.xensource.com> <20120227180355.GB2023@linaro.org> <1330371219.10008.34.camel@dagon.hellion.org.uk> <20120228102040.GB2063@linaro.org> <1330426133.31269.70.camel@zakaz.uk.xensource.com> <alpine.DEB.2.00.1202281149210.23091@kaball-desktop> <20120229093436.GA2077@linaro.org> <1330509362.4270.20.camel@zakaz.uk.xensource.com> <20120229125826.GC2077@linaro.org> <alpine.LFD.2.02.1203021528150.31242@xanadu.home> <4F5882BF.1030104@arm.com> <alpine.LFD.2.02.1203081041340.24151@xanadu.home> <4F58FEC0.8080706@arm.com> <CA+wbFdfF5c+Bw6RrxCm3YThqCRDuDYzanq+HV8a6LyXaBqWrQA@mail.gmail.com> <alpine.LFD.2.02.1203091112050.24151@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1203091112050.24151@xanadu.home>
X-Enigmail-Version: 1.3.5
X-MC-Unique: 112030917384708002
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/12 16:20, Nicolas Pitre wrote:
> On Fri, 9 Mar 2012, Dave Martin wrote:
>
>> Register variables feel like a red herring though.  We're only using
>> those because we can't do the needful thing and actually desscribe
>> these constraints in the asm constraints (which would seem to be the
>> right place).  We specifically don't care where those values are
>> except at the boundaries of the asm block itself.
>
> Absolutely.
>
>> Is there a reason why ARM gcc doesn't provide the ability to specify
>> such exact-register constraints, or is this more for historical
>> reasons?  It is possible?
>
> I don't know how much things have changed since I last looked at the gcc
> code, but implementing this seemed to be pretty trivial at the time.
> The problem would be to determine a good letter scheme to map to actual
> registers.
>
>
> Nicolas
>

While it is technically possible, it is likely to end up hurting overall
compiler performance as we'll then have to define the machine as having
small register classes.

--
Richard Earnshaw             Email: Richard.Earnshaw@arm.com
Engineering Manager          Phone: +44 1223 400569 (Direct + VoiceMail)
OpenSource Tools             Switchboard: +44 1223 400400
ARM Ltd                      Fax: +44 1223 400410
110 Fulbourn Rd              Web: http://www.arm.com/
Cambridge, UK. CB1 9NJ

-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

