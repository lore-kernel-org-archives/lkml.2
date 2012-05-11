Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991Ab2EKU3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 16:29:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39839 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab2EKU3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 16:29:53 -0400
Date: Fri, 11 May 2012 13:29:49 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, tejun@google.com,
        agk@redhat.com, Martin Peterson <mkp@mkp.net>
Subject: Re: [dm-devel] [Bcache v13 01/16] Only clone bio vecs that are in use
Message-ID: <20120511202949.GB26298@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <cb817596299fecd01ea36e4a80203f23165bda75.1336619038.git.koverstreet@google.com>
 <20120510213556.GO23768@redhat.com>
 <CAH+dOxJ2Vi=8Oq1zDZLmqD9-a_wgM=co3+xemw4XBoiDkh_4zg@mail.gmail.com>
 <x494nrmx2ux.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <x494nrmx2ux.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 09:29:42AM -0400, Jeff Moyer wrote:
> 
> [top posting fixed]
> 
> Kent Overstreet <koverstreet@google.com> writes:
> 
> > 2012/5/10 Vivek Goyal <vgoyal@redhat.com>:
> >> On Wed, May 09, 2012 at 11:08:13PM -0400, Kent Overstreet wrote:
> >>
> >> [..]
> >>> -
> >>> -     if (bio_integrity(bio)) {
> >>> -             bio_integrity_clone(clone, bio, GFP_NOIO, bs);
> >>> -
> >>> +#if 0
> >>> +     if (bio_integrity(bio))
> >>>               if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
> >>>                       bio_integrity_trim(clone,
> >>>                                          bio_sector_offset(bio, idx, 0), len);
> >>> -     }
> >>> -
> >>> +#endif
> >>
> >> Dead/debug code under "#if 0" ?
> >>
> > Oh, I never got around to figuring out what needed to be done with the
> > bio integrity - presumably it'll have to be handled differently
> > somehow (I'm assuming an index in the integrity bvec is intended to
> > match up with an index in the regular bvec), but I don't have any way
> > to test the integrity stuff.
> 
> The scsi debug module supports dif/dix, so you can use that for testing.

Thanks, I'll try that.
