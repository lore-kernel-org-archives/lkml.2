Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966146Ab0GPUNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 16:13:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759208Ab0GPUNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 16:13:16 -0400
Date: Fri, 16 Jul 2010 16:12:58 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/38] whiteout: Set S_OPAQUE inode flag when creating directories
Message-ID: <20100716201258.GB21201@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-8-git-send-email-vaurora@redhat.com> <20100713040555.GB3949@zeus.themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100713040555.GB3949@zeus.themaw.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 12:05:56PM +0800, Ian Kent wrote:
> On Tue, Jun 15, 2010 at 11:39:37AM -0700, Valerie Aurora wrote:
> > From: Jan Blunck <jblunck@suse.de>
> > 
> > In case of an union directory we don't want that the directories on lower
> > layers of the union "show through". So to prevent that the contents of
> > underlying directories magically shows up after a mkdir() we set the S_OPAQUE
> > flag if directories are created where a whiteout existed before.
> 
> I found this hard to understand.
> 
> Do you mean:
> 
> For directories within a union that are whiteouts we don't want the entries of
> lower layer file system to "show through". To achieve this we set the S_OPAQUE
> flag after a mkdir() on directories that are whiteouts.

That is much clearer.  I ended up with this version, what do you think?

whiteout: Set opaque flag if new directory was previously a whiteout

If we mkdir() a directory on the top layer of a union, we don't want
entries from a matching directory on the lower layer to "show through"
suddenly.  To prevent this, we set the opaque flag on a directory if
there was previously a white-out with the same name. (If there is no
white-out and the directory exists in a lower layer, then mkdir() will
fail with EEXIST.)

-VAL
