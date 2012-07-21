Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab2GUQe5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 12:34:57 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41135 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab2GUQez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 12:34:55 -0400
Date: Sat, 21 Jul 2012 10:34:53 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: zwu.kernel@gmail.com
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [PATCH] vfs: simply the code logic
Message-ID: <20120721163453.GB31693@parisc-linux.org>
References: <1342885099-22662-1-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342885099-22662-1-git-send-email-zwu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2012 at 11:38:19PM +0800, zwu.kernel@gmail.com wrote:
>  	if (offset >= 0 && offset <= size) {
> -		if (offset != file->f_pos) {
> -			file->f_pos = offset;
> -		}
> -		retval = offset;
> +		retval = file->f_pos = offset;
>  	}

But now you're writing to f_pos unconditionally.  That may cause
cacheline bouncing.  NAK.

Plus, you're now using a less-well-known feature of C, so while it's fewer
lines of code, it's not necessarily a simplification.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
