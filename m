Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab0HQC76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 22:59:58 -0400
Received: from ozlabs.org ([203.10.76.45]:34752 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765Ab0HQC74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 22:59:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the wireless tree with Linus' tree
Date: Tue, 17 Aug 2010 12:29:44 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
        libertas-dev@lists.infradead.org, netdev@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
References: <20100817115203.e8a76e44.sfr@canb.auug.org.au>
In-Reply-To: <20100817115203.e8a76e44.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008171229.46175.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010 11:22:03 am Stephen Rothwell wrote:
> Hi John,
> 
> Today's linux-next merge of the wireless tree got a conflict in
> drivers/net/wireless/libertas/if_sdio.c between commit
> 886275ce41a9751117367fb387ed171049eb6148 ("param: lock if_sdio's
> lbs_helper_name and lbs_fw_name against sysfs changes") from Linus' tree
> and commit 3d32a58b87cd251b50842f93b87d5458061c0cfc ("libertas: [sdio]
> use common firmware request helper and new firmware locations") from the
> wireless tree.
> 
> OK, I can't quite figure out what is going on here.  The latter commit
> removes that code that was modified by the former, so I effectively
> reverted the former commit (by using this file from the wireless tree)
> since the "helper" and "firmware" fields of struct if_sdio_card don't
> seem to be used anywhere anymore.  Can they be removed as well?

I'm looking at the wireless tree now.

You can drop the commit as you have done.  But it leaves three problematic
writable charp parameters in the libertas/ directory which now need lifetime
management.

ie. kparam_block_sysfs_write()/unblock around them, and probably they need
to be copied.

Cheers,
Rusty.



