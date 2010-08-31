Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab0HaLA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 07:00:58 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38009 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886Ab0HaLA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 07:00:57 -0400
To: Neil Brown <neilb@suse.de>
CC: vaurora@redhat.com, miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, jblunck@suse.de,
        hch@infradead.org
In-reply-to: <20100831091211.403e0d06@notabene> (message from Neil Brown on
	Tue, 31 Aug 2010 09:12:11 +1000)
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
References: <20100826183340.027591901@szeredi.hu>
	<20100827170551.19616048@notabene>
	<E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu>
	<20100827213502.31af4a4c@notabene>
	<20100830183843.GB2444@shell> <20100831091211.403e0d06@notabene>
Message-Id: <E1OqOa5-000677-BN@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 31 Aug 2010 13:00:45 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Aug 2010, Neil Brown wrote:
> So: is this a problem?  It may seem a bit confusing to someone who doesn't
> understand what is happening, but we define that as not being a problem (to
> avoid confusion: don't change U or L).
> The important questions are:  Can it cause corruption, and can it cause a
> deadlock?

No, I don't think this design will do that.  So it might be enough
just to document that online modification of upper or lower
filesystems results in undefined behavior.

But to prevent accidental damage, it's prudent (at least by default)
to enforce the no-modification policy.

Why do you think this feature of allowing modification is important?
Lets take some typical use cases:

 - live cd: lower layer is hard r/o, upper layer makes no sense to
   modify online

 - thin client: lower layer is static except upgrades, which need
   special tools to support and is done offline, upper layer makes no
   sense to modify online

Do you have some cases in mind where it makes at least a little sense
to allow online modification of the underlying filesystems?

Thanks,
Miklos
