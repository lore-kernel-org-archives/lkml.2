Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab1BODe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 22:34:28 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48243 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1BODeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 22:34:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=dPZ32Xa+re+7ta0h/Sv6aGiYayIf/5uIa/wA5XsvHIRgcNL9OncjavT+qraWBVGjtv
         fMch6cjPEvX/fB4AA3ySO5Ez28Go8vt3QNWtTvGm2AYWDryA3asT2QLWlyFhq8jM3OLE
         3l/XFsNXJtWz3msfFyBFniZ49MVCuztdNAl0o=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <201102151030.26956.rusty@rustcorp.com.au>
References: <AANLkTimM1Tmws46DUyoNGsn+P8WN1XPsRu=L8yPzd=xU@mail.gmail.com>
	<AANLkTikO=5zBCvPbd2MXqgzE_mvnabTtH_e2C5_5bpQv@mail.gmail.com>
	<AANLkTinFOPc+BM8cnPE3SLt7Dc2TFOw1v+bntFu01hpO@mail.gmail.com>
	<201102151030.26956.rusty@rustcorp.com.au>
Date: Tue, 15 Feb 2011 04:34:24 +0100
Message-ID: <AANLkTi=NG+KTGh57oR6Ahq34PohdL5FQFsV+7=4a-J1Z@mail.gmail.com>
Subject: Re: [next-20110214] Kernel-modules with unknown parameter
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 1:00 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Mon, 14 Feb 2011 11:45:59 pm Sedat Dilek wrote:
>> >> Any idea what's going on? Stephen, Randy noticed the same like me?
>
> Dmitry broke module parameters with a "trivial" transform which turned out
> not to be.
>
> I wasn't paying enough attention, and let it through.
>
>> My damn brain can't understand - looking at the series file in [2] -
>> why the hell the "possible" patch [3] is not included in linux-next?
>
> There are markers in the series file, which indicate what goes into
> linux-next.
>
> Cheers,
> Rusty.
>

Thanks for the explanations, it makes things seen from the
patch-management side a bit clearer.
 ( Not sure if the series files was modified in the meantime. )

Here for documentation-purposes-only (partially extracted):

[ http://ozlabs.org/~rusty/kernel/rr-latest/series ]

# NEXT_PATCHES_START
# MM_PATCHES_START
# Trivial compilation fixes.


## for-linus
virtio:virtio-net-add_schedule_check_to_napi_enable_call.patch
## for-linus end
module:deal_with_alignment_issues_in_built_in_versions.patch
module:do_not_hide_modver_version_show_declaration_behind_ifdef.patch
virtio:blk_allow_re_reading_config_space_at_runtime.patch
# MM_PATCHES_END
# NEXT_PATCHES_END

[ / http://ozlabs.org/~rusty/kernel/rr-latest/series ]

So, I looked again into my own askings:

[ QUOTE ]
With this "evidence material" I "tig-ged" into the commits in my local
linux-next GIT repo, which revealed more:

2011-02-14 14:17 Stephen Rothwell   Merge branch 'quilt/rr'
*****
2011-02-11 10:37 Rusty Russell      module: deal with alignment issues
in built-in module parameters FIX
*****
2011-02-07 16:02 Dmitry Torokhov    module: deal with alignment issues
in built-in module parameters
2011-02-01 21:43 Christoph Hellwig  virtio_blk: allow re-reading
config space at runtime
2011-02-07 16:02 Dmitry Torokhov    module: do not hide
__modver_version_show declaration behind ifdef
2011-02-07 16:02 Dmitry Torokhov    module: deal with alignment issues
in built-in module versions
[ /QUOTE ]

Looks to me, the FIXUP patch marked with ***** was not really applied
to linux-next?
Also, this fixup patch is no more in Rusty's series file.
Is that all correct now?
As I confirmed with "module-fix-fallout-from-alignment.patch"
(aka	module:deal_with_alignment_issues_in_built_in_parameters.patch)
my world is OK.

- Sedat -
