Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab1BMOL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 09:11:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967Ab1BMOLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 09:11:20 -0500
Message-ID: <4D57E67E.1030707@redhat.com>
Date: Sun, 13 Feb 2011 15:11:10 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tao Ma <tm@tao.ma>
CC: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] loop: clear read-only flag in loop_clr_fd.
References: <4D573BBB.6090200@redhat.com> <1297594735-5593-1-git-send-email-tm@tao.ma>
In-Reply-To: <1297594735-5593-1-git-send-email-tm@tao.ma>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2011 11:58 AM, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In 75f1dc0, we check bdev_read_only() from blkdev_get().
> But the loop_clr_fd doesn't clear the read only flag.
> What cause a error if we changing a loop device from
> read only to writable.

No, sorry, this is not proper/complete fix. It fixes it for loop
(and even not completely - you are missing some error
paths and ignoring autoclear mode where you have bdev NULL.)
(And yes, I tried the same as workaround.)

And it will not help for DM case (and possibly others).

Milan
