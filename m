Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab2CXOU7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 10:20:59 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53733
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752705Ab2CXOU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 10:20:58 -0400
Date: Sat, 24 Mar 2012 10:20:56 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        Trond.Myklebust@netapp.com, sfrench@samba.org, sage@newdream.net,
        ericvh@gmail.com, mszeredi@suse.cz
Subject: Re: [PATCH 11/25] nfs: don't use intents for checking atomic open
Message-ID: <20120324142056.GC25980@infradead.org>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
 <1331155362-11132-12-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331155362-11132-12-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As NFS was the only instance of d_relvalidate uing other fields
than 'flags' from the nameidata argument we can simply pass an int
flags now.  That will make life for ecryptfs a lot simpler, and it
also gets rid of all that if (nd && check_flags) crap because it's
passed conditionally.
