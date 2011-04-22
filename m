Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab1DVBOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 21:14:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:41791 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755657Ab1DVBOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 21:14:40 -0400
Date: Fri, 22 Apr 2011 11:14:29 +1000
From: NeilBrown <neilb@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] raid5: fix build error, sector_t usage
Message-ID: <20110422111429.3437b69a@notabene.brown>
In-Reply-To: <20110421090726.fffd8a5f.randy.dunlap@oracle.com>
References: <20110421140109.GA16856@elte.hu>
	<20110421090726.fffd8a5f.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Apr 2011 09:07:26 -0700 Randy Dunlap <randy.dunlap@oracle.com>
wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Change <sectors> from unsigned long long to sector_t.
> This matches its source field.
> 
> ERROR: "__udivdi3" [drivers/md/raid456.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/md/raid5.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20110421.orig/drivers/md/raid5.c
> +++ linux-next-20110421/drivers/md/raid5.c
> @@ -5678,7 +5678,7 @@ static void raid5_quiesce(mddev_t *mddev
>  static void *raid45_takeover_raid0(mddev_t *mddev, int level)
>  {
>  	struct raid0_private_data *raid0_priv = mddev->private;
> -	unsigned long long sectors;
> +	sector_t sectors;
>  
>  	/* for raid0 takeover only one zone is supported */
>  	if (raid0_priv->nr_strip_zones > 1) {

Thanks Randy!

Linus:  You can either apply this patch directly or pull again from my
for-linus branch.

The following changes since commit 28a8397852011e323d16a1eecd4787d72b7b9a9e:

  md: Update documentation for sync_min and sync_max entries (2011-04-20 15:40:01 +1000)

are available in the git repository at:
  git://neil.brown.name/md/ for-linus

Randy Dunlap (1):
      raid5: fix build error, sector_t usage

 drivers/md/raid5.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


Thanks, and apologies,

NeilBrown
