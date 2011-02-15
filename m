Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab1BOEgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 23:36:55 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64686 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab1BOEgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 23:36:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=j+hb/ddZt2P8r3PrU6eojjYFBhpYqapV4tKaUjPllhYjCGQII5+yWbVjiG9PYw5Hy+
         vells3ZK312C/BLzjA8j+cSKjoSEBY9RPyS8f+W4vivyqcfppGcIdJZM5Hb3+feWkyJh
         JJqNCjuGQDXtZia6FEsxOG1hBbOj/NKMo8QLA=
Date: Mon, 14 Feb 2011 20:36:45 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [next-20110214] Kernel-modules with unknown parameter
Message-ID: <20110215043645.GA4772@core.coreip.homeip.net>
References: <AANLkTimM1Tmws46DUyoNGsn+P8WN1XPsRu=L8yPzd=xU@mail.gmail.com>
 <AANLkTikO=5zBCvPbd2MXqgzE_mvnabTtH_e2C5_5bpQv@mail.gmail.com>
 <AANLkTinFOPc+BM8cnPE3SLt7Dc2TFOw1v+bntFu01hpO@mail.gmail.com>
 <201102151030.26956.rusty@rustcorp.com.au>
 <AANLkTi=NG+KTGh57oR6Ahq34PohdL5FQFsV+7=4a-J1Z@mail.gmail.com>
 <20110215145849.81116623.sfr@canb.auug.org.au>
 <AANLkTin1LV5yOH9C=dzftd=cvqOJH3+OMJOiLhwzVL29@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin1LV5yOH9C=dzftd=cvqOJH3+OMJOiLhwzVL29@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 05:14:24AM +0100, Sedat Dilek wrote:
> On Tue, Feb 15, 2011 at 4:58 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi Sedat,
> >
> > On Tue, 15 Feb 2011 04:34:24 +0100 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> >>
> >> On Tue, Feb 15, 2011 at 1:00 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> >> > On Mon, 14 Feb 2011 11:45:59 pm Sedat Dilek wrote:
> >> >> >> Any idea what's going on? Stephen, Randy noticed the same like me?
> >> >
> >> > Dmitry broke module parameters with a "trivial" transform which turned out
> >> > not to be.
> >> >
> >> > I wasn't paying enough attention, and let it through.
> >> >
> >> >> My damn brain can't understand - looking at the series file in [2] -
> >> >> why the hell the "possible" patch [3] is not included in linux-next?
> >> >
> >> > There are markers in the series file, which indicate what goes into
> >> > linux-next.
> >>
> >> Thanks for the explanations, it makes things seen from the
> >> patch-management side a bit clearer.
> >>  ( Not sure if the series files was modified in the meantime. )
> >>
> >> Here for documentation-purposes-only (partially extracted):
> >>
> >> [ http://ozlabs.org/~rusty/kernel/rr-latest/series ]
> >>
> >> # NEXT_PATCHES_START
> >> # MM_PATCHES_START
> >> # Trivial compilation fixes.
> >>
> >>
> >> ## for-linus
> >> virtio:virtio-net-add_schedule_check_to_napi_enable_call.patch
> >> ## for-linus end
> >> module:deal_with_alignment_issues_in_built_in_versions.patch
> >> module:do_not_hide_modver_version_show_declaration_behind_ifdef.patch
> >> virtio:blk_allow_re_reading_config_space_at_runtime.patch
> >> # MM_PATCHES_END
> >> # NEXT_PATCHES_END
> >>
> >> [ / http://ozlabs.org/~rusty/kernel/rr-latest/series ]
> >
> > That is how it looks today.  Yesterday, the patch
> > module:deal_with_alignment_issues_in_built_in_parameters.patch
> > was also included and that is what caused the problem.
> >
> >> Looks to me, the FIXUP patch marked with ***** was not really applied
> >> to linux-next?
> >
> > No, instead the breaking patch (above) was removed from Rusty's
> > linux-next series today.
> >
> >> Also, this fixup patch is no more in Rusty's series file.
> >> Is that all correct now?
> >
> > Rusty has a new version of the above patch which includes the fix (I
> > assume) but it is not included in linux-next today.
> >
> > --
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au
> > http://www.canb.auug.org.au/~sfr/
> >
> 
> Hmm, would be nice to have a clarification or a confirmation after
> compilation and kernel-modules are loaded correctly on i386 (amd64)
> arch(s).

As it was proven that the change was a bit *ahem* involved it is
probably better for the updated patch (even though I am pretty sure it
is good now) to cook a bit more outside of next so Rusty removed it.

Thanks.

-- 
Dmitry
