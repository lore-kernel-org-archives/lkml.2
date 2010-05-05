Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757Ab0EEHah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 03:30:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519Ab0EEHaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 03:30:35 -0400
Message-ID: <4BE11E8A.2090804@redhat.com>
Date: Wed, 05 May 2010 10:30:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Brian Gerst <brgerst@gmail.com>,
       "Cui, Dexuan" <dexuan.cui@intel.com>,
       Sheng Yang <sheng@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: eliminate TS_XSAVE
References: <1272812038-32484-1-git-send-email-avi@redhat.com>	 <1272812038-32484-2-git-send-email-avi@redhat.com>	 <u2p73c1f2161005021038gce35c1bbpca6ec119d24e646e@mail.gmail.com>	 <4BDDBA18.3080909@redhat.com> <4BDF4407.8000503@zytor.com>	 <4BDFCF9F.3030600@redhat.com> <1272996927.2833.13.camel@sbs-t61.sc.intel.com> <4BE06642.6080702@zytor.com>
In-Reply-To: <4BE06642.6080702@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2010 09:24 PM, H. Peter Anvin wrote:
>
> I would like to request one change, however.  I would like to see the
> alternatives code to be:
>
> 	movb $0,reg
> 	movb $1,reg
>
> ... instead of using xor (which has to be padded with NOPs, which is of
> course pointless since the slot is a fixed size.)

Right.

> I would suggest using
> a byte-sized variable instead of a dword-size variable to save a few
> bytes, too.
>    

I used a bool, and the code already compiles to a byte mov.  Though it 
could be argued that a word instruction is better since it avoids a 
false dependency, and allows a preceding instruction that modifies %reg 
to be executed after the mov instruction.

> Once the jump label framework is integrated and has matured, I think we
> should consider using it to save the mov/test/jump.
>    

IIRC that has an implied unlikely() which isn't suitable here?

Perhaps the immediate values patches.

-- 
error compiling committee.c: too many arguments to function

