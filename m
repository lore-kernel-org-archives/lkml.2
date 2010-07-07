Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab0GGSUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 14:20:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:48735 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756242Ab0GGSUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 14:20:04 -0400
Date: Thu, 8 Jul 2010 04:20:01 +1000
From: Nick Piggin <npiggin@suse.de>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de, hooanon05@yahoo.co.jp,
       bfields@fieldses.org, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V14 04/11] vfs: Allow handle based open on symlinks
Message-ID: <20100707182001.GG9263@laptop>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1276621981-2774-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20100707152303.GS11732@laptop>
 <87d3uzfeej.fsf@linux.vnet.ibm.com>
 <20100707165719.GC9263@laptop>
 <874ogbfaas.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874ogbfaas.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 11:23:31PM +0530, Aneesh Kumar K. V wrote:
> On Thu, 8 Jul 2010 02:57:19 +1000, Nick Piggin <npiggin@suse.de> wrote:
> > I haven't followed this thread closely, so can you just go back
> > and explain to me why you need this? Ie. that you can't achieve with
> > a path-to-handle follow/nofollow option.
> 
> 
> We need to be able to read the link target using file handle. The exact
> usecase i have is with respect to implementing READLINK operation on a
> userspace NFS server. The request contain the file handle and the
> response include target name.

Fair point, could you include this stuff in your changelog? It may
help with other people reviewing it too who have not followed closely.

 
> Similarly we need to able to get file attribute based on file handle.
> I was using readlinkat and fstat to obtain both the above information
> using the descriptor returned by open_by_handle on a file handle
> representing symlink
> 
> -aneesh
