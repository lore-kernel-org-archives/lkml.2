Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab1BBArU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:47:20 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39752 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab1BBArP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:47:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PRHStCmSJpaphQRGsRwQ8LqPgp4ptz7K9jYyXBKgPI0nCYL2PLEqlxbqn6fmEXmyK7
         ZOrEgqezX8hKNlAlf6/SPhYNjmIOgkNpa6m8cuROP9Y5KWmasQLXMDvNAOIO67lpofmS
         zCBFO9WDuQq7PPew9wiwmzMvGXS3r9JVdGfY8=
MIME-Version: 1.0
In-Reply-To: <20110201232750.GA30800@ulf>
References: <20110201232750.GA30800@ulf>
Date: Tue, 1 Feb 2011 19:47:14 -0500
Message-ID: <AANLkTinuLrUYJZzkmCVu9ZAYz-z2k-_cYb7opa2+Uutm@mail.gmail.com>
Subject: Re: [PATCH] [ANNOUNCE] kconfig: Kconfiglib: a flexible Python Kconfig parser
From: Arnaud Lacombe <lacombar@gmail.com>
To: Ulf Magnusson <ulfalizer.lkml@gmail.com>
Cc: linux-kbuild@vger.kernel.org, zippel@linux-m68k.org, mmarek@suse.cz,
        rdunlap@xenotime.net, akpm@linux-foundation.org,
        andrea.gelmini@gelma.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Feb 1, 2011 at 6:27 PM, Ulf Magnusson <ulfalizer.lkml@gmail.com> wrote:
> Hi,
>
> This is the initial release of Kconfiglib: a Python library for
> scripting, debugging, and extracting information from Kconfig-based
> configuration systems.  It can be used to programmatically generate a
> .config when the '*conf' tools are too inflexible, to quickly find out
> interesting information about a Kconfig configuration such as dependency
> relations between symbols and where undefined symbols are referenced,
> and in applications that need to parse and extract information from
> Kconfig files.
>
Does that mean that when a kconfig-language change will happen, one
will not only must have to be Lex/YaCC and C fluent, but also, perl
and python ? That seem to be a lot of duplication to me.

I'd rather see the backend be changed so that it could be used with
SWIG to generate language bindings. I had WIP in this area, but
changes needed are rather intrusive. That said, the testsuite might be
interesting, I've been thinking about that for quite some time.

 - Arnaud

> For a much longer introduction including multiple examples, see
> arch/kconfig/kconfiglib.py.
>
> Have fun!
>
> Signed-off-by: Ulf Magnusson <ulfalizer.lkml@gmail.com>
> ---
> Convenience links:
>
> Documentation, generated from kconfiglib.py with pydoc -w:
> http://dl.dropbox.com/u/10406197/kconfiglib.html
>
> Examples as separate files:
> http://dl.dropbox.com/u/10406197/kconfiglib-examples.tar.gz
>
>
> The patch should be preferably be applied to a recent kernel, i.e. Linus's
> (2.6.38-rc3 at the time of writing).  Due to recent Kconfig changes, the
> kconfigtest.py test suite - which compares output character-for-character -
> will indicate failure on older (a few months old) kernels versions even though
> the outputs are functionally equivalent.
>
>  Documentation/kbuild/kconfig-language.txt |    5 +
>  Documentation/kbuild/kconfig.txt          |    8 +
>  README                                    |   13 +
>  scripts/kconfig/Makefile                  |   26 +-
>  scripts/kconfig/kconfiglib.py             | 3918 +++++++++++++++++++++++++++++
>  scripts/kconfig/kconfigtest.py            |  396 +++
>  6 files changed, 4365 insertions(+), 1 deletions(-)
>  create mode 100644 scripts/kconfig/kconfiglib.py
>  create mode 100644 scripts/kconfig/kconfigtest.py
> [...]
