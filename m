Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab2JaAV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:21:57 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:43892 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870Ab2JaAVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:21:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AksbACZukFB5LDZd/2dsb2JhbABEvWGFCAKBA4EJgh4BAQU6HCMQCAMYLhQlAyETiAW8XxSLYyCBaIQzA5V0iUiGe4MDgUgf
Date: Wed, 31 Oct 2012 11:21:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Akira Fujita <a-fujita@rs.jp.nec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 2/3] ext4: introduce ext4_error_remove_page
Message-ID: <20121031002151.GI29378@dastard>
References: <1351177969-893-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1351177969-893-3-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20121026061206.GA31139@thunk.org>
 <3908561D78D1C84285E8C5FCA982C28F19D5A13B@ORSMSX108.amr.corp.intel.com>
 <20121026184649.GA8614@thunk.org>
 <3908561D78D1C84285E8C5FCA982C28F19D5A388@ORSMSX108.amr.corp.intel.com>
 <20121027221626.GA9161@thunk.org>
 <3908561D78D1C84285E8C5FCA982C28F19D5ABB3@ORSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D5ABB3@ORSMSX108.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 06:11:58PM +0000, Luck, Tony wrote:
> > What I would recommend is adding a 
> >
> > #define FS_CORRUPTED_FL		0x01000000 /* File is corrupted */
> >
> > ... and which could be accessed and cleared via the lsattr and chattr
> > programs.
> 
> Good - but we need some space to save the corrupted range information
> too. These errors should be quite rare, so one range per file should be
> enough.
> 
> New file systems should plan to add space in their on-disk format. The
> corruption isn't going to go away across a reboot.

No, not at all. if you want to store something in the filesystem
permanently, then use xattrs. You cannot rely on the filesystem
being able to store random application specific data in their
on-disk format. That's the *exact purpose* that xattrs were
invented for - they are an extensible, user-defined, per-file
metadata storage mechanism that is not tied to the filesystem
on-disk format.

The kernel already makes extensive use of xattrs for such metadata -
just look at all the security and integrity code that uses xattrs to
store their application-specific metadata.  Hence *anything* that
the kernel wants to store on permanent storage should be using
xattrs because then the application has complete control of what is
stored without caring about what filesystem it is storing it on.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
