Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab1HSPPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:15:34 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58330 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab1HSPPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:15:32 -0400
Date: Fri, 19 Aug 2011 11:15:28 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/5] fs: add netlink notification interface
Message-ID: <20110819151528.GB4602@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>
References: <1313669906-14931-1-git-send-email-lczerner@redhat.com>
 <1313669906-14931-2-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313669906-14931-2-git-send-email-lczerner@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 02:18:22PM +0200, Lukas Czerner wrote:
> +void fs_nl_send_warning(dev_t dev, unsigned int warntype)
> +{

I'm pretty sure this interface isn't going to be sufficient in the
long run.  I can imagine that people might want to pass in a struct
inode *, or a struct file * if available, so we could pass back the
inode number involved, or even the pathname.

Also, I'd suggesting changing "warning" to "error", since that's what
most of the things we are sending really are...

> +	ret = nla_put_u32(skb, FS_NL_A_WARNING, warntype);
> +	if (ret)
> +		goto attr_err_out;

Why not make the warning type to be a string instead of an integer?
This would make it easier to extend the protocol in the future.

> +	ret = nla_put_u64(skb, FS_NL_A_CAUSED_ID, current_uid());
> +	if (ret)
> +		goto attr_err_out;

I'd also suggest passing back the process id that requested the I/O if
that's known...

						- Ted
