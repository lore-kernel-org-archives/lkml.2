Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425Ab0JIStP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 14:49:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756091Ab0JIStO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 14:49:14 -0400
Message-ID: <4CB0B8EF.3050702@redhat.com>
Date: Sat, 09 Oct 2010 20:48:15 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 08/12] Handle async PF in a guest.
References: <1286207794-16120-1-git-send-email-gleb@redhat.com> <1286207794-16120-9-git-send-email-gleb@redhat.com> <4CADC6C3.3040305@redhat.com> <20101007171418.GA2397@redhat.com> <4CAE00CB.1070400@redhat.com> <20101007180340.GI2397@redhat.com>
In-Reply-To: <20101007180340.GI2397@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/07/2010 08:03 PM, Gleb Natapov wrote:
> >  >>
> >  >Host side keeps track of outstanding apfs and will not send apf for the
> >  >same phys address twice. It will halt vcpu instead.
> >
> >  What about different pages, running the scheduler code?
> >
> We can get couple of nested apfs, just like we can get nested
> interrupts. Since scheduler disables preemption second apf will halt.

How much is a couple?

Consider:

SIGSTOP
Entire process swapped out
SIGCONT

We can get APF's on the current code, the scheduler code, the stack, any 
debugging code in between (e.g. ftrace), and the page tables for all of 
these.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

