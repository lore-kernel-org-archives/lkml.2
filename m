Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab0FCMMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:12:44 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:38668 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab0FCMMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:12:43 -0400
Message-ID: <4C079D34.5010500@oss.ntt.co.jp>
Date: Thu, 03 Jun 2010 21:16:52 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Dan Carpenter <error27@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch v2] fcntl: return -EFAULT if copy_to_user fails
References: <20100603100402.GR5483@bicker> <4C07826A.6060302@oss.ntt.co.jp> <20100603103542.GV5483@bicker> <4C07990A.8080508@fusionio.com>
In-Reply-To: <4C07990A.8080508@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/06/03 20:59), Jens Axboe wrote:
> On 2010-06-03 12:35, Dan Carpenter wrote:
>> copy_to_user() returns the number of bytes remaining, but we want to
>> return -EFAULT.
>> 	ret = fcntl(fd, F_SETOWN_EX, NULL);
>> With the original code ret would be 8 here.
>>
>> V2: Takuya Yoshikawa pointed out a similar issue in f_getown_ex()
>
> Pretty basic bug, how long has this been there?

IIUC, from the beginning, when these were introduced.

And I recently sent similar bug fixes for other parts.

Ah, I also saw somebody sent cleanup patches using memdup_user() which does
not reside in uaccess.h.

Though I'm personally using private *_user documentation,
are there any good official doc for these?

   Takuya



>
> Acked-by: Jens Axboe<jaxboe@fusionio.com>
>

