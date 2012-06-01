Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179Ab2FARxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 13:53:44 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62079 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759892Ab2FARxl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 13:53:41 -0400
MIME-Version: 1.0
In-Reply-To: <4FC8E00E.60600@gmail.com>
References: <CA+i8gKK5VJU_0YbBkeav6wTP+5YGp-rd52dTNqyoprz_YZrepA@mail.gmail.com>
 <4FC8E00E.60600@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Jun 2012 10:53:20 -0700
X-Google-Sender-Auth: ifpLUx2avhMg189q7IReGg2RBZM
Message-ID: <CA+55aFyK_m8aO57gC4Q1PJXmY3e1-uRXQ3E6PRgdBVixJSa2gQ@mail.gmail.com>
Subject: Re: 71ca97da9d overrides user's kernel config
To: =?ISO-8859-7?Q?Vladimir_=27=F6=2Dcoder=2Fphcoder=27_Serbinenko?= 
	<phcoder@gmail.com>
Cc: Emmanuel Benisty <benisty.e@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 1, 2012 at 8:30 AM, Vladimir 'ö-coder/phcoder' Serbinenko
<phcoder@gmail.com> wrote:
>
> Sorry, it wasn't intentional. It was just a stub to compile it without
> recompiling whole kernel. Should I supply the patch to remove it?

Yes, but I wonder if they should *also* be renamed, actually.

Those names are disgusting and unreadable, because the "MAC" part
mixes with the actual name of the codepage. I really have a hard time
reading something like MACROMANIAN, because to me it looks like it
starts with "MACRO". It's just a bad name.

Also, the CODEPAGE part adds questionable value. I wonder if we should
(a) remove the CODEPAGE part, (b) add an underscore between "MAC" and
the name, and for the microsoft numeric codepages, do the same just to
be consistent. IOW, use config names like NLS_DOS_1250 and
NLS_MAC_ROMANIAN?

(Yes, yes, I realize that people think that 1250 is a "windows"
codepage, not a DOS codepage. Use WIN_1250 if you want to, but I think
it's all really the same.)

I dunno. But start with the Mac ones first, since they need fixing
anyway. Leave the old ones alone for now.

Andrew, who would be in charge of "fs/nls"? Almost nobody has really
touched that area in several years now, and it doesn't have any
maintainership. Added the few poor sods that touched it last. "Tag,
guys, you're it!"

                 Linus
