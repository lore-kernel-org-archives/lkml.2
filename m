Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab2DGAwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 20:52:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48630 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab2DGAwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 20:52:13 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy_TOEE-8RNmNKVz6xZ7s+f02jCVcDbA=MJY1iih=AJpg@mail.gmail.com>
References: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org> <CA+55aFy_TOEE-8RNmNKVz6xZ7s+f02jCVcDbA=MJY1iih=AJpg@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Fri, 6 Apr 2012 17:51:51 -0700
X-Google-Sender-Auth: Aj0r_l0fktMHLOISyBOHCNDwfzo
Message-ID: <CAB=NE6Xt3yeCvW-t7mbEWoYr04Rg1uvObAMTatAdpHtgsdZvYA@mail.gmail.com>
Subject: Re: [PATCH] module: Clarify GPL-Compatible is OK
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Keith Packard <keithp@keithp.com>, Ralf Baechle <ralf@linux-mips.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 5:36 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Apr 6, 2012 at 5:11 PM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
>> -MODULE_LICENSE("Dual BSD/GPL");
>> +MODULE_LICENSE("GPL-Compatible");
>
> I really don't see the point.
>
> This makes things *worse*.
>
> "Dual BSD/GPL" actually tells you something: it tells you that you can
> take that code, and use it in a BSD project.
>
> In contrast "GPL-compatible" tells you nothing at all.
>
> So you are actually removing real information, and just making things
> harder for everybody.

Its a good point that we are not declaring the exact license used for
software, and while that is useful the "Dual BSD/GPL" tag is
misleading. As I see it there are four options:

1) Use this as a technical artifact only to ensure symbols we declare
EXPORT_SYMBOL_GPL() will only be used by GPL-Compatible modules. Also
use the GPL-Compatible tag as annotated by this patch to annotate
this. Then add another tag to specific the exact license, which is not
anything of an artifact but just informational to the binary module
but also software developer reviewing code. This last part would
clarify the exact license.

2) We keep extending the list of MODULE_LICENSE() with all the
different GPL-Compatible licenses we are comfortable with. This list
is pretty outdated already. This means we keep chugging along and
adding more licenses.

3) Leave things as is, and clarify this. I think this confuses
developers though, and for sharing purposes it would be nice. Hence
the patch. You have no idea how many e-mails I have had to deal with
to address this. People really think this is impossible. In fact we
had a flamewar eons ago because a few of us didn't know this was
possible to help the BSDs. Not just developers, I think there are even
maintainers not too sure about this.

4) Use the patch and leave it to the person who wants to extract code
to figure out the exact module license.

Option 1) seems to me to provide the best alternative but leaves open
then the question of whether or not we need to keep tabs of accepted
GPLv2 compatible licenses we accept or leave this as informational.
Option 4) handles the technical artifacts we care about but gives some
homework to consumers.

Please let me know if anyone can think of better alternatives.

  Luis
