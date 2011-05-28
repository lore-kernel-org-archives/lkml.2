Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab1E1Lmv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 07:42:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52058 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab1E1Lmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 07:42:50 -0400
Date: Sat, 28 May 2011 12:42:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, chris.mason@oracle.com,
        josef@redhat.com, agruen@linbit.com,
        "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 1/4] Cache xattr security drop check for write
Message-ID: <20110528114244.GG11521@ZenIV.linux.org.uk>
References: <1306536845-24162-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306536845-24162-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 03:54:02PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Some recent benchmarking on btrfs showed that a major scaling bottleneck
> on large systems on btrfs is currently the xattr lookup on every write.
> 
> Why xattr lookup on every write I hear you ask?
> 
> write wants to drop suid and security related xattrs that could set o
> capabilities for executables.  To do that it currently looks up
> security.capability on EVERY write (even for non executables) to decide
> whether to drop it or not.

Hm...
	a) is_sgid() is a bad name for that - at the very least s/g/x/, since
anybody would read your variant as "check if it's set-group-id".
	b) I'd add a helper for filesystems to use, rather than messing
with the flags directly.
