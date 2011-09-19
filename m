Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab1ISSVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:21:16 -0400
Received: from mail-vw0-f42.google.com ([209.85.212.42]:51889 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab1ISSVP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:21:15 -0400
MIME-Version: 1.0
In-Reply-To: <1316455395.16137.160.camel@nimitz>
References: <20110910164134.GA2442@albatros>
	<20110914192744.GC4529@outflux.net>
	<20110918170512.GA2351@albatros>
	<CAOJsxLF8DBEC9o9pSwa6c6pMg8ByFBdsDnzg22P3ucQcP98uzA@mail.gmail.com>
	<20110919144657.GA5928@albatros>
	<CAOJsxLG8gW=BLOptpULsaAEwTravADKbNbXp5e9Wd7xVEfR9AQ@mail.gmail.com>
	<20110919155718.GB16272@albatros>
	<CAOJsxLGZm+npcR0YgXSE2wLC2iXCtzYyCdTDCt1LN=Z28Rm_UA@mail.gmail.com>
	<20110919161837.GA2232@albatros>
	<CAOJsxLE2od0f+6cbL2hA_31CbrqS7AUofx5DT2L9fO_7gxH+PQ@mail.gmail.com>
	<20110919173539.GA3751@albatros>
	<CAOJsxLGc0bwCkDtk2PVe7c155a9wVoDAY0CmYDTLg8_bL4qxqg@mail.gmail.com>
	<1316455395.16137.160.camel@nimitz>
Date: Mon, 19 Sep 2011 21:21:15 +0300
X-Google-Sender-Auth: iJdEdyTEfjboE8xHOs6keLh5RS4
Message-ID: <CAOJsxLFe=i=TUbHuppHTSWPE1DXUw_fSujpR4Kn65_aXr4Hrdg@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/2] mm: restrict access to /proc/slabinfo
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        kernel-hardening@lists.openwall.com, Kees Cook <kees@ubuntu.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Theodore Tso <tytso@mit.edu>, Alan Cox <alan@linux.intel.com>,
        Jesper Juhl <jj@chaosbits.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 20:51 +0300, Pekka Enberg wrote:
>> How is the attacker able to identify that we kmalloc()'d from ecryptfs or
>> VFS based on non-root /proc/slabinfo when the slab allocator itself does
>> not have that sort of information if you mix up the allocations? Isn't this
>> much stronger protection especially if you combine that with /proc/slabinfo
>> restriction?

On Mon, Sep 19, 2011 at 9:03 PM, Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> Mixing it up just adds noise.  It makes the attack somewhat more
> difficult, but it still leaves open the possibility that the attacker
> can filter out the noise somehow.

So that would mean the attacker has somewhat fine-grained control over
kernel memory allocations, no? Can they use /proc/meminfo to deduce
the same kind of information? Should we close that down too?

                         Pekka
