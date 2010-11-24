Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab0KXJja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 04:39:30 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40023 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab0KXJj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 04:39:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=TiwqgGqS5XBOn8cC51Xf2ntx3jstNRXOIvuJzTYH7iBLqGeJrJw3mqQVmLmxVAzJEV
         dkU353uORRrKTJs0q3tHUk6oWXC+2J3JqvIWdHzQeLBm/rL1mYM+ejlRXvJlm7mEhGWX
         YmSNxOZSmWt+g1DoO/BnMaJWwEhAssg0YIjag=
MIME-Version: 1.0
In-Reply-To: <1290589356.2072.433.camel@laptop>
References: <20101123224601.766827604@openvz.org>
	<20101123224800.658686382@openvz.org>
	<1290587537.2072.430.camel@laptop>
	<AANLkTinac7XwdARsLSeLmbc4Kj6my5MHQ=hAgV+A7o-W@mail.gmail.com>
	<1290589356.2072.433.camel@laptop>
Date: Wed, 24 Nov 2010 12:39:28 +0300
X-Google-Sender-Auth: b8GDgUAxAlcLKUrIimxB-k6z1tY
Message-ID: <AANLkTi=Emgr=gYLgg+PXkubmiRyFpLDjPE=kO6DFQwhi@mail.gmail.com>
Subject: Re: [rfc 3/3] perf, x86: P4 PMU -- export ABI part of event config to userspace
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        ming.m.lin@intel.com, eranian@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/10, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-11-24 at 11:48 +0300, Cyrill Gorcunov wrote:
>> On 11/24/10, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Wed, 2010-11-24 at 01:46 +0300, Cyrill Gorcunov wrote:
>> >> plain text document attachment (x86-perf-export-abi)
>> >> Due to tight 64 bit size of event config field (where we have to track
>> >> pretty lot of info during event lifetime) some bits are to be exported
>> >> via header into userspace.
>> >>
>> >> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
>> >> CC: Lin Ming <ming.m.lin@intel.com>
>> >> CC: Stephane Eranian <eranian@google.com>
>> >> CC: Peter Zijlstra <peterz@infradead.org>
>> >> ---
>> >>
>> >> Note that I don't like much the idea to export anything into userspace
>> >> but it seems there is no other choise. So there is a minimum which
>> >> should
>> >> be exported.
>> >
>> >
>> > Could you say what exactly is exposed to userspace and why?
>>
>> yes, we need two enums to be exported, because we use custom encoding,
>> which is described in first patch. peter i'll describe more detailed
>> in a couple of hours, ok?
>
> Sure, but have you seen my sysfs patches? wouldn't describing the format
> in there suffice?
>
> http://lkml.org/lkml/2010/11/17/154
>
>
just looked at them, but the main problem is that a few fields in
.config consist of custom values about which userspace knows nothing,
ie these fields are not described in SDM but we define own ones. this
mess is because we need to pack a lot of info in single 64bit field so
kernel would track event properly in terms of hardware resources. i
will describe the details as only reach the computer.
