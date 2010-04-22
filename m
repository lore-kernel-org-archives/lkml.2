Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab0DVHCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 03:02:12 -0400
Received: from [76.245.85.235] ([76.245.85.235]:54250 "EHLO cynthia.pants.nu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751952Ab0DVHCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 03:02:10 -0400
Date: Thu, 22 Apr 2010 00:01:29 -0700
From: Brad Boyer <flar@allandria.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Phillip Susi <psusi@cfl.rr.com>, linux-fsdevel@vger.kernel.org,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
Message-ID: <20100422070129.GB10662@cynthia.pants.nu>
References: <4BCC7C05.8000803@cfl.rr.com> <20100421004434.GA27420@shareable.org> <4BCF123C.6010400@cfl.rr.com> <20100421161211.GC27575@shareable.org> <4BCF3FAE.7090206@cfl.rr.com> <20100421202209.GV27575@shareable.org> <4BCF6731.1070404@cfl.rr.com> <20100421220612.GD27575@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421220612.GD27575@shareable.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 11:06:12PM +0100, Jamie Lokier wrote:
> For specific filesystems, you could do it.  readahead() on directories
> is not an unreasonable thing to add on.
> 
> Generically is not likely. It's not about blocking, it's about the
> fact that directories don't always consist of data blocks on the store
> organised similarly to a file.  For example NFS, CIFS, or (I'm not
> sure), maybe even reiserfs/btrfs?

Some non-UNIX file systems don't have anything that looks like a
directory either. Just as an example, HFS and HFS+ both have a single
catalog file for the whole file system. The directory listing method
involves walking the tree from this file and picking a few fields out
of each record matching the appropriate parent directory. This would
make it hard to do something generic, although it would be possible
to readahead some range of blocks of the catalog and produce a
similar effect. This would really need to be FS specific, and the
current readahead impementation is mostly common code.

	Brad Boyer
	flar@allandria.com

