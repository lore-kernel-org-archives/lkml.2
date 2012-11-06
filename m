Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab2KFMGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 07:06:47 -0500
Received: from fieldses.org ([174.143.236.118]:56356 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab2KFMGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 07:06:46 -0500
Date: Tue, 6 Nov 2012 07:06:42 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: "Trond.Myklebust@netapp.com" <Trond.Myklebust@netapp.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH v3] SUNRPC: set desired file system root before
 connecting local transports
Message-ID: <20121106120642.GA6718@fieldses.org>
References: <20121008105437.18668.99905.stgit@localhost.localdomain>
 <20121009193506.GA19680@fieldses.org>
 <5098E31A.5080801@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5098E31A.5080801@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 02:14:50PM +0400, Stanislav Kinsbursky wrote:
> 09.10.2012 23:35, J. Bruce Fields пишет:
> >Cc'ing Eric since I seem to recall he suggested doing it this way?
> >
> >Seems OK to me, but maybe that swap_root should be in common code?  (Or
> >maybe we could use set_fs_root()?)
> >
> 
> This patch is not good since, as Eric mentioned, all kernel threads
> share same fs struct.
> We can swap whole fs struct. Or we can unshare fs struct
> (unshare_fs_struct() is exported) and swap root in this case.
> But this approach is to close to set_fs_root() logic, which is not
> exported and seems there are some valid reasons for it.

What are those reasons?

Googling found one previous thread:

	http://thread.gmane.org/gmane.linux.kernel/1259986/focus=47687

There Trond requests an ACK from Al or Cristoph for the export, but I
don't see either an ACK or any objection.

--b.
