Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213Ab1D0EQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 00:16:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51584 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1D0EQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 00:16:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UA7zZLAJJkO9wcd2u/l8Q/W8zS/O8xGs05kNPRQQETaQ1WrK4Zf7PZFx6kj45sMEB6
         MCrM4MbRmUqaAdsL2JqYYInnp6139Eq3m+yr1qGlvwOyv68+Wnbjei5mJWcieNb2Z2GH
         Lyydk/c7ZmmTmx/uwGBHBrcGcJKSq8lrLSeS0=
MIME-Version: 1.0
In-Reply-To: <20110427031844.GA5595@p183>
References: <BANLkTinQJ6wzOR++c-OSiCkf=MjOU=y=1A@mail.gmail.com>
	<BANLkTik+9oz9fbeTwS4qd32ukw6uPHtrWA@mail.gmail.com>
	<20110427031844.GA5595@p183>
Date: Wed, 27 Apr 2011 00:16:35 -0400
Message-ID: <BANLkTinDUec911Fg4Nw_qO=uARJVv9GZBQ@mail.gmail.com>
Subject: Re: How to export information larger than PROC_BLOCK_SIZE via /proc
 file system?
From: Jidong Xiao <jidong.xiao@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Am??rico Wang" <xiyou.wangcong@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 11:18 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Wed, Apr 27, 2011 at 11:00:32AM +0800, Am??rico Wang wrote:
>> On Wed, Apr 27, 2011 at 8:54 AM, Jidong Xiao <jidong.xiao@gmail.com> wrote:
>> > Hi,
>> >
>> > I am tracing some data inside the kernel, and I plan to export the
>> > tracing data through /proc file system. I created a file under /proc
>> > file system, and I use cat to display the tracing data. However, every
>> > time there is only 3072 bytes data displayed, which is the size
>> > defined by PROC_BLOCK_SIZE. And I wonder that how to export
>> > information more than that limit? Judging from the function
>> > fs/proc/generic.c/proc_file_read(), if the size returned by my
>> > read_proc function is large than a PAGE_SIZE, then I will get a
>> > KERN_ERR message which says "proc_file_read: Apparent buffer
>> > overflow!". Any help would be appreciated!
>> >
>>
>> Why not switch to use debugfs?
>
> Or use seq_file/proc_create.
>

Oh, thank you two very much. After reading the related document, I
feel seq_file is exactly what I am looking for.

Regards
Jidong
