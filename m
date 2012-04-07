Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab2DGDB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 23:01:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46448 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab2DGDB5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 23:01:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120407024941.GB11295@thunk.org>
References: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
 <CA+55aFy_TOEE-8RNmNKVz6xZ7s+f02jCVcDbA=MJY1iih=AJpg@mail.gmail.com>
 <CAB=NE6Xt3yeCvW-t7mbEWoYr04Rg1uvObAMTatAdpHtgsdZvYA@mail.gmail.com> <20120407024941.GB11295@thunk.org>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Fri, 6 Apr 2012 20:01:36 -0700
X-Google-Sender-Auth: qtqh1mpYfLeiSld69Efx_Rxkrl4
Message-ID: <CAB=NE6Wn4w_rmm-9dTjeLCmFBwFUv_R+o05=UW1SODBN2hFH0w@mail.gmail.com>
Subject: Re: [PATCH] module: Clarify GPL-Compatible is OK
To: "Ted Ts'o" <tytso@mit.edu>, "Luis R. Rodriguez" <mcgrof@frijolero.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 7:49 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Apr 06, 2012 at 05:51:51PM -0700, Luis R. Rodriguez wrote:
>>
>> Its a good point that we are not declaring the exact license used for
>> software, and while that is useful the "Dual BSD/GPL" tag is
>> misleading. As I see it there are four options:
>
> So the real question is what is the purpose of MODULE_LICENSE()?
> Specifically, is it intended for anything other than to tell the that
> this module is OK to use EXPORT_SYMBOL_GPL symbols?

At this point that's the only thing this could be used for reliably.

> Your patch which changes things like
>
> MODULE_LICENSE("Dual BSD/GPL");
>
> to
>
> MODULE_LICENSE("GPL-Compatible");
>
> in my opinion, muddles things even more, since now in some cases
> MODULE_LICENSE() will name a specific license (i.e., GPL), and in
> other cases, a set of licenses (i.e., GPL-Compatible).

Another good point.

> After all,
> isn't a GPL license by definition GPL-compatible?

:) Yeah

> So why not change *all* MODULE_LICENSE(GPL) statements to be  MODULE_LICENSE(GPL-Compatible)?

This is obviously ridiculous, I hope I'm clarifying there is something
confusing that is in fact not ridiculous though.

> If that seems like a large, pointless patch, then maybe it's not worth it
> to change "Dual BSD/GPL" to "GPL-Compatible".

The fact that the extreme example you provide follows the logic does
not entail that the issue I am stating is pointless.

> I also really don't see how this helps License compliance folks.  If
> the BSD folks trying to figure out whether or not they can use some
> piece of code, "GPL-Compatible" is no more useful than as "Dual
> BSD/GPL".  In fact, Dual BSD/GPL might actually be more useful since
> at least to me it says it can be used under the BSD or GPL license,
> which is precisely what the BSD folks need.

If we are OK with this thread serving as documentation for this then
so be it, but I still prefer for this to be clarified more. *I* am
comfortable with this but I know other vendors who did try to achieve
the same sharing had quite a bit of time trying to validate the
approach. I rather speed help clarify this is a reasonable approach
and also avoid flamewars like the ones we faced when developers eons
ago though that we *had* to GPL the OpenBSD ar5k HAL when we ported it
to Linux for use in ath5k.

  Luis
