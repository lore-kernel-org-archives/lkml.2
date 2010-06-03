Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab0FCL7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 07:59:21 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:38743 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463Ab0FCL7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 07:59:20 -0400
Message-ID: <4C07990A.8080508@fusionio.com>
Date: Thu, 03 Jun 2010 13:59:06 +0200
From: Jens Axboe <jaxboe@fusionio.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>,
       Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
       Matthew Wilcox <matthew@wil.cx>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch v2] fcntl: return -EFAULT if copy_to_user fails
References: <20100603100402.GR5483@bicker> <4C07826A.6060302@oss.ntt.co.jp> <20100603103542.GV5483@bicker>
In-Reply-To: <20100603103542.GV5483@bicker>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-03 12:35, Dan Carpenter wrote:
> copy_to_user() returns the number of bytes remaining, but we want to
> return -EFAULT.
> 	ret = fcntl(fd, F_SETOWN_EX, NULL);
> With the original code ret would be 8 here.
> 
> V2: Takuya Yoshikawa pointed out a similar issue in f_getown_ex()

Pretty basic bug, how long has this been there?

Acked-by: Jens Axboe <jaxboe@fusionio.com>

-- 
Jens Axboe

