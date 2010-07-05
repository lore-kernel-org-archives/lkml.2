Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab0GEOCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 10:02:51 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:3176 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578Ab0GEOCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 10:02:50 -0400
Date: Mon, 5 Jul 2010 10:00:08 -0400
From: me@bobcopeland.com
To: Davidlohr Bueso <dave.bueso@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-karma-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-karma-devel] [PATCH] omfs: fix memory leak
Message-ID: <20100705140008.GA3378@hash.localnet>
References: <1278210828.27014.2.camel@cowboy> <20100704113711.GA15067@hash.localnet> <1278306759.3811.24.camel@cowboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278306759.3811.24.camel@cowboy>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 01:12:39AM -0400, Davidlohr Bueso wrote:
> Isn't put_super() called to free data when things run "normally", like
> for unmounting? So this function does two things:

Ok, I checked it out and you are right, FS put_super is only called
after successful mount so there is a leak.  I'll take your patch,
but please:

 - remove the /* success */ comment, IMO it's just noise
 - write the if conditional as the more usual:

        if (ret)

> kfree(sbi->s_imap)
> kfree(sbi)
> 
> However, in omfs_get_imap() 'sbi->s_imap' is freed upon failure, so
> wouldn't this also crash on the first kfree in omfs_put_super()?

This is ok, since sbi->s_imap is set to null in that case and
kfree(NULL) is fine.

Thanks for the review!
 
-- 
Bob Copeland %% www.bobcopeland.com

