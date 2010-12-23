Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab0LWKrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 05:47:48 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:49732 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab0LWKrr convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Thu, 23 Dec 2010 05:47:47 -0500
Message-Id: <4D1336DE020000780002977F@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 23 Dec 2010 10:47:42 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <akpm@linux-foundation.org>,
        "LKML" <linux-kernel@vger.kernel.org>, <mm-commits@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: + kmap-types-clean-up-and-optimization.patch added to -mm
	 tree
References: <201012222248.oBMMmbcF023808@imap1.linux-foundation.org>
 <1293098310.2170.415.camel@laptop>
In-Reply-To: <1293098310.2170.415.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 23.12.10 at 10:58, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2010-12-22 at 14:48 -0800, akpm@linux-foundation.org wrote:
>> The patch titled
>>      kmap-types: clean up and optimization
>> has been added to the -mm tree.  Its filename is
>>      kmap-types-clean-up-and-optimization.patch
>> 
>> Before you just go and hit "reply", please:
>>    a) Consider who else should be cc'ed
>>    b) Prefer to cc a suitable mailing list as well
>>    c) Ideally: find the original patch on the mailing list and do a
>>       reply-to-all to that, adding suitable additional cc's
>> 
> 
>> ------------------------------------------------------
>> Subject: kmap-types: clean up and optimization
>> From: "Jan Beulich" <JBeulich@novell.com>
>> 
>> Several of the types aren't being used at all anymore - those can be
>> deleted altogether.  
> 
> NO! That's wrong, in fact non of them are being used, but removing them
> will decrease the number of kmap_atomic slots, but those are still being
> used.

Would you mind pointing out examples of such uses (i.e. without
the proper enumerator)? How would those avoid collisions with
actually used slots?

>> Others are used only by single components that can be
>> assumed to be enabled everywhere, so those are made dependent upon
>> CONFIG_* settings.  Since this somewhat conflicts with the sequential gap
>> markers used under __WITH_KM_FENCE, and since this can be simplified
>> anyway, fold the enumerator definitions with the (modified accordingly)
>> KMAP_D() macro always.
>> 
>> The whole point of the reduction is that, at least on ix86, the number of
>> kmap types can (depending on configuration) affect the amount of low
>> memory, and thus unused types should be avoided if possible.
> 
> Feh, its only a few pages and since there is no way to actually tell if
> you've got enough kmap atomic pages other than experiencing runtime
> errors, removing them must be done with utmost prudence.

Whether 2Mb of lowmem is "only a few pages" certainly depends
on the perspective you take.

And even then - shouldn't the bad (non-enumerated) uses of
atomic kmap-s be fixed rather than keeping unused entries in
the enumeration just because there is broken code somewhere?

Jan

