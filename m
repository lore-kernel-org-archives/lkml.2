Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1LAKWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 05:22:17 -0500
Received: from claranet-outbound-smtp05.uk.clara.net ([195.8.89.38]:51444 "EHLO
	claranet-outbound-smtp05.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753123Ab1LAKWP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 05:22:15 -0500
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: Peng Yu <pengyu.ut@gmail.com>
Subject: Re: Which one corresponds to ioctl in the file_operations struct in linux/fs.h?
Date: Thu, 1 Dec 2011 10:22:12 +0000
User-Agent: KMail/1.13.7 (Linux/3.1.0-1.fc15.x86_64; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <CABrM6wnDgRd0N5eSGffj51KR6-axAoFMNRWMZs2pFQ8dN94t0A@mail.gmail.com>
In-Reply-To: <CABrM6wnDgRd0N5eSGffj51KR6-axAoFMNRWMZs2pFQ8dN94t0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201112011022.12686.tvrtko.ursulin@onelan.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 Dec 2011 07:40:49 Peng Yu wrote:
> Hi,
> 
> I have some driver code for older version of kernel. It refers to
> ioctl in the file_operations struct. But this field is change in
> kernel 3.0.0-13
> 
> I find the following in linux/fs.h
> 
> 1566   long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
> 1567   long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
> 
> Does anybody know which one I should use in order to migrate the
> driver code to the newer version of kernel? Thanks!

>From Documentation/filesystems/vfs.txt:

  unlocked_ioctl: called by the ioctl(2) system call.

  compat_ioctl: called by the ioctl(2) system call when 32 bit system calls
         are used on 64 bit kernels.

You don't need compat_ioctl if your ioctl arguments are 32/64-bit safe.

For both your code needs to be re-entrant or take appropriate locks 
internally.

Hope this helps,

Tvrtko
