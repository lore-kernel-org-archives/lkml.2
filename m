Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab0JJMja (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 08:39:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab0JJMj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 08:39:29 -0400
Message-ID: <4CB1B3E2.3000200@redhat.com>
Date: Sun, 10 Oct 2010 14:38:58 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 08/12] Handle async PF in a guest.
References: <1286207794-16120-1-git-send-email-gleb@redhat.com> <1286207794-16120-9-git-send-email-gleb@redhat.com> <4CADC6C3.3040305@redhat.com> <20101010123220.GN2397@redhat.com>
In-Reply-To: <20101010123220.GN2397@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/10/2010 02:32 PM, Gleb Natapov wrote:
> On Thu, Oct 07, 2010 at 03:10:27PM +0200, Avi Kivity wrote:
> >   On 10/04/2010 05:56 PM, Gleb Natapov wrote:
> >  >When async PF capability is detected hook up special page fault handler
> >  >that will handle async page fault events and bypass other page faults to
> >  >regular page fault handler. Also add async PF handling to nested SVM
> >  >emulation. Async PF always generates exit to L1 where vcpu thread will
> >  >be scheduled out until page is available.
> >  >
> >
> >  Please separate guest and host changes.
> >
> Hmm. There are only guest changes here as far as I can see.

 From the diffstat:

>   arch/x86/include/asm/kvm_para.h |   12 +++
>   arch/x86/include/asm/traps.h    |    1 +
>   arch/x86/kernel/entry_32.S      |   10 ++
>   arch/x86/kernel/entry_64.S      |    3 +
>   arch/x86/kernel/kvm.c           |  184 ++++++++++++++++++++++++++++++++++++++-
>   arch/x86/kvm/svm.c              |   43 +++++++--

svm.c is host code.

-- 
error compiling committee.c: too many arguments to function

