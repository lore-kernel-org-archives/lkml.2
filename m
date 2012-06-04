Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab2FDNiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:38:46 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47528 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab2FDNio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:38:44 -0400
MIME-Version: 1.0
In-Reply-To: <87lik33mi6.fsf@rustcorp.com.au>
References: <8762blyedn.fsf@rustcorp.com.au>
	<87obpfxdpr.fsf@rustcorp.com.au>
	<20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
	<7474.1337782847@redhat.com>
	<5107.1337868051@redhat.com>
	<87r4u6w58c.fsf@rustcorp.com.au>
	<CA+5PVA5qCiYNppOBihKfsqvyNWwBsBsyGD7SmJaphV_67HG1aQ@mail.gmail.com>
	<87lik33mi6.fsf@rustcorp.com.au>
Date: Mon, 4 Jun 2012 09:38:43 -0400
Message-ID: <CA+5PVA4Trq-OEk6pwf5R4vr76zOSn=pmRJU=B6XHEzyOhS3UBw@mail.gmail.com>
Subject: Re: [PATCH 00/23] Crypto keys and module signing
From: Josh Boyer <jwboyer@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>, kyle@mcmartin.ca,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 3, 2012 at 9:16 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> > I had assumed you'd rather maintain a stable strip util which you can
>> > use on kernel modules than rework your module builds.  I guess not.
>>
>> Could you elaborate on this part a bit?  Do you mean integrate a
>> standalone strip utility in the kernel sources and maintain that for
>> use during module builds?  Or am I misunderstanding and you meant
>> something else?
>
> In the kernel sources, no.  But could RH maintain such a thing?  Surely.

Sure.  RH could continue to maintain the original modsign patch too.
I thought the point was to get the mechanism into the upstream kernel
so that it was generally available though.  Having the patches in the
mainline kernel but not the strip tool seems somewhat unhelpful.  I
would think such a tool would be part of the Kbuild infrastructure.

> Whether they want to guarantee that their strip is stable on kernel
> modules, or create a minimal 'kmod-strip' is up to them.
>
>> I can see how that sounds simple and desirable from one aspect, but
>> it seems somewhat odd to me to duplicate the existing (or create from
>> scratch) strip utilities.
>
> Mangling a module after it is signed is very odd, and odd things aren't
> nice for security features.  That's how we got here; I'm trying to move
> the oddness out of the verification path.

It's unfortunate, yes.  The biggest case I can think of is splitting
the debug symbols out of the modules after they are built (David might
have other cases).  Perhaps we could upstream that as well and
organize it such that the modules are built, split for debuginfo, and
then signed?

josh
