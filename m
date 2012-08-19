Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab2HSPad (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 11:30:33 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58032 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab2HSPab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 11:30:31 -0400
Message-ID: <50310512.5010108@gmail.com>
Date: Sun, 19 Aug 2012 17:24:02 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Dan Luedtke <mail@danrl.de>
CC: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
References: <1345333117-2826-1-git-send-email-mail@danrl.de>  <CAFLxGvwwAX=85hmgxg6qGTpp4YCppuj2mpw7GkB1eV8qhta2bg@mail.gmail.com>  <1345371135.4441.2.camel@tunafish> <5030BC7E.3030000@gmail.com>  <1345383264.4441.56.camel@tunafish>  <20120819120254.GA2369@pompeji.miese-zwerge.org>  <1345390432.2716.34.camel@tunafish>  <20120819142732.GB23464@ZenIV.linux.org.uk> <1345395217.2716.58.camel@tunafish>
In-Reply-To: <1345395217.2716.58.camel@tunafish>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/08/2012 18:53, Dan Luedtke ha scritto:
> On Sun, 2012-08-19 at 15:27 +0100, Al Viro wrote:
>> 	* unlimited recursion
> I am already working on that one, but it's tricky.
>
>> 	* unlink() does *not* truncate the file contents;
> I did not know that.

I add that vmtruncate is deprecated and I see a call to inode_dio_wait 
but no support for direct IO. In addition the lock rules seem strange, I 
would avoid playing with inode->i_lock.

>
>> 	* while we are at it, neither of those should free the on-disk
>> inode; again, that should happen only when the inode is evicted.
> Makes sense now. Thanks!

And I think you'll call d_delete two times.

As general suggestion: to have a general view how things can work you 
can look at other fs. Maybe ramfs or tmpfs are simple enough to 
understand the general concepts.

Marco

