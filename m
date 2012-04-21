Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab2DUG2k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 02:28:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57510 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab2DUG2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 02:28:39 -0400
Date: Sat, 21 Apr 2012 07:28:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: fix integer overflow in MS_NOUSER definition
Message-ID: <20120421062838.GS6871@ZenIV.linux.org.uk>
References: <20120421054949.32549.2823.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120421054949.32549.2823.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 09:49:49AM +0400, Konstantin Khlebnikov wrote:
> MS_NOUSER defined as signed int (1<<31), sb->s_flags declared as unsigned long.
> So (sb->s_flags & MS_NOUSER) works as (sb->s_flags & 0xffffffff80000000).

... and it's not a problem since we can't use bits 32 and above anyway -
unsigned long is 32bit on a lot of platforms.  I have no objections to
making that 1U<<31, but it's not a bug, let alone an integer overflow.
