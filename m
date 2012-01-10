Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab2AJNUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 08:20:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673Ab2AJNUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 08:20:40 -0500
Date: Tue, 10 Jan 2012 14:14:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, Chris Yeoh <yeohc@au1.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: cross memory attach && security check
Message-ID: <20120110131446.GA30465@redhat.com>
References: <20120105151012.GA25671@redhat.com> <20120109174124.0d588b5b@Gantu.yeoh.info> <20120109145342.GA1777@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109145342.GA1777@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09, Oleg Nesterov wrote:
>
> Partly I was confused because (I guess) there is another minor bug in
> process_vm_rw(), I think we need
>
> 	--- x/mm/process_vm_access.c
> 	+++ x/mm/process_vm_access.c
> 	@@ -375,10 +375,10 @@ static ssize_t process_vm_rw(pid_t pid,
> 	 
> 		/* Check iovecs */
> 		if (vm_write)
> 	-		rc = rw_copy_check_uvector(WRITE, lvec, liovcnt, UIO_FASTIOV,
> 	+		rc = rw_copy_check_uvector(READ, lvec, liovcnt, UIO_FASTIOV,
> 						   iovstack_l, &iov_l, 1);
> 		else
> 	-		rc = rw_copy_check_uvector(READ, lvec, liovcnt, UIO_FASTIOV,
> 	+		rc = rw_copy_check_uvector(WRITE, lvec, liovcnt, UIO_FASTIOV,
> 						   iovstack_l, &iov_l, 1);

Argh. No, I was wrong, vrfy_dir() swaps READ/WRITE.

Oleg.

