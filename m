Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab2HPPFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:05:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40791 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2HPPFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:05:45 -0400
Date: Thu, 16 Aug 2012 16:05:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
Message-ID: <20120816150542.GV23464@ZenIV.linux.org.uk>
References: <20120815092116.700948346@openvz.org>
 <20120815092409.591460800@openvz.org>
 <20120815204546.GC25062@fieldses.org>
 <20120815210237.GF25421@moon>
 <20120815220622.GA28054@fieldses.org>
 <20120816062448.GA32081@moon>
 <20120816123814.GD1209@moon>
 <20120816124703.GE28054@fieldses.org>
 <20120816145700.GB13382@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816145700.GB13382@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 06:57:00PM +0400, Cyrill Gorcunov wrote:

> Guys, would the patch below be more-less acceptible?
> In inotify I think we could pass "parent" as NULL and use general
> encode engine then (ie it will look like someone called for
> name_to_handle_at on inotify target).

Wait.  What the hell are you going to do with those afterwards?
Again, there's a shitload of filesystems that cannot be exported
over NFS, exactly because there's no way to implement sanely
working fhandles.  And idiotify is allowed for all of them.

You *can't* decode anything fhandle-like on e.g. sysfs.  Or procfs.
Or configfs.  Or any network filesystem (I'd argue that we should simply
ban idiotify on those, but good luck doing that).  You *can* do that
for FAT derivatives, but only if you have parent directory when creating
that sucker.
