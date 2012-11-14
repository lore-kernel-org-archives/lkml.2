Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422808Ab2KNMp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 07:45:56 -0500
Received: from fieldses.org ([174.143.236.118]:38520 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422695Ab2KNMpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 07:45:54 -0500
Date: Wed, 14 Nov 2012 07:45:49 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com
Subject: Re: [patch 3/7] fs, notify: Add file handle entry into
 inotify_inode_mark
Message-ID: <20121114124549.GB23604@fieldses.org>
References: <20121112101440.665694060@openvz.org>
 <2105540.yeyMVrW4mH@deuteros>
 <50A36ED5.4080505@parallels.com>
 <2092535.8S9EcgmZCZ@deuteros>
 <50A37692.1010500@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A37692.1010500@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 02:46:42PM +0400, Pavel Emelyanov wrote:
> Well, the MAX_HANDLE_SZ is taken from NFSv4 and is 128 bytes which is quite
> big for inotify extension indeed. The good news is that this amount of bytes
> seem to be required for the most descriptive fhandle

That 128-byte constant is just the protocol-defined maximum.

In practice my memory is that no existing filesystems require NFSv4 for
exports, so they all fit in the NFSv3 64-byte limit.  (But I seem to
recall the NFSv2 32-byte limit being too small in some cases.)

> -- with info about parent, etc. We don't need such, we can live with
> shorter handle, people said that 40 bytes was enough for that.
> 
> However, your idea about determining the handle size dynamically seems
> promising.  As far as I can see from the code we can call for
> encode_fh with size equals zero and filesystem would report back the
> amount of bytes it requires for a handle.
> 
> We can try going this route, what do you think?

I still don't understand why you need a dentry to get the filehandle.
The current api may ask for one, but it shouldn't really be necessary
(assuming you don't want parent directory information encoded in the
filehandle, which I hope you don't).

--b.
