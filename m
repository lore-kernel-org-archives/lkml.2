Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab1FTMnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 08:43:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab1FTMnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 08:43:00 -0400
Message-ID: <4DFF4037.20306@redhat.com>
Date: Mon, 20 Jun 2011 09:42:31 -0300
From: Glauber Costa <glommer@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH 3/7] KVM-HV: KVM Steal time implementation
References: <1308007897-17013-1-git-send-email-glommer@redhat.com> <1308007897-17013-4-git-send-email-glommer@redhat.com> <20110614074500.GM491@redhat.com> <4DF8226B.20408@redhat.com> <20110615090951.GQ491@redhat.com> <4DFDED2E.6030009@redhat.com> <20110619125956.GV491@redhat.com> <4DFDF35E.8030504@redhat.com> <20110620072128.GW491@redhat.com> <4DFEFE8A.4050101@redhat.com>
In-Reply-To: <4DFEFE8A.4050101@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2011 05:02 AM, Avi Kivity wrote:
> On 06/20/2011 10:21 AM, Gleb Natapov wrote:
>> On Sun, Jun 19, 2011 at 04:02:22PM +0300, Avi Kivity wrote:
>> > On 06/19/2011 03:59 PM, Gleb Natapov wrote:
>> > >On Sun, Jun 19, 2011 at 03:35:58PM +0300, Avi Kivity wrote:
>> > >> On 06/15/2011 12:09 PM, Gleb Natapov wrote:
>> > >> >>
>> > >> >> Actually, I'd expect most read/writes to benefit from caching,
>> no?
>> > >> >> So why don't we just rename kvm_write_guest_cached() to
>> > >> >> kvm_write_guest(), and the few places - if any - that need to
>> force
>> > >> >> transversing of the gfn mappings, get renamed to
>> > >> >> kvm_write_guest_uncached ?
>> > >> >>
>> > >> >Good idea. I do not see any places where
>> kvm_write_guest_uncached is
>> > >> >needed from a brief look. Avi?
>> > >> >
>> > >>
>> > >> kvm_write_guest_cached() needs something to supply the cache, and
>> > >> needs recurring writes to the same location. Neither of these are
>> > >> common (for example, instruction emulation doesn't have either).
>> > >>
>> > >Correct. Missed that. So what about changing steal time to use
>> > >kvm_write_guest_cached()?
>> >
>> > Makes sense, definitely. Want to post read_guest_cached() as well?
>> >
>> Glauber can you write read_guest_cached() as part of your series (should
>> be trivial), or do you want me to do it? I do not have a code to test it
>> with though :)
>
> Yes.
>
> (you can write it, and Glauber can include it in the series)
>
Write it, handle me the patch, I'll include it and test it.

