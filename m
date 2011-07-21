Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab1GUV4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:56:53 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:59676 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750799Ab1GUV4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 17:56:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hlu0b6zXy6ebn1QyXqwetwmdbg1e3fbyt1+qK+R00EV8mNNKNJp8GAhcxqn5qqB4SngfP6OZiqNmg/VIOcA1ZnaTrLXeRtXf/xwvcC9+uZcfUz8+oQw3nOWhZtEAvMhw;
Date: Thu, 21 Jul 2011 14:56:48 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Neil Brown <neilb@suse.de>,
        linux-raid@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        dm-devel@redhat.com
Subject: Re: linux-next: Tree for July 21 (drivers/md/dm-raid)
Message-Id: <20110721145648.2477f8bb.rdunlap@xenotime.net>
In-Reply-To: <20110721165542.7748c88a1d1e0b228c7fe3fa@canb.auug.org.au>
References: <20110721165542.7748c88a1d1e0b228c7fe3fa@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011 16:55:42 +1000 Stephen Rothwell wrote:

> Hi all,

When CONFIG_DM_RAID=m and CONFIG_MD_RAID1 is not enabled:

ERROR: "md_raid1_congested" [drivers/md/dm-raid.ko] undefined!

due to:

	if (rs->raid_type->level == 1)
		return md_raid1_congested(&rs->md, bits);

Should that just be surrounded with this?

#if defined(CONFIG_MD_RAID1) || defined(CONFIG_MD_RAID1_MODULE)
...
#endif

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
