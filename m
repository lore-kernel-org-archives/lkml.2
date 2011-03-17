Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab1CQLlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 07:41:51 -0400
Received: from mail-tx2.bigfish.com ([65.55.88.10]:18044 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752910Ab1CQLlu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 07:41:50 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275dhz32i637h668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LI79TM-01-7YE-02
X-M-MSG: 
Date: Thu, 17 Mar 2011 12:41:40 +0100
From: Robert Richter <robert.richter@amd.com>
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Heinz Graalfs <graalfs@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] oprofile: Add __exit attibute to
 oprofile_arch_exit() functions
Message-ID: <20110317114140.GA31407@erda.amd.com>
References: <1300298305-9164-1-git-send-email-robert.richter@amd.com>
 <1300298305-9164-3-git-send-email-robert.richter@amd.com>
 <AANLkTi=g-Dd957gPxCUfRxVw52T2m6GbswapEAJLnBtP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <AANLkTi=g-Dd957gPxCUfRxVw52T2m6GbswapEAJLnBtP@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.03.11 16:15:49, Mike Frysinger wrote:
> On Wed, Mar 16, 2011 at 13:58, Robert Richter wrote:
> >  979048e oprofile: don't call arch exit code from init code on failure
> >
> > we may add __exit attibutes to oprofile_arch_exit() functions.
> 
> i dont think this the way to go.  how about updating one place
> (include/linux/oprofile.h:oprofile_arch_exit) and making sure all arch
> files are including that header if they arent already ?  after all, if
> they arent including that header, the arch code could break without
> noticing.

Mike,

do you mean we specify the __exit attribute in the function
declaration of the header file and make sure it is included
everythere? I was looking at current implementations in the kernel and
this is not common. Mostly the attributes are set in the function
definition. So I was not sure if that would work. If so, may we skip
then the __exit attribute in the definition?

GCC doc states: "The keyword __attribute__ allows you to specify
special attributes when making a declaration."

 http://gcc.gnu.org/onlinedocs/gcc-4.5.1/gcc/Function-Attributes.html#Function%20Attributes

but nothing about that happens if it is in the function definition and
this is different from the declaration.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

