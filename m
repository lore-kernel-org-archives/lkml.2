Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1FSNCw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 09:02:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab1FSNCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 09:02:50 -0400
Message-ID: <4DFDF35E.8030504@redhat.com>
Date: Sun, 19 Jun 2011 16:02:22 +0300
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
References: <1308007897-17013-1-git-send-email-glommer@redhat.com> <1308007897-17013-4-git-send-email-glommer@redhat.com> <20110614074500.GM491@redhat.com> <4DF8226B.20408@redhat.com> <20110615090951.GQ491@redhat.com> <4DFDED2E.6030009@redhat.com> <20110619125956.GV491@redhat.com>
In-Reply-To: <20110619125956.GV491@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2011 03:59 PM, Gleb Natapov wrote:
> On Sun, Jun 19, 2011 at 03:35:58PM +0300, Avi Kivity wrote:
> >  On 06/15/2011 12:09 PM, Gleb Natapov wrote:
> >  >>
> >  >>   Actually, I'd expect most read/writes to benefit from caching, no?
> >  >>   So why don't we just rename kvm_write_guest_cached() to
> >  >>   kvm_write_guest(), and the few places - if any - that need to force
> >  >>   transversing of the gfn mappings, get renamed to
> >  >>   kvm_write_guest_uncached ?
> >  >>
> >  >Good idea. I do not see any places where kvm_write_guest_uncached is
> >  >needed from a brief look. Avi?
> >  >
> >
> >  kvm_write_guest_cached() needs something to supply the cache, and
> >  needs recurring writes to the same location.  Neither of these are
> >  common (for example, instruction emulation doesn't have either).
> >
> Correct. Missed that. So what about changing steal time to use
> kvm_write_guest_cached()?

Makes sense, definitely.  Want to post read_guest_cached() as well?

-- 
error compiling committee.c: too many arguments to function

