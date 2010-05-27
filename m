Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566Ab0E0KVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 06:21:18 -0400
Received: from smtp.nokia.com ([192.100.105.134]:62460 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336Ab0E0KVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 06:21:16 -0400
Subject: Re: [PATCHv4 17/17] writeback: lessen sync_supers wakeup count
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20100527065041.GA31073@ZenIV.linux.org.uk>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
	 <1274795352-3551-18-git-send-email-dedekind1@gmail.com>
	 <20100527065041.GA31073@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 13:19:03 +0300
Message-ID: <1274955543.32558.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 May 2010 10:20:34.0636 (UTC) FILETIME=[3E5010C0:01CAFD86]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 07:50 +0100, Al Viro wrote:
> On Tue, May 25, 2010 at 04:49:12PM +0300, Artem Bityutskiy wrote:
> > From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> > +void mark_sb_dirty(struct super_block *sb)
> > +{
> > +	sb->s_dirty = 1;
> > +
> > +	spin_lock(&supers_timer_lock);
> > +	if (!supers_timer_armed) {
> > +		bdi_arm_supers_timer();
> > +		supers_timer_armed = 1;
> > +	} else if (supers_timer_armed == -1)
> > +		supers_timer_armed = 1;
> > +	spin_unlock(&supers_timer_lock);
> > +}
> > +EXPORT_SYMBOL(mark_sb_dirty);
> 
> Ouch...   That turns a previously trivial operation into something
> much heavier; moreover, I'd rather see serious review of s_dirt
> uses.

OK, I'll try to do something lighter with atomic variables or something
like Nick posted - need to think about this. And I'll try to review
s_dirty usage as much as my time and knowledge allow. Thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

