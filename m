Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab0H0BOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 21:14:39 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:37127 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab0H0BOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 21:14:38 -0400
Date: Thu, 26 Aug 2010 19:14:36 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Karel Zak <kzak@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: Sanity check mount flags passed to
	change_mnt_propagation()
Message-ID: <20100827011436.GB3521@parisc-linux.org>
References: <20100826200318.GA13636@shell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100826200318.GA13636@shell>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 04:03:18PM -0400, Valerie Aurora wrote:
> +	/* Fail if any non-propagation flags are set */
> +	if (type & ~(MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
> +		return 0;
> +	/* Only one propagation flag should be set */
> +	if (((type & (MS_SHARED)) && (type & ~MS_SHARED)) ||
> +	    ((type & (MS_PRIVATE)) && (type & ~MS_PRIVATE)) ||
> +	    ((type & (MS_SLAVE)) && (type & ~MS_SLAVE)) ||
> +	    ((type & (MS_UNBINDABLE)) && (type & ~MS_UNBINDABLE)))
> +		return 0;

Hrm.  I think we can do this a bit more pithily.

	/* Only one propagation flag should be set, and no others */
	if (hweight32(type) != 1 &&
	    (type & ~(MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
		return 0;

Too clever?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
