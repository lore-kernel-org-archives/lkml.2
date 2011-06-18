Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab1FRHLy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 03:11:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59175 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab1FRHLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 03:11:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ds5BrvAUokC27mpCQ8134Oj8CARYu8XQf2fmju5FMAhR7df20Cv/BLOc2xQMc8KHFa
         cfWh1bK1Tov1ojL0FWK4Rf/Sdf5CX6tQtlB49yrub9EoMZwVoY5xYjHISxkZ7oiRx2Cg
         4+/ALlZuYsYpqM2J25Y+a5vuUzH0QWOlwYRuE=
Message-ID: <4DFC4C7E.1030006@gmail.com>
Date: Sat, 18 Jun 2011 08:58:06 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Steven Whitehouse <swhiteho@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
        josef@redhat.com, agruen@linbit.com,
        "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 1/4] Cache xattr security drop check for write v2
References: <1306596354-18453-1-git-send-email-andi@firstfloor.org> <1306849896.2816.22.camel@menhir> <20110531180643.GB9261@alboin.amr.corp.intel.com> <1306867346.2816.49.camel@menhir> <20110531200750.GO11521@ZenIV.linux.org.uk>
In-Reply-To: <20110531200750.GO11521@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Il 31/05/2011 22:07, Al Viro ha scritto:
> On Tue, May 31, 2011 at 07:42:26PM +0100, Steven Whitehouse wrote:
>
>> Yes, it should test for xattr too,
>
> Frankly, I suspect that the sanest way to handle that is this:
> 	* new superblock flag - MS_NOSEC
> 	* S_NOSEC is never set unless we have MS_NOSEC
> 	* mount_bdev() sets it before calling fill_super callback.
> 	* ocfs2 and fuse *clear* it in their fill_super
> 	* btrfs manually sets it in its ->mount()
> ... and if gfs2 or any other non-trivial fs wants to use that, it'll need
> to set MS_NOSEC in its ->mount() and take care of clearing S_NOSEC whenever
> we decide it might've gone stale (a-la your patch).
>

several fs now uses MS_NOSEC (because this flag is set in mount_bdev()) 
but I don't see any user of the function inode_has_no_xattr() in the 
latest version. If I well understand, a fs that wants to manage this 
feature has to set MS_NOSEC and calls when needed this function, isn't 
it? So at this point, why there aren't any user of this function?

Marco
