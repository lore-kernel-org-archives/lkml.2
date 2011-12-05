Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab1LEVAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:00:37 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:54289 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431Ab1LEVAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:00:36 -0500
Subject: Re: [PATCH 1/2] ima: split ima_add_digest_entry() function
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmorris@namei.org
Date: Mon, 05 Dec 2011 15:57:08 -0500
In-Reply-To: <4EDCCD7D.7010406@polito.it>
References: <1321438229-18925-1-git-send-email-roberto.sassu@polito.it>
	 <1321450690.1901.24.camel@falcor> <4EC3CA9A.3070401@polito.it>
	 <4EC40682.2050602@linux.vnet.ibm.com> <4EC4E89F.2060608@polito.it>
	 <1321564518.21708.63.camel@falcor> <4EC63302.4040006@polito.it>
	 <1321637471.2158.44.camel@falcor> <4ECA6595.7010406@polito.it>
	 <1323041763.2061.22.camel@falcor> <4EDC9726.1040801@polito.it>
	 <1323090236.2061.63.camel@falcor> <4EDCCD7D.7010406@polito.it>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323118629.2061.117.camel@falcor>
Mime-Version: 1.0
x-cbid: 11120520-5518-0000-0000-000000D182F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 14:56 +0100, Roberto Sassu wrote:
> On 12/05/2011 02:03 PM, Mimi Zohar wrote:
> > On Mon, 2011-12-05 at 11:04 +0100, Roberto Sassu wrote:
> >
> >> Hi Mimi
> >>
> >> i think moving this logic to the TPM driver (or in general, delaying
> >> the action after the list mutex is unlocked) is not safe, because in
> >> this way you are relying on the kernel trustworthiness to protect
> >> itself and IMA against unmeasured potential attacks. So, the verifier
> >> is unable to detect a kernel tampering that removed the limitation
> >> on the TPM Quote operation.
> >>
> >> What i'm proposing in the patch:
> >>
> >> https://lkml.org/lkml/2011/11/21/202
> >>
> >> is in fact a new extension, which is triggered by a new kernel
> >> parameter, so that the behaviour of the base IMA is not modified.
> >
> > How/why the TPM fails is important.  If the TPM fails because of an
> > intermittent problem, then your solution of denying read/execute could
> > work, but what would happen if it was persistent?  Would you be able to
> > quiesce the system?
> >
> > As there is no way of differentiating a persistent from intermittent
> > failure, both need to be addressed in the same manor.  For persistent
> > TPM failure, we can not access the TPM to modify the PCR.  So what
> > options do we have left?  My suggestion, though not optimal, prevents
> > the IMA PCR from being quoted.
> >
> 
> Hi Mimi
> 
> the solution you are proposing is reasonable as the default
> behaviour, because not all IMA users need the high confidence
> in the measurements, as ensured by denying the execution of
> system calls.
> 
> However, during the IMA initialization the TPM is tested
> by issuing a PCR read (the test procedure may be extended
> to better detect existing errors in advance). So, this means
> that a TPM failure when the system is already powered on is
> very unlikely and may cause serious issues as it could happen
> if other devices are involved.
> 
> For this reason, also my extension seems helpful especially
> in the situations where all events need to be measured properly.
> In this case, IMA users are aware that a TPM failure could hang
> their systems, because they need to manually insert the required
> kernel parameter.

As you said a TPM failure is very unlikely, what type of attack are you
trying to defend against, that could possibly warrant causing the system
to hang?

Mimi

