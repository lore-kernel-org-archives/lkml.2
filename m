Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab2HPPJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:09:37 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36927 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475Ab2HPPJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:09:36 -0400
Date: Thu, 16 Aug 2012 19:09:32 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
Message-ID: <20120816150932.GD13066@moon>
References: <20120815092116.700948346@openvz.org>
 <20120815092409.591460800@openvz.org>
 <20120815204546.GC25062@fieldses.org>
 <20120815210237.GF25421@moon>
 <20120815220622.GA28054@fieldses.org>
 <20120816062448.GA32081@moon>
 <20120816123814.GD1209@moon>
 <20120816124703.GE28054@fieldses.org>
 <20120816145700.GB13382@moon>
 <20120816150542.GV23464@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816150542.GV23464@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 04:05:42PM +0100, Al Viro wrote:
> On Thu, Aug 16, 2012 at 06:57:00PM +0400, Cyrill Gorcunov wrote:
> 
> > Guys, would the patch below be more-less acceptible?
> > In inotify I think we could pass "parent" as NULL and use general
> > encode engine then (ie it will look like someone called for
> > name_to_handle_at on inotify target).
> 
> Wait.  What the hell are you going to do with those afterwards?
> Again, there's a shitload of filesystems that cannot be exported
> over NFS, exactly because there's no way to implement sanely
> working fhandles.  And idiotify is allowed for all of them.

Yes, just recognized that, Al. There will be no way to restore them
from fhandle provided via fdinfo. /me scratching the head...

> You *can't* decode anything fhandle-like on e.g. sysfs.  Or procfs.
> Or configfs.  Or any network filesystem (I'd argue that we should simply
> ban idiotify on those, but good luck doing that).  You *can* do that
> for FAT derivatives, but only if you have parent directory when creating
> that sucker.

	Cyrill
