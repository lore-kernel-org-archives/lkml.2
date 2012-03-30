Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933962Ab2C3TFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 15:05:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37176 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab2C3TF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 15:05:28 -0400
Date: Fri, 30 Mar 2012 20:05:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: Re: [PATCH 5/6] vfs: reorganize do_lookup
Message-ID: <20120330190526.GA29050@ZenIV.linux.org.uk>
References: <1332759264-23533-1-git-send-email-miklos@szeredi.hu>
 <1332759264-23533-6-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332759264-23533-6-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 12:54:23PM +0200, Miklos Szeredi wrote:
> This also eliminates the weird retry loop, that could, in theory, retry the
> cached lookup any number of times (very unlikely scenario: needs two parallel
> do_lookups and d_revalidate always returning zero).

That really needs to be carved into much smaller pieces - the sucker is
convoluted as hell and there's a lot of codepaths in there with nearly
zero test coverage.  I've split it up into provably equivalent
transformations, leading more or less to the state where yours ends up.
I _think_ I've reconstructed the sequence of changes more or less
close to what you were doing there, but the next time you have to do
something of that kind, do not collapse that into a single patch.  It's
really easier to review step by step...

Anyway, I'd put the whole thing into vfs.git#for-linus; see if you have
any problems with it.
