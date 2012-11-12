Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2KLXD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:03:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab2KLXD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:03:26 -0500
Date: Mon, 12 Nov 2012 15:03:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arvid Brodin <Arvid.Brodin@xdin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "David Rientjes" <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] fs/proc: Add process text segment md5-summing
Message-Id: <20121112150325.2516a0bf.akpm@linux-foundation.org>
In-Reply-To: <50A16BD0.7030600@xdin.com>
References: <50A16BD0.7030600@xdin.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012 21:36:17 +0000
Arvid Brodin <Arvid.Brodin@xdin.com> wrote:

> Adds /proc/<pid>/text_md5sum which, when read, calculates an md5sum over
> the process' text segment. This can detect some cases where the system RAM
> has been disturbed by e.g. ESD or cosmic radiation (on systems where ECC
> is not available). It might also detect some accidental or malicious
> modifications of executables, where the perpetrator has not bothered to
> cover up the tracks.

I thought the review comments regarding the earlier patch were rather
fatal, sorry.

> +	  Read /proc/<pid>/text_md5sum to get the kernel to perform an MD5
> +	  checksum over the process' text segment and print the result. This
> +	  can detect some cases where the system RAM has been disturbed by
> +	  e.g. ESD or cosmic radiation (on systems where ECC is not available).
> +	  It might also detect some accidental or malicious modifications of
> +	  executables, where the perpetrator has not bothered to cover up the
> +	  tracks.

And that doesn't seem to help much, really.  .text is only a small part
of a process's VM and corruption of data, bss, heap or stack is just as
bad.
