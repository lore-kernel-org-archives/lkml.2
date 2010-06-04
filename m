Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab0FDFRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 01:17:15 -0400
Received: from smtp.nokia.com ([192.100.122.230]:29724 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab0FDFRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 01:17:13 -0400
Subject: Re: [PATCHv4 17/17] writeback: lessen sync_supers wakeup count
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20100604042606.GA31073@ZenIV.linux.org.uk>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
	 <1274795352-3551-18-git-send-email-dedekind1@gmail.com>
	 <20100527065041.GA31073@ZenIV.linux.org.uk>
	 <1275314820.2678.153.camel@localhost>
	 <20100604042606.GA31073@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Jun 2010 08:13:34 +0300
Message-ID: <1275628414.25847.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-6.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 04 Jun 2010 05:15:40.0230 (UTC) FILETIME=[F94D3E60:01CB03A4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 05:26 +0100, Al Viro wrote:
> I suspect that most of those used to rely on lock_super() way back.
> In case of ext2_sync_super() we probably want just to move ->s_dirt = 0
> into the very beginning; no serialization is really needed beyond (_maybe_)
> some barriers.  No idea about affs, needs to be checked.

Yeah, moving s_dirt to the beginning should work. I think the same
should be done for affs. I'll look at other FS-es WRT this as well.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

