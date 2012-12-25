Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab2LYVk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 16:40:28 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:34944 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab2LYVkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 16:40:25 -0500
Date: Tue, 25 Dec 2012 15:40:21 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: Does init start with any open files?
To: bbi5291 <bbi5291@gmail.com>
Cc: linux-kernel@vger.kernel.org
References: <CAMmfjbPKGD28070A0JvMyL02juYW5tuwNmVwrJ-1gFzkNhCuDQ@mail.gmail.com>
In-Reply-To: <CAMmfjbPKGD28070A0JvMyL02juYW5tuwNmVwrJ-1gFzkNhCuDQ@mail.gmail.com>
	(from bbi5291@gmail.com on Tue Dec 25 01:38:09 2012)
X-Mailer: Balsa 2.4.11
Message-Id: <1356471621.31232.3@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/2012 01:38:09 AM, bbi5291 wrote:
> When the init process is created on system startup, does it have any
> open file descriptors? If so, where do they point?

Last I checked, it worked like this:

If there's a /dev/console in initramfs, stdin, stdout, and stderr will  
point to that. If you select no initramfs, you get one with just  
/dev/console. If you create your own initramfs and don't put  
/dev/console in it, init gets no file descriptors and there's a line  
about it in dmesg.

Rob