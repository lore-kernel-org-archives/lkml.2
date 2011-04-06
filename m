Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab1DFKG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 06:06:27 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64880 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab1DFKGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 06:06:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AqaMe3B89kDlZ8NKcHbmiQXl/LEOnRfSDyxrIWBGgQeYMaCDxf+JOZp4v8/39nRinN
         w7+JbxHzXKGauUD7mwm7NYs5wu7A/gpRZ2db43dCxOwlUO9Cs/W1UXr4IyGJgldBLu0g
         p8s81yZ+BTgUBcrvk43CfI0GOBF/JUW0vtWtk=
Date: Wed, 6 Apr 2011 03:06:20 -0700
From: Tejun Heo <tj@kernel.org>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, Markus Armbruster <armbru@redhat.com>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: [PATCH] sr: Ensure disk is revalidated when media changes
Message-ID: <20110406100620.GA4142@mtj.dyndns.org>
References: <8d830b21c0b944d26f29dc1e0c42c0bef8d448c2.1301595169.git.amit.shah@redhat.com>
 <20110401154327.GA6593@mtj.dyndns.org>
 <20110405065129.GC2872@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110405065129.GC2872@amit-x200.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 12:21:30PM +0530, Amit Shah wrote:
> > But I don't think this is the correct place to do it.  The problem
> > happens because block layer consumes the event but doesn't remember it
> > when the time for revalidation comes.  It should be done by block
> > layer, not sr.  Hmmm... looking at the code, the new disk event code
> > should handle this correctly.  Was 2.6.38 showing the problem too?
> 
> Yes, 2.6.38 shows the same problem.  I went back to ancient kernels
> (2.6.31 on Fedora 11-alpha) which had the previous media_changed
> infrastructure and those places too show the same behaviour (with the
> TEST_UNIT_READY way of detecting media changes).

Can you please the patch attached in the following bz and see whether
it makes any difference?

 https://bugzilla.kernel.org/show_bug.cgi?id=13029

Thanks.

-- 
tejun
