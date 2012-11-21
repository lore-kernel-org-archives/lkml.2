Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812Ab2KVV4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:56:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54883 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754928Ab2KVV4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:56:18 -0500
Date: Wed, 21 Nov 2012 22:13:41 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: gregkh@linuxfoundation.org, stable@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <20121121221341.GX13292@decadent.org.uk>
References: <20121121174445.GE30250@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121174445.GE30250@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: Tagging of -stable patches
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 06:44:45PM +0100, Jan Kara wrote:
>   Hello,
> 
>   I have a question regarding tagging of patches targetted in -stable
> kernels. We have this 'CC: stable@vger.kernel.org # something' tag. Now
> inconvenient thing is that when I create a patch and have such tag in it,
> then git-send-email will mangle the address because of the #. Now even if
> git-send-email started to ignore the part after #, we don't really want
> stable@vger.kernel.org to get the patch since it is eligible for -stable
> only after it is merged upstream. So the CC form of the tag seems to be
> kind of inconvenient. Won't it be better to have some different tag?
 
I don't have any particular attachment to this odd format, but I
would like to see *some* format properly standardised.  I want to be
able to script:

for each new commit cc'd to stable:
    if no version restriction is specified:
        add to patch queue(s) pending check for suitability
    elif version restriction can be parsed:
        add to patch queue(s) or drop based on version comparison
    else:
        show version restriction and ask whether/where to add it

...with as few questions asked as possible.  As yet, though, I haven't
bothered trying to parse the variety of different ways people write
version restrictions, but the script does require them to be preceded
by a '#'.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
