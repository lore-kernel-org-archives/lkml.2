Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1ETMns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 08:43:48 -0400
Received: from adelie.canonical.com ([91.189.90.139]:39495 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab1ETMnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 08:43:46 -0400
Date: Fri, 20 May 2011 13:43:39 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: NeilBrown <neilb@suse.de>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, nbd@openwrt.org, hramrach@centrum.cz,
        jordipujolp@gmail.com
Subject: Re: [PATCH 0/7] overlay filesystem v9
Message-ID: <20110520124339.GS3702@shadowen.org>
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
 <20110519163709.GH3702@shadowen.org>
 <87sjsak2jt.fsf@tucsk.pomaz.szeredi.hu>
 <20110519180558.GJ3702@shadowen.org>
 <20110520081226.0787e2dd@notabene.brown>
 <87ipt5vl7t.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ipt5vl7t.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 10:18:30AM +0200, Miklos Szeredi wrote:

> Yeah, it should probably do something like:
> 
> 	if (inode->i_op->getattr) {
> 		struct kstat stat;
> 		inode->i_op->getattr(...)
> 		uid = stat.uid;
> 	} else {
> 		uid = inode->i_uid;
> 	}
> 
> The problem is that getattr takes a vfsmount, which makes this
> impossible to do cleanly.  And the solution is for ->getattr() to lose
> that argument, which is a bit more involved :(

Ok.  I am going to take this as a bug in the LSM, so ignore my patch
here.  I have been poking at what the LSM is doing and actually I think
I see the flaw, so I will take the issue up with them.

In light of that take this as a "tested heavily and it worked without
issues" on the V9 version.

Tested-by: Andy Whitcroft <apw@canonical.com>

-apw
