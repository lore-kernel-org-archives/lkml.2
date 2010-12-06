Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab0LFPin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:38:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab0LFPim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:38:42 -0500
Date: Mon, 6 Dec 2010 10:38:36 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Bernhard Walle <bernhard@bwalle.de>
Cc: Jeff Layton <jlayton@samba.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Add information about noserverino
Message-ID: <20101206103836.0714369a@tlielax.poochiereds.net>
In-Reply-To: <20101206163506.56232lqqhc5c3co4@webmail.df.eu>
References: <1291568855-22604-1-git-send-email-bernhard@bwalle.de>
	<20101206095725.78422138@tlielax.poochiereds.net>
	<20101206101214.52a24415@tlielax.poochiereds.net>
	<20101206163506.56232lqqhc5c3co4@webmail.df.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Dec 2010 16:35:06 +0100
Bernhard Walle <bernhard@bwalle.de> wrote:

> 
> Zitat von Jeff Layton <jlayton@redhat.com>:
> 
> >
> > I'm still not sure I like this patch however. It potentially means a
> > lot of printk spam since these things have no ratelimiting. It also
> > doesn't tell me anything about which server might be giving me grief.
> >
> > Maybe this should be turned into a cFYI?
> 
> Well, if I see it in the kernel log, it doesn't matter if it's info or
> something else.
> 
> > The bottom line though is that running 32-bit applications that were
> > built without -D_FILE_OFFSET_BITS=64 on a 64-bit kernel is a very bad
> > idea. It would be nice to be able to alert users that things aren't
> > working the way they expect, but I'm not sure this is the right place
> > to do that.
> 
> Well, but there *are* such application (in my case it was Softmaker Office
> which is a proprietary word processor) and it's quite nice if you know
> how you can workaround it when you encounter such a problem. That's all.
> 

Sure...but this problem is not limited to CIFS. Many modern filesystems
use 64-bit inodes. Running this application on XFS or NFS for instance
is likely to give you the same trouble. You just hit it on CIFS because
the server happened to give you a very large inode number.

If we're going to add printk's for this situation, it probably ought to
be in a more generic place.

-- 
Jeff Layton <jlayton@redhat.com>
