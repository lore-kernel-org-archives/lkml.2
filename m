Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab2EaPf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:35:27 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:47351 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab2EaPfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:35:25 -0400
MIME-Version: 1.0
In-Reply-To: <87r4u6w58c.fsf@rustcorp.com.au>
References: <8762blyedn.fsf@rustcorp.com.au>
	<87obpfxdpr.fsf@rustcorp.com.au>
	<20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
	<7474.1337782847@redhat.com>
	<5107.1337868051@redhat.com>
	<87r4u6w58c.fsf@rustcorp.com.au>
Date: Thu, 31 May 2012 11:35:23 -0400
Message-ID: <CA+5PVA5qCiYNppOBihKfsqvyNWwBsBsyGD7SmJaphV_67HG1aQ@mail.gmail.com>
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

On Sun, May 27, 2012 at 1:41 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Thu, 24 May 2012 15:00:51 +0100, David Howells <dhowells@redhat.com> wrote:
>> > > Why would you want multiple signatures?  That just complicates things.
>> >
>> > The code above stays pretty simple; if the signature fails, you set size
>> > to i, and loop again.  As I said, if you know exactly how you're going
>> > to strip the modules, you can avoid storing the stripped module and
>> > simply append both signatures.
>>
>> You still haven't justified it.  One of your arguments about rejecting the ELF
>> parsing version was that it was too big for no useful extra value that I could
>> justify.  Supporting multiple signatures adds extra size and complexity for no
>> obvious value.
>
> One loop is a lot easier to justify that the ELF-parsing mess.  And it
> can be done in a backwards compatible way tomorrow: old kernels will
> only check the last signature.
>
> I had assumed you'd rather maintain a stable strip util which you can
> use on kernel modules than rework your module builds.  I guess not.

Could you elaborate on this part a bit?  Do you mean integrate a
standalone strip utility in the kernel sources and maintain that for
use during module builds?  Or am I misunderstanding and you meant
something else?

I can see how that sounds simple and desirable from one aspect, but
it seems somewhat odd to me to duplicate the existing (or create from
scratch) strip utilities.

josh
