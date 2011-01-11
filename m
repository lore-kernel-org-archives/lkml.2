Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab1AKNdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 08:33:18 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:48663 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753540Ab1AKNdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 08:33:16 -0500
Date: Tue, 11 Jan 2011 14:33:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: yangsheng <sickamd@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Update atime from future.
Message-ID: <20110111133314.GA10705@atrey.karlin.mff.cuni.cz>
References: <1293631121-12667-1-git-send-email-sickamd@gmail.com> <1294050468.2429.2.camel@dolmen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294050468.2429.2.camel@dolmen>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	return 1;
> > +	/*
> > +	 * Is the previous atime value old than a day? If yes,
> >  	 * update atime:
> >  	 */
> >  	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= 24*60*60)
> 
> I don't think this is a good plan for cluster filesystems, since if the
> times on the nodes are not exactly synchronised (we do highly recommend
> people run ntp or similar) then this might lead to excessive atime
> updating. The current behaviour is to ignore atimes which are in the
> future for exactly this reason,

Well, would these "update storms" really be a problem?

AFAICT they should be fairly non-frequent, and worst thing that can
happen is that you'll do as many updates as different time settings,
settling for the lowest value...?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
