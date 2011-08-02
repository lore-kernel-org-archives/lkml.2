Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1HBOSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 10:18:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58360 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab1HBOSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 10:18:17 -0400
Date: Tue, 2 Aug 2011 15:18:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Glauber Costa <glommer@parallels.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org,
        Pavel Emelyanov <xemul@parallels.com>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [PATCH 4/4] parse options in the vfs level
Message-ID: <20110802141806.GL2203@ZenIV.linux.org.uk>
References: <1311947059-17209-1-git-send-email-glommer@parallels.com>
 <1311947059-17209-5-git-send-email-glommer@parallels.com>
 <20110731013456.GM5404@dastard>
 <4E37F5C6.8060908@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E37F5C6.8060908@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 10:04:06AM -0300, Glauber Costa wrote:

> I am not sure either, but I still believe my proposal is superior to
> write-to-a-file specifically. Writing to a file, be it in proc, sys,
> or wherever, leaves a window of opportunity open between mounting a
> filesystem and limiting its caches. Doing it on mount is atomic.
> 
> Effectively, I see this limit as a property of a particular instance
> of a mounted filesystem. Since all properties of a filesystem are
> specified during mount, this becomes a natural extension.

The trouble is, dentry tree is fundamentally a property of superblock.
It's shared between *all* instances of that fs in all mount trees...
