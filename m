Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab0GVIBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 04:01:54 -0400
Received: from smtp.nokia.com ([192.100.122.230]:61800 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab0GVIBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 04:01:52 -0400
Subject: Re: [PATCHv6 0/9] kill unnecessary SB sync wake-ups + cleanups
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
In-Reply-To: <1278332107-11443-1-git-send-email-dedekind1@gmail.com>
References: <1278332107-11443-1-git-send-email-dedekind1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 10:54:40 +0300
Message-ID: <1279785280.3044.30.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Jul 2010 08:01:25.0110 (UTC) FILETIME=[14BD8160:01CB2974]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-05 at 15:14 +0300, Artem Bityutskiy wrote:
> here is v6 of my SB sync wakups killing patches, v5 may be found:
> http://marc.info/?l=linux-fsdevel&m=127583599911620&w=2
> 
> This is more of a reminder re-send, I did not get any feed-back for
> v5. Not much changes since v5:
> 
> 1. Drop patches which fix race conditions for s_dirty changes WRT actual
>    write-back - these things are independent and I am planning to go through
>    that separately.
> 2. Add "Acked-by" to the btrfs patch.
> 3. Fold all per-fs patches which introduce SB accessors into one big patch.

Hi Al,

you "unofficially" told me that you want to get rid of '->write_super()'
and 'sync_supers()' should not exist. And FSes which really need
'->write_super()' should implement that themselves.

I will try to work on this, but a bit later, after my holidays. But
could you please:

1. confirm that you want to kill '->write_super()' and '->s_dirt'
   "officially", so that I could refer to this when sending patches

2. pick up patches 1-6 from this series, this would make my life easier
   a bit.

I'm not sure then what do do with:

commit 140236b4b1c749c9b795ea3d11558a0eb5a3a080
Author: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date:   Thu Jun 10 13:56:33 2010 +0300

    VFS: introduce s_dirty accessors

which Linus merged, but which is now not needed, since you now want me
to kill '->write_super()' completely. Will you take care of this please?

Thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

