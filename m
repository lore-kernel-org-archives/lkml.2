Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab0KLWRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 17:17:14 -0500
Received: from claw.goop.org ([74.207.240.146]:39354 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab0KLWRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 17:17:11 -0500
Message-ID: <4CDDBCE4.80906@goop.org>
Date: Fri, 12 Nov 2010 14:17:08 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/20] x86: ticket lock rewrite and paravirtualization
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com> <4CDDBBD3.5050903@zytor.com>
In-Reply-To: <4CDDBBD3.5050903@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2010 02:12 PM, H. Peter Anvin wrote:
> On 11/03/2010 07:59 AM, Jeremy Fitzhardinge wrote:
>>       - with an unmodified struct spinlock, it can check to see if
>>         head == tail after unlock; if not, then there's someone else
>>         trying to lock, and we can do a kick.  Unfortunately this
>>         generates very high level of redundant kicks, because the
>>         waiting CPU might not have blocked yet (which is the common
>>         case)
>>
> How high is "very high" here -- most of the time (so that any mitigation
> on the slow patch is useless)?

I'll need to remeasure, but I think around 90% of the slowpath entries
were spurious without this.  In other words, when spinlocks do contend,
most of the time it isn't very serious and the other cpu doesn't spend
much time spinning.

    J
