Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab1FRSEy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 14:04:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35992 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab1FRSEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 14:04:52 -0400
Date: Sat, 18 Jun 2011 20:04:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Steven Whitehouse <swhiteho@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        chris.mason@oracle.com, josef@redhat.com, agruen@linbit.com,
        "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 1/4] Cache xattr security drop check for write v2
Message-ID: <20110618180450.GH16236@one.firstfloor.org>
References: <1306596354-18453-1-git-send-email-andi@firstfloor.org> <1306849896.2816.22.camel@menhir> <20110531180643.GB9261@alboin.amr.corp.intel.com> <1306867346.2816.49.camel@menhir> <20110531200750.GO11521@ZenIV.linux.org.uk> <4DFC4C7E.1030006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFC4C7E.1030006@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> several fs now uses MS_NOSEC (because this flag is set in mount_bdev()) 
> but I don't see any user of the function inode_has_no_xattr() in the 
> latest version. If I well understand, a fs that wants to manage this 
> feature has to set MS_NOSEC and calls when needed this function, isn't 
> it? So at this point, why there aren't any user of this function?

Calling the function is just an optimization to avoid the lookup
for the first write.  But most of the benefit you already get
when just the flag is set.

I haven't resent the patches using it to the fs maintainers yet and none
of them took it the first round. 

-Andi
