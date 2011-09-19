Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1ISPU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 11:20:29 -0400
Received: from mail-ew0-f45.google.com ([209.85.215.45]:39240 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab1ISPU2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 11:20:28 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Sep 2011 11:20:27 EDT
MIME-Version: 1.0
In-Reply-To: <20110919144657.GA5928@albatros>
References: <20110910164001.GA2342@albatros>
	<20110910164134.GA2442@albatros>
	<20110914192744.GC4529@outflux.net>
	<20110918170512.GA2351@albatros>
	<CAOJsxLF8DBEC9o9pSwa6c6pMg8ByFBdsDnzg22P3ucQcP98uzA@mail.gmail.com>
	<20110919144657.GA5928@albatros>
Date: Mon, 19 Sep 2011 18:13:12 +0300
X-Google-Sender-Auth: xjQgGZjxVmC1s7uyPxjPAPHwyd8
Message-ID: <CAOJsxLG8gW=BLOptpULsaAEwTravADKbNbXp5e9Wd7xVEfR9AQ@mail.gmail.com>
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

Hi Vasiliy,

On Mon, Sep 19, 2011 at 5:46 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
>> and
>> concluded that it's not worth it doesn't really protect from anything
>
> Closing only slabinfo doesn't add any significant protection against
> kernel heap exploits per se, no objections here.
>
> But as said in the desciption, the reason for this patch is not protecting
> against exploitation heap bugs.  It is a source of infoleaks of kernel
> and userspace activity, which should be forbidden to non-root users.

Last time we discussed this, the 'extra protection' didn't seem to be
significant enough to justify disabling an useful kernel debugging
interface by default.

What's different about the patch now?

>> and causes harm to developers.
>
> One note: only to _kernel_ developers.  It means it is a strictly
> debugging feature, which shouldn't be enabled in the production systems.

It's pretty much _the_ interface for debugging kernel memory leaks in
production systems and we ask users for it along with /proc/meminfo
when debugging many memory management related issues. When we
temporarily dropped /proc/slabinfo with the introduction of SLUB, people
complained pretty loudly.

I'd be willing to consider this patch if it's a config option that's not enabled
by default; otherwise you need to find someone else to merge the patch.
You can add some nasty warnings to the Kconfig text to scare the users
into enabling it. ;-)

                         Pekka
