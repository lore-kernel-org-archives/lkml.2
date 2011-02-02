Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab1BBCCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 21:02:40 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57365 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1BBCCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 21:02:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=uUVG1k39NnKgxWVsXYb6vQH76yPS6AYhfQOdO4B2O7y3y2TyEgHM1x/JcXd7yh/ndC
         m3PB8NkM1j+mCJKm99Et1NuhrhQnVIlg4KnpawcwB54It/IdPtsbVWtxZk7iEIJe90j7
         Zzeteg3E5yJSnR7141ud5hhTiZZxS4P/oV4Rk=
Date: Wed, 2 Feb 2011 03:02:26 +0100
From: Ulf Magnusson <ulfalizer.lkml@gmail.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, zippel@linux-m68k.org, mmarek@suse.cz,
        rdunlap@xenotime.net, akpm@linux-foundation.org,
        andrea.gelmini@gelma.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, ulfalizer.lkml@gmail.com
Subject: Re: [PATCH] [ANNOUNCE] kconfig: Kconfiglib: a flexible Python
 Kconfig parser
Message-ID: <20110202020225.GA31558@ulf>
Mail-Followup-To: Ulf Magnusson <ulfalizer.lkml@gmail.com>,
	Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
	zippel@linux-m68k.org, mmarek@suse.cz, rdunlap@xenotime.net,
	akpm@linux-foundation.org, andrea.gelmini@gelma.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20110201232750.GA30800@ulf>
 <AANLkTinuLrUYJZzkmCVu9ZAYz-z2k-_cYb7opa2+Uutm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinuLrUYJZzkmCVu9ZAYz-z2k-_cYb7opa2+Uutm@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 07:47:14PM -0500, Arnaud Lacombe wrote:
> Hi,
> 
> On Tue, Feb 1, 2011 at 6:27 PM, Ulf Magnusson <ulfalizer.lkml@gmail.com> wrote:
> > Hi,
> >
> > This is the initial release of Kconfiglib: a Python library for
> > scripting, debugging, and extracting information from Kconfig-based
> > configuration systems.  It can be used to programmatically generate a
> > .config when the '*conf' tools are too inflexible, to quickly find out
> > interesting information about a Kconfig configuration such as dependency
> > relations between symbols and where undefined symbols are referenced,
> > and in applications that need to parse and extract information from
> > Kconfig files.
> >
> Does that mean that when a kconfig-language change will happen, one
> will not only must have to be Lex/YaCC and C fluent, but also, perl
> and python ? That seem to be a lot of duplication to me.
> 
> I'd rather see the backend be changed so that it could be used with
> SWIG to generate language bindings. I had WIP in this area, but
> changes needed are rather intrusive. That said, the testsuite might be
> interesting, I've been thinking about that for quite some time.
> 
>  - Arnaud
> 
I originally experimented with patching the back end, but as you say the
changes would probably have to be very invasive/obfuscating in order to
extract all the information you can get out of Kconfiglib.  So I instead
went the minimally invasive route with a completely stand-alone library
together with a test suite.

I'm willing to update Kconfiglib when future additions/modifications are
made to the Kconfig language so that all tests in the compatibility test
suite keep passing.  I've added lots of comments and documentation to
internal methods and tried to keep the code clean and straightforward,
so it should be pretty easy for others to get into the code as well.

If by Perl you're referring to streamline_config.pl, I suspect it could
be rewritten as a smallish Kconfiglib script, though I haven't looked at
it closely.  That version might also be much better at respecting symbol
dependencies.
> > For a much longer introduction including multiple examples, see
> > arch/kconfig/kconfiglib.py.
> >
> > Have fun!
> >
> > Signed-off-by: Ulf Magnusson <ulfalizer.lkml@gmail.com>
> > ---
> > Convenience links:
> >
> > Documentation, generated from kconfiglib.py with pydoc -w:
> > http://dl.dropbox.com/u/10406197/kconfiglib.html
> >
> > Examples as separate files:
> > http://dl.dropbox.com/u/10406197/kconfiglib-examples.tar.gz
> >
> >
> > The patch should be preferably be applied to a recent kernel, i.e. Linus's
> > (2.6.38-rc3 at the time of writing).  Due to recent Kconfig changes, the
> > kconfigtest.py test suite - which compares output character-for-character -
> > will indicate failure on older (a few months old) kernels versions even though
> > the outputs are functionally equivalent.
> >
> >  Documentation/kbuild/kconfig-language.txt |    5 +
> >  Documentation/kbuild/kconfig.txt          |    8 +
> >  README                                    |   13 +
> >  scripts/kconfig/Makefile                  |   26 +-
> >  scripts/kconfig/kconfiglib.py             | 3918 +++++++++++++++++++++++++++++
> >  scripts/kconfig/kconfigtest.py            |  396 +++
> >  6 files changed, 4365 insertions(+), 1 deletions(-)
> >  create mode 100644 scripts/kconfig/kconfiglib.py
> >  create mode 100644 scripts/kconfig/kconfigtest.py
> > [...]
