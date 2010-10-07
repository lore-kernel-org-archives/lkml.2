Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab0JGRsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:48:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab0JGRsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:48:43 -0400
Message-ID: <4CAE07E1.5050701@redhat.com>
Date: Thu, 07 Oct 2010 13:48:17 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, hpa@zytor.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 08/12] Handle async PF in a guest.
References: <1286207794-16120-1-git-send-email-gleb@redhat.com> <1286207794-16120-9-git-send-email-gleb@redhat.com> <4CADC6C3.3040305@redhat.com> <20101007171418.GA2397@redhat.com> <4CAE00CB.1070400@redhat.com>
In-Reply-To: <4CAE00CB.1070400@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2010 01:18 PM, Avi Kivity wrote:
> On 10/07/2010 07:14 PM, Gleb Natapov wrote:

>> Host side keeps track of outstanding apfs and will not send apf for the
>> same phys address twice. It will halt vcpu instead.
>
> What about different pages, running the scheduler code?
>
> Oh, and we'll run the scheduler recursively.

When preempt is disabled in the guest, it will not invoke
the "reschedule for apf" code, but it will simply turn
into a normal page fault.

Last I looked, the scheduler code disabled preempt (for
obvious reasons).

-- 
All rights reversed
