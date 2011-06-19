Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1FSMgN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 08:36:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab1FSMgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 08:36:10 -0400
Message-ID: <4DFDED2E.6030009@redhat.com>
Date: Sun, 19 Jun 2011 15:35:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH 3/7] KVM-HV: KVM Steal time implementation
References: <1308007897-17013-1-git-send-email-glommer@redhat.com> <1308007897-17013-4-git-send-email-glommer@redhat.com> <20110614074500.GM491@redhat.com> <4DF8226B.20408@redhat.com> <20110615090951.GQ491@redhat.com>
In-Reply-To: <20110615090951.GQ491@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2011 12:09 PM, Gleb Natapov wrote:
> >
> >  Actually, I'd expect most read/writes to benefit from caching, no?
> >  So why don't we just rename kvm_write_guest_cached() to
> >  kvm_write_guest(), and the few places - if any - that need to force
> >  transversing of the gfn mappings, get renamed to
> >  kvm_write_guest_uncached ?
> >
> Good idea. I do not see any places where kvm_write_guest_uncached is
> needed from a brief look. Avi?
>

kvm_write_guest_cached() needs something to supply the cache, and needs 
recurring writes to the same location.  Neither of these are common (for 
example, instruction emulation doesn't have either).

> >
> >  If done like you said, time spent on the hypervisor is accounted as
> >  steal time. I don't think it is.
> I thought that this is the point of a steal time. Running other
> tasks/guests is a hypervisor overhead too after all :) Also what about
> time spend serving host interrupts between put/get? It will not be
> accounted as steal time, correct?

With accurate interrupt time accounting, it should be.  Otherwise 
general hypervisor overhead is not steal time.

(i.e. if the host is not overcommitted, steal time should be close to zero).

-- 
error compiling committee.c: too many arguments to function

