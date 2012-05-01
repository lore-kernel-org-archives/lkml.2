Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab2EAXWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 19:22:35 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63453 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab2EAXWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 19:22:34 -0400
MIME-Version: 1.0
In-Reply-To: <x49bom7ljt5.fsf@segfault.boston.devel.redhat.com>
References: <x49pqaom2u4.fsf@segfault.boston.devel.redhat.com>
	<CAPa8GCAgDU8FYdMuWsn2PuUW0GQxdKWJV6K0SmQEzb3s1GHxwA@mail.gmail.com>
	<x49lilcm1tb.fsf@segfault.boston.devel.redhat.com>
	<CAPa8GCChTmXTmjY5GvsFsvXpP_WSuiiWMRDu7Lvb71G9tW1PTw@mail.gmail.com>
	<x49bom7ljt5.fsf@segfault.boston.devel.redhat.com>
Date: Wed, 2 May 2012 09:22:33 +1000
Message-ID: <CAPa8GCBA0XwBH=D0rem5aC=FfLKSTGXaKOb4Mox2ad5kkc7LNg@mail.gmail.com>
Subject: Re: [patch|rfc] block: don't mark buffers beyond end of disk as mapped
From: Nick Piggin <npiggin@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jaxboe@fusionio.com, Kyle McMartin <kmcmarti@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 May 2012 06:37, Jeff Moyer <jmoyer@redhat.com> wrote:
> Nick Piggin <npiggin@gmail.com> writes:

>> In fact, it's probably good to unify the checks here, i.e., use max_blocks()
>
> You really think it's worth it?  I mean, it's just an i_size_read and a
> shift, and there is precedent for it inside fs/buffer.c.  I'd prefer to
> keep the patch as-is, but will change it if you feel that strongly about
> it.

Well, I'd just like it to use identical code (because they potentially
set up buffer heads for one another to use).

I don't feel too strongly, so if anyone else does one way or the
other, that is fine. But seeing as you've updated the patch...
