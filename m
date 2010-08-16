Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab0HPVFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 17:05:34 -0400
Received: from smtp-out.google.com ([74.125.121.35]:38489 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab0HPVFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 17:05:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=EDoij01/wD31Xb+8gjnyEfxBq8obhNzae0OyQ9tCT50M73/4CIfqxEmCAymVkmDEX
	PC+yWAMLMD8QL6btffytw==
MIME-Version: 1.0
In-Reply-To: <AANLkTindpUo5tPiXVp6wXjOAqczrJvYegrOMBqSjr4_t@mail.gmail.com>
References: <20100816182834.3541.42317.stgit@bumblebee1.mtv.corp.google.com>
	<1281987236.1926.1895.camel@laptop>
	<AANLkTindpUo5tPiXVp6wXjOAqczrJvYegrOMBqSjr4_t@mail.gmail.com>
Date: Mon, 16 Aug 2010 14:05:28 -0700
Message-ID: <AANLkTinDwPgqyUDcyjfe+DaTRta=ERfseUGMg9yvZ4gA@mail.gmail.com>
Subject: Re: [PATCH] Fixed a mismatch between the users of radix_tree and the implementation.
From: Salman Qazi <sqazi@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulmck@us.ibm.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, adurbin@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 1:59 PM, Salman Qazi <sqazi@google.com> wrote:
>
>
> On Mon, Aug 16, 2010 at 12:33 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> On Mon, 2010-08-16 at 11:30 -0700, Salman Qazi wrote:
>> > For the delete case,
>> > we no longer shrink the tree back to being just the root containing the
>> > only remaining object.  For the insert case, we no longer store the
>> > first object in the root, rather allocating a node structure for it.  The
>> > reason that this works is that deleting (or inserting) intermediate nodes
>> > does not make a difference to a reader holding a slot.
>>
>> Ah, I through that was what it did. So you basically increase the memory
>> footprint for tiny files.. have you done any measurements on that?
>
>


You raise a valid concern.  I haven't.  What would you recommend as a
benchmark/metric to measure this?
(had to resend this. mail client had decided to switch to HTML mode,
which LKML didn't like)
