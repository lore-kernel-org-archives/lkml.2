Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab1D0DAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 23:00:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61358 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab1D0DAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 23:00:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wM2Gp9NABqKeIbA1Sj6ssEemtBztrAeR4rjkqg5ofsn7Piba4yI2BpmWD7GoAgliqP
         +t+uQTcKKuU/mlVD+YVZQhaZbMuBbIDdHm7DAt8tY4wR+KkiTholCH8wc1igahpVcmM0
         yT7yDTRcqppG5cJlR6eInGhFT+8INWnSkHlng=
MIME-Version: 1.0
In-Reply-To: <BANLkTinQJ6wzOR++c-OSiCkf=MjOU=y=1A@mail.gmail.com>
References: <BANLkTinQJ6wzOR++c-OSiCkf=MjOU=y=1A@mail.gmail.com>
Date: Wed, 27 Apr 2011 11:00:32 +0800
Message-ID: <BANLkTik+9oz9fbeTwS4qd32ukw6uPHtrWA@mail.gmail.com>
Subject: Re: How to export information larger than PROC_BLOCK_SIZE via /proc
 file system?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Jidong Xiao <jidong.xiao@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 8:54 AM, Jidong Xiao <jidong.xiao@gmail.com> wrote:
> Hi,
>
> I am tracing some data inside the kernel, and I plan to export the
> tracing data through /proc file system. I created a file under /proc
> file system, and I use cat to display the tracing data. However, every
> time there is only 3072 bytes data displayed, which is the size
> defined by PROC_BLOCK_SIZE. And I wonder that how to export
> information more than that limit? Judging from the function
> fs/proc/generic.c/proc_file_read(), if the size returned by my
> read_proc function is large than a PAGE_SIZE, then I will get a
> KERN_ERR message which says "proc_file_read: Apparent buffer
> overflow!". Any help would be appreciated!
>

Why not switch to use debugfs?
