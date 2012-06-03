Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab2FCJQK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 05:16:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51814 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab2FCJQI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 05:16:08 -0400
Date: Sun, 3 Jun 2012 12:16:03 +0300
From: Mihai =?UTF-8?B?RG9uyJt1?= <mihai.dontu@gmail.com>
To: Xin Tong <xerox.time.tech@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: futex system call in write
Message-ID: <20120603121603.047c86c4@mdontu-l>
In-Reply-To: <CALKntY1xQ7v5VRKxqT3A3G+W3s3CK_JtqWB5GkBcN08J6Hn=-A@mail.gmail.com>
References: <CALKntY1xQ7v5VRKxqT3A3G+W3s3CK_JtqWB5GkBcN08J6Hn=-A@mail.gmail.com>
Organization: Home
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2012 01:58:55 -0400 Xin Tong wrote:
> I am a program with 2 threads, each of which calling printf in a loop.
> when i strace this programs. i see besides write() gets calls a good
> number of times. futex gets call many times as well. it seems to be
> related to the write system call ? how is the futex system call used
> here ? maybe write() is blocking and futex is used to wait the thread
> up when the write finishes ? if that is the case, what about other
> blocking system calls ?
> 

You should probably ask this question on a glibc mailing list.

What you're seeing is the effect of using the locking version of the
standard IO calls, where before each output a mutex is acquired to
ensure thread safety. Thus futex() has nothing to do with write(), it
is merely the underlaying system call for pthread_mutex_xxxx() calls.

-- 
Mihai Donțu
