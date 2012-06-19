Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203Ab2FSHvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 03:51:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2FSHvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 03:51:50 -0400
Date: Tue, 19 Jun 2012 00:52:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suresh Jayaraman <sjayaraman@suse.com>
Cc: David Howells <dhowells@redhat.com>, Justin Lecher <jlec@gentoo.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-cachefs@redhat.com
Subject: Re: [PATCH] [RESEND] fs: cachefiles: Add support for large files in
 filesystem caching
Message-Id: <20120619005214.989e90a8.akpm@linux-foundation.org>
In-Reply-To: <4FE00DBF.7080405@suse.com>
References: <4FD5844D.4010900@suse.com>
	<20120618160408.8d0dd792.akpm@linux-foundation.org>
	<4FE00DBF.7080405@suse.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2012 10:57:27 +0530 Suresh Jayaraman <sjayaraman@suse.com> wrote:

> > How extensively was this change tested?  Please describe the testing
> > which was performed?
> > 
> 
> The original patch was tested by mounting a NFS share with fscache
> option enabled, do a md5sum on a nfs file larger than 2GB and ensure
> that the file is getting cached by fscache (watch cache size growing)
> on x86_64. 

Well it will need a lot more coverage testing than that.  truncate? 
expanding truncate?  write, lseek, pwrite, pread(), mmap(MAP_SHARED),
behavior at the new max file size (what is that?), etc.

