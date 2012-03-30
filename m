Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761083Ab2C3QiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 12:38:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50713 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab2C3Qh6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 12:37:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120330153013.GC18488@kroah.com>
References: <1333127067-2043-1-git-send-email-levinsasha928@gmail.com> <20120330153013.GC18488@kroah.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 30 Mar 2012 19:37:37 +0300
Message-ID: <CA+1xoqdZnxcWNpL-03xsR+RDcz3=aRbx2LbR6mTJ_gCmwp-0Rw@mail.gmail.com>
Subject: Re: [PATCH] kmsg: Use vmalloc instead of kmalloc when writing
To: Greg KH <gregkh@linuxfoundation.org>
Cc: arnd@arndb.de, viro@zeniv.linux.org.uk, davej@redhat.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 6:30 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Mar 30, 2012 at 01:04:27PM -0400, Sasha Levin wrote:
>> There are no size checks in kmsg_write(), and we try allocating enough
>> memory to store everything userspace gave us, which may be too much for
>> kmalloc to allocate.
>
> Really?  Have you seen this fail?  As only root can do this, is this
> really a problem?

Only root, and a whole bunch of management software that dumps data
into /dev/kmsg (systemd and friends).

>> One option would be to limit it to something, but we can't come up with
>> a number that would make sense.
>>
>> Instead, just use vmalloc so that nothing would break with large amounts
>> of data.
>
> Are you sure this will work properly?  Have you tested it with large
> amounts of data?

My test was dumping 800mb of data into it, if there's anything else I
should try please let me know.

Thanks.
