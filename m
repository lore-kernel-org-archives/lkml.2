Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab0CUSwX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 14:52:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:40432 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab0CUSwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 14:52:19 -0400
Message-ID: <4BA66A7A.3070207@kernel.org>
Date: Sun, 21 Mar 2010 11:50:34 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <julia@diku.dk>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH] irq: Start the transition of irq_chip methods taking
 a desc
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org> <1267697339-5491-7-git-send-email-yinghai@kernel.org> <alpine.LFD.2.00.1003041142460.2014@localhost.localdomain> <4B900250.8020100@kernel.org> <Pine.LNX.4.64.1003050847170.21768@ask.diku.dk> <m1eije71et.fsf@fess.ebiederm.org> <Pine.LNX.4.64.1003211153470.7805@ask.diku.dk> <m1eijd3jl7.fsf_-_@fess.ebiederm.org> <alpine.LFD.2.00.1003211541120.3147@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003211541120.3147@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2010 07:43 AM, Thomas Gleixner wrote:
> Eric,
> 
> On Sun, 21 Mar 2010, Eric W. Biederman wrote:
>>
>> With SPARSE_IRQ irq_to_desc becomes an unnecessary lookup operation on
>> the fast path of dispatching irqs to their handlers.  We can avoid
>> this cost by passing an irq_desc pointer instead of using an integer
>> irq token to the irq_chip methods.
>>
>> A single patch to convert all of the architectures is an unreviewable
>> 2000+ line patch.  A gradual transition scenario with two sets of
>> irq_chip methods in irq_chip is an unmanageable mess in kernel/irq.
>>
>> So instead I define some macros so the generic irq code in kernel/irq/
>> can compile either way based on a boolean Kconfig variable
>> CONFIG_CHIP_PARAM_DESC.  This allows us to convert one architecture at
>> a time, reducing the follow on patches to manageable proportions.  It
>> is a little bit ugly but it is much better than the alternatives, and
>> as soon as we finish the transition we can kill the macros.
>>
>> I introduce the macros CHIP_ARG, CHIP_VAR, and CHIP_PARAM where
>> appropriate.  I change a few declarations of irq as int to unsigned
>> int.  I normalize the variables names in the functions that call
>> chip methods to ensure that I have the variables irq and desc present
>> allowing CHIP_ARG to work properly.  Most importantly none of the irq
>> logic changes with this patch.
> 
> I like that approach very much. Is the output binary equivivalent?
> 
great.

will update x86 part and related core according to this, and give it a try.

YH
