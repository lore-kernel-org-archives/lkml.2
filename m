Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab1IPO5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 10:57:08 -0400
Received: from smtp-out.google.com ([74.125.121.67]:56303 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab1IPO5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 10:57:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=XlO/yRWEKS/9YviQ0hg8zI5RuqXHmG/CABzE7FI1qK+k+ZmFqnp48Lot7ItqVnT3e
	uU+FX8PlNozKT9Xn7e0mQ==
MIME-Version: 1.0
In-Reply-To: <4E736297.2070604@gmail.com>
References: <20110907191045.GA13475@quad>
	<4E6E0D0B.3080306@gmail.com>
	<CABPqkBSfQo5E=MJ913E--dc8Fi7VLcFSGNbBf60tOnTLMuVN_w@mail.gmail.com>
	<4E6E181E.9080506@gmail.com>
	<CABPqkBQWd=DyRRDhaxwDGrpCs=XqyTUv72+dn7GKsT=kjPqiJg@mail.gmail.com>
	<1315838611.26517.51.camel@twins>
	<CABPqkBShe6OG1ukQ=7vn_Mr=Aa_c8jcbo1mYuF+41Euy5_R7Dw@mail.gmail.com>
	<1316183832.10174.28.camel@twins>
	<CABPqkBRmpnMNH16_HNWWHFn8dDtTE+jRjunkLDpc30SnA8_oYA@mail.gmail.com>
	<4E736297.2070604@gmail.com>
Date: Fri, 16 Sep 2011 16:56:57 +0200
Message-ID: <CABPqkBSvyX=mHs7X+rSC7puZHzhjP-yDqVWPSP7BPWcFOADSHA@mail.gmail.com>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v4)
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        acme@redhat.com, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 4:52 PM, David Ahern <dsahern@gmail.com> wrote:
>
> On 09/16/2011 08:44 AM, Stephane Eranian wrote:
>>> Sure, but all you need to know is if the file you're reading is a
>>> different endian than your box, if it is swap stuff, if its not, you're
>>> good.
>>
>> We agree on that. I am just saying the MAGIC string as it is today
>> may not be enough to tell us that.
>
> Right. I think that's why the attribute struct is used to detect
> endianness and not the magic.
>
Yes, but using attr_size was the wrong choice. I suspect we may be
able to use size (sizeof(f_header)) if we know:
- it is not going to change.
- require perfect match with sizeof(struct perf_file_header)
