Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836Ab0FJLbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:31:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:33190 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab0FJLbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:31:44 -0400
Message-ID: <4C10CCFB.4030203@kernel.org>
Date: Thu, 10 Jun 2010 13:31:07 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jari Ruusu <jariruusu@users.sourceforge.net>
CC: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.35-rc2 module reference counting broken
References: <4C0C819E.EA5D6A18@users.sourceforge.net> <20100607064412.GK31073@ZenIV.linux.org.uk> <20100608234814.GA19826@ZenIV.linux.org.uk> <4C0F3C66.1020601@kernel.org> <4C108778.71545BCF@users.sourceforge.net>
In-Reply-To: <4C108778.71545BCF@users.sourceforge.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Jun 2010 11:31:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/10/2010 08:34 AM, Jari Ruusu wrote:
> Later in the mount system call handling the module refrence count is
> incremented. But to me that looks like there is a window of opportunity for
> things to go wrong. What is there to prevent module from being removed at
> zero refcount?

It can be removed, in which case blkdev_get() fails and the whole open
attempt fails, which is the expected behavior.  Claiming block just
needs access to the containing struct block_device, caring for the
actual device and backing module is blkdev_get()'s job.

Thanks.

-- 
tejun
