Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab2ICGIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 02:08:39 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53156 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab2ICGIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 02:08:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120831172900.GC23464@ZenIV.linux.org.uk>
References: <1346431688-3544-1-git-send-email-linkinjeon@gmail.com>
	<20120831172900.GC23464@ZenIV.linux.org.uk>
Date: Mon, 3 Sep 2012 15:08:38 +0900
Message-ID: <CAKYAXd-JApY3-4eBn5mDv_fB8JweHDUqdUX7y6ChTkuYbJNjVQ@mail.gmail.com>
Subject: Re: [PATCH] fat: remove redundent call to fat_detach in vfat_unlink
From: Namjae Jeon <linkinjeon@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/1, Al Viro <viro@zeniv.linux.org.uk>:
> On Fri, Aug 31, 2012 at 12:48:07PM -0400, Namjae Jeon wrote:
>> As after file is removed fat_evict_inode will be called and fat_detach
>> will be called from that place. So, fat_detach can be removed from
>> vfat_unlink
>
> NAK.  Please, realize that unlink and destruction of file are separate
> operations.  ->evict_inode() may be called long after ->unlink(); moreover,
> during that time you might have another file created, getting the
> same directory entry our file used to have.
>
> This is Unix, damnit.  You *can* open file, then unlink it and that file
> will keep existing (i.e. you can write to that descriptor, read, etc.)
> until it's closed.
>
Hi Al.
Sorry for noise. I understand what you said.
There was some confusing to me while checking fat's estale issue.:)
I will re-post patch-set about fat estale issue soon.(fix side-effect
informed by you and ogawa)
I am grateful that you review these patches also if you have time.
Thanks.
