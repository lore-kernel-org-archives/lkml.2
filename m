Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab0HDTuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 15:50:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873Ab0HDTui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 15:50:38 -0400
Date: Wed, 4 Aug 2010 15:50:08 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 21/38] union-mount: Support for mounting union mount file systems
Message-ID: <20100804195008.GB2134@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-22-git-send-email-vaurora@redhat.com> <E1OgfNb-0000ok-7p@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1OgfNb-0000ok-7p@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 04:55:39PM +0200, Miklos Szeredi wrote:
> On Tue, 15 Jun 2010, Valerie Aurora wrote:
> > Create and tear down union mount structures on mount.  Check
> > requirements for union mounts.  This version clones the read-only
> > mounts and puts them in an array hanging off the superblock of the
> > topmost layer.
> 
> If I do
> 
>   mount -r fs1 /mnt
>   mount -r fs2 /mnt
>   mount -ounion fs3 /mnt
> 
> then only fs2 and fs3 will be unioned.
> 
> Or how are multiple read-only layers supposed to work?

You have it right, this is a bug in lookup in the last version I sent
out.  I had commented out the part of my test suite that actually
tested three layer mounts so I didn't notice when I broke it. :/ I'll
post a new version with the fix today.

-VAL
