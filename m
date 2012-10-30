Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934697Ab2J3VWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 17:22:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55343 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934405Ab2J3VWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 17:22:21 -0400
Date: Tue, 30 Oct 2012 21:22:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Arvid Brodin <Arvid.Brodin@xdin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: fs/proc/base.c: text md5sums; tgid vs tid; and INF vs ONE?
Message-ID: <20121030212217.GD2616@ZenIV.linux.org.uk>
References: <50904066.4060404@xdin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50904066.4060404@xdin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 09:02:33PM +0000, Arvid Brodin wrote:

> +config PROC_TEXT_MD5SUM
> +	bool "/proc/<pid>/text_md5sum support"
> +	depends on PROC_FS
> +	select CRYPTO
> +	select CRYPTO_MD5
> +	help
> +	  Read /proc/<pid>/text_md5sum to get the kernel to perform an MD5
> +	  checksum over the process' text segment and print the result. Can be
> +	  used to make sure a process' code has not been tampered with.

Sorry, but this is pointless.  Any attacker capable of modifying the code
will be just as capable of modifying pointers to functions in data segment.
IOW, you are not making sure of anything useful.
