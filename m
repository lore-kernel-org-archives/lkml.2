Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab1KOWyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 17:54:41 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60286 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756800Ab1KOWyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 17:54:39 -0500
X-Sasl-enc: k428GTXsXLnoaSZf6TWdg39ZCa3HegiJ51YmEpQUxCP2 1321397678
Date: Tue, 15 Nov 2011 14:54:08 -0800
From: Greg KH <greg@kroah.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>,
        Neil Horman <nhorman@redhat.com>, Steve Dickson <steved@redhat.com>,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH] KEYS: Fix a NULL pointer deref in the user-defined key
 type
Message-ID: <20111115225408.GA31763@kroah.com>
References: <20111115220945.18768.20275.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115220945.18768.20275.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 10:09:45PM +0000, David Howells wrote:
> Fix a NULL pointer deref in the user-defined key type whereby updating a
> negative key into a fully instantiated key will cause an oops to occur when the
> code attempts to free the non-existent old payload.
> 
> This results in an oops that looks something like the following:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> IP: [<ffffffff81085fa1>] __call_rcu+0x11/0x13e
> PGD 3391d067 PUD 3894a067 PMD 0
> Oops: 0002 [#1] SMP
> CPU 1
> Modules linked in:
> 
> Pid: 4354, comm: keyctl Not tainted 3.1.0-fsdevel+ #1140                  /DG965RY

Ah, so this patch should also go into the 3.1-stable tree?  Any older
ones as welL?

thanks,

greg k-h
