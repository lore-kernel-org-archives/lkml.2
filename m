Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab0HUAUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 20:20:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50345 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab0HUAUV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 20:20:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=t2T6lokL3fZj997cAdd96wmWoSJDLFkaUhFzF97jUwg+HR+D4pR2yRQoN4XqTm2dm0
         8iQgHl7nek+FXZmxJm6ITQsziOP1M6NsHbMDWDvtD1UVlPhgURq3JWDprGfSGRShi6EW
         RcPMVBX+3SaiOmDjGTsgGshax2RVAdTTAvisg=
MIME-Version: 1.0
In-Reply-To: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>
From: Mike Snitzer <snitzer@gmail.com>
Date: Fri, 20 Aug 2010 20:20:00 -0400
Message-ID: <AANLkTi=iTY1LBE6F6u+e4mF61N6b_Sqdy2MBi6LJMQai@mail.gmail.com>
Subject: Re: [RFC] mlock/stack guard interaction fixup
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@suse.de>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 7:59 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Ian (and others),
>  here's a three-patch series that uses the doubly linked list to do
> your mlock() case hopefully correctly.
>
> NOTE! It's untested. The first patch (which is the slightly scary one)
> is tested to some degree, the two other ones I checked that they
> compile, but that's it.
>
> I'm not going to apply them to my main tree unless they get testing
> and acks. And as mentioned, I've not done any of the changes that
> having a vm_prev pointer can allow in other places.
>
> Comments? Fixes? Braindamage?

In 0002-mm-make-the-mlock-stack-guard-page-checks-stricter.patch you
switch __mlock_vma_pages_range from 'start += PAGE_SIZE' to 'addr +=
PAGE_SIZE'.

So would that be a bugfix for commit d7824370?  Seems likely given
start isn't used after that point.

Mike
