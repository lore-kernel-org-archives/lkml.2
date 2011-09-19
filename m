Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab1ISOaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 10:30:52 -0400
Received: from mail-vw0-f42.google.com ([209.85.212.42]:38677 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab1ISOau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 10:30:50 -0400
MIME-Version: 1.0
In-Reply-To: <20110918170512.GA2351@albatros>
References: <20110910164001.GA2342@albatros>
	<20110910164134.GA2442@albatros>
	<20110914192744.GC4529@outflux.net>
	<20110918170512.GA2351@albatros>
Date: Mon, 19 Sep 2011 17:30:49 +0300
X-Google-Sender-Auth: 6zfIU8r2o-ZGoW5DIBrHI1rs-Mw
Message-ID: <CAOJsxLF8DBEC9o9pSwa6c6pMg8ByFBdsDnzg22P3ucQcP98uzA@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/2] mm: restrict access to /proc/slabinfo
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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

> On Wed, Sep 14, 2011 at 12:27 -0700, Kees Cook wrote:
>> On Sat, Sep 10, 2011 at 08:41:34PM +0400, Vasiliy Kulikov wrote:
>> > Historically /proc/slabinfo has 0444 permissions and is accessible to
>> > the world.  slabinfo contains rather private information related both to
>> > the kernel and userspace tasks.  Depending on the situation, it might
>> > reveal either private information per se or information useful to make
>> > another targeted attack.  Some examples of what can be learned by
>> > reading/watching for /proc/slabinfo entries:
>> > ...
>> > World readable slabinfo simplifies kernel developers' job of debugging
>> > kernel bugs (e.g. memleaks), but I believe it does more harm than
>> > benefits.  For most users 0444 slabinfo is an unreasonable attack vector.
>> >
>> > Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

On Sun, Sep 18, 2011 at 8:05 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
>> Haven't had any mass complaints about the 0400 in Ubuntu (sorry Dave!), so
>> I'm obviously for it.
>>
>> Reviewed-by: Kees Cook <kees@ubuntu.com>
>
> Looks like the members of the previous slabinfo discussion don't object
> against the patch now and it got two other Reviewed-by responses.  Can
> you merge it as-is or should I probably convince someone else?

We discussed this in March (google for 'Make /proc/slabinfo 0400') and
concluded that it's not worth it doesn't really protect from anything
and causes harm to developers.

                        Pekka
