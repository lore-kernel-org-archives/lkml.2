Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab0EVNyW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 09:54:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab0EVNyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 09:54:19 -0400
Date: Sat, 22 May 2010 10:02:17 -0400
From: Josef Bacik <josef@redhat.com>
To: Mike Fedyk <mfedyk@mikefedyk.com>
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org
Subject: Re: [PATCH 3/6] direct-io: do not merge logically non-contiguous
	requests
Message-ID: <20100522140217.GS32248@dhcp231-156.rdu.redhat.com>
References: <1274461422-18433-1-git-send-email-josef@redhat.com> <1274461422-18433-3-git-send-email-josef@redhat.com> <AANLkTikwPL8-WefVIMF1ldTZpWVHvS1Lbh4YB8MZ4eu0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikwPL8-WefVIMF1ldTZpWVHvS1Lbh4YB8MZ4eu0@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 06:47:36PM -0700, Mike Fedyk wrote:
> On Fri, May 21, 2010 at 10:03 AM, Josef Bacik <josef@redhat.com> wrote:
> > Btrfs cannot handle having logically non-contiguous requests submitted.  For
> > example if you have
> >
> > Logical:  [0-4095][HOLE][8192-12287]
> > Physical: [0-4095]      [4096-8191]
> >
> > Normally the DIO code would put these into the same BIO's.  The problem is we
> > need to know exactly what offset is associated with what BIO so we can do our
> > checksumming and unlocking properly, so putting them in the same BIO doesn't
> > work.  So add another check where we submit the current BIO if the physical
> > blocks are not contigous OR the logical blocks are not contiguous.
> >
> > Signed-off-by: Josef Bacik <josef@redhat.com>
> > ---
> >
> > V1->V2
> > -Be more verbose in the in-code comment
> >
> >  fs/direct-io.c |   20 ++++++++++++++++++--
> >  1 files changed, 18 insertions(+), 2 deletions(-)
> >
> 
> Btrfs has been pretty much self-contained (working well compiled
> against 2.6.32 for example).  Is there a way that this wouldn't just
> start silently breaking for people compiling the latest btrfs with
> dkms against older kernels?

Nope, you have to have these generic patches for DIO to work, so building btrfs
like this will stop working with earlier kernels.  Thanks,

Josef
