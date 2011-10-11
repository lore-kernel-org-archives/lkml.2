Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab1JKRnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:43:55 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49580 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754955Ab1JKRny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:43:54 -0400
Message-ID: <1318355030.8896.12.camel@Joe-Laptop>
Subject: Re: [PATCH] treewide: Use __printf not
 __attribute__((format(printf,...)))
From: Joe Perches <joe@perches.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org
Date: Tue, 11 Oct 2011 10:43:50 -0700
In-Reply-To: <20111011172208.GA3633@shutemov.name>
References: <5a0bef0143ed2b3176917fdc0ddd6a47f4c79391.1314303846.git.joe@perches.com>
	 <20110825165006.af771ef7.akpm@linux-foundation.org>
	 <1314316801.19476.6.camel@Joe-Laptop>
	 <20110825170534.0d425c75.akpm@linux-foundation.org>
	 <1314319088.19476.17.camel@Joe-Laptop>
	 <20110825180734.9beae279.akpm@linux-foundation.org>
	 <1314327338.19476.30.camel@Joe-Laptop>
	 <20111011172208.GA3633@shutemov.name>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 20:22 +0300, Kirill A. Shutemov wrote:
> On Thu, Aug 25, 2011 at 07:55:37PM -0700, Joe Perches wrote:
> > Standardize the style for compiler based printf format verification.
> > Standardized the location of __printf too.
> > Done via script and a little typing.
> > $ grep -rPl --include=*.[ch] -w "__attribute__" * | \
> >   grep -vP "^(tools|scripts|include/linux/compiler-gcc.h)" | \
> >   xargs perl -n -i -e 'local $/; while (<>) { s/\b__attribute__\s*\(\s*\(\s*format\s*\(\s*printf\s*,\s*(.+)\s*,\s*(.+)\s*\)\s*\)\s*\)/__printf($1, $2)/g ; print; }'
> > Completely untested...
> This patch breaks ARCH=um (linux-next-20111011):

Hi Kirill, thanks for reporting this.

I think it breaks almost all the the arches with modifications.

> In file included from /home/kas/git/public/linux-next/arch/um/os-Linux/aio.c:17:0:
> /home/kas/git/public/linux-next/arch/um/include/shared/user.h:26:17: error: expected declaration specifiers or ‘...’ before numeric constant

Hey Andrew, I think _all_ of the arch/... changes
except arch/frv and arch/s390 should be reverted.

Andrew, I don't know if you saw this:
https://lkml.org/lkml/2011/9/28/324


