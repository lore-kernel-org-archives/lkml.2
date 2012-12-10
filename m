Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab2LJM14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 07:27:56 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:37851 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab2LJM1z (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 10 Dec 2012 07:27:55 -0500
Date: Mon, 10 Dec 2012 20:27:35 +0800
From: Guangliang Zhao <gzhao@suse.com>
To: device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 0/3] add resync speed control for dm-raid1
Message-ID: <20121210122735.GB2310@glzhao-laptop.site>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	linux-kernel@vger.kernel.org
References: <1353565673-4233-1-git-send-email-gzhao@suse.com>
 <20121210132123.5a4ab015@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121210132123.5a4ab015@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 01:21:23PM +1100, NeilBrown wrote:
> On Thu, 22 Nov 2012 14:27:50 +0800 Guangliang Zhao <gzhao@suse.com> wrote:
> 
> > Hi,
> > 
> > These patches are used to add resync speed control for dm-raid1. The
> > second and third patch provide support for user-space tool dmsetup.
> > 
> > Guangliang Zhao (3):
> >   dm raid1: add resync speed control for dm-raid1
> >   dm raid1: add interface to set resync speed
> >   dm raid1: add interface to get resync speed
> > 
> >  drivers/md/dm-raid1.c |   93 +++++++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 90 insertions(+), 3 deletions(-)
> > 
> 
> The problem with this approach is that it slows down resync even when there
> is no other IO happening.
> If that is deemed to be acceptable, then the patch set seems fine, though I
> would probably make the default a lot higher so as not to change current
> default behaviour for anyone.
Yes, the users who don't need this feature will not be affected, fully
accepted.

> 
> If it isn't acceptable, then you either need to monitor the number of
> requests going to the underlying devices - like md does - or monitor the
> number of requests coming in to the dm-raid1 target - which is probably
> easier with dm.
> 
> i.e. only impose the rate limit if there have been any requests for the
> dm-raid1 target in the last 'RESYNC_JIFFIES'.
Good idea, that's would be on my TODO list. But anyway these patches are
still required.

> 
> What do you think of that?
> 
> NeilBrown



> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


-- 
Best regards,
Guangliang
