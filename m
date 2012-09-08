Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab2IHPZj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 11:25:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33471 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab2IHPZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 11:25:37 -0400
Date: Sat, 8 Sep 2012 08:25:33 -0700
From: gregkh <gregkh@linuxfoundation.org>
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: About function __create_file  in debugfs
Message-ID: <20120908152533.GB1838@kroah.com>
References: <201209081741013286843@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209081741013286843@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2012 at 05:41:05PM +0800, Jianpeng Ma wrote:
> Hi:
> 	At present,i used blktrace to trace block io.But i always met error, the message like:
> >BLKTRACESETUP(2) /dev/sdc failed: 2/No such file or directory
> >Thread 0 failed open /sys/kernel/debug/block/(null)/trace0: 2/No such file or directory
> >Thread 2 failed open /sys/kernel/debug/block/(null)/trace2: 2/No such file or directory
> >Thread 3 failed open /sys/kernel/debug/block/(null)/trace3: 2/No such file or directory
> 
> >Thread 1 failed open /sys/kernel/debug/block/(null)/trace1: 2/No such file or directory
> >FAILED to start thread on CPU 0: 1/Operation not permitted
> >FAILED to start thread on CPU 1: 1/Operation not permitted
> >FAILED to start thread on CPU 2: 1/Operation not permitted
> >FAILED to start thread on CPU 3: 1/Operation not permitted
> 
> But those isn't important. I add some message in kernel and found the reason is inode already existed.
> But the function __create_file dosen't return correctly errno.So blktrace tool can't print correctly message.
> I think func __create_file should return correctly message(ERR_PTR(error)) not NULL.

Patches are always welcome :)

greg k-h
