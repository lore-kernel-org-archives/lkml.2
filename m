Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab0JSSzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:55:01 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52406 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab0JSSzA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:55:00 -0400
MIME-Version: 1.0
In-Reply-To: <20101019101158.29e8cd0f@bike.lwn.net>
References: <1287479956.1729.1.camel@yio.site> <20101019101158.29e8cd0f@bike.lwn.net>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 19 Oct 2010 20:54:44 +0200
Message-ID: <AANLkTik3PG966VAA3ZM7L0SyPpuvqVuTXH6h7WZvwngF@mail.gmail.com>
Subject: Re: [PATCH] support polling of /proc/swaps
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 18:11, Jonathan Corbet <corbet@lwn.net> wrote:
> Here we have this:
>
>> +static unsigned swaps_poll(struct file *file, poll_table *wait)
>> +{
>> +     struct proc_swaps *s = file->private_data;
>
> But here I see:
>
>>  static int swaps_open(struct inode *inode, struct file *file)
>>  {
>> -     return seq_open(file, &swaps_op);
>> +     struct proc_swaps *s;
>> +     int ret;
>> +
>> +     s = kmalloc(sizeof(struct proc_swaps), GFP_KERNEL);
>> +     if (!s)
>> +             return -ENOMEM;
>> +
>> +     file->private_data = &s->seq;
>
> It sure looks to me like private_data is a struct seq_file pointer, not a
> struct proc_swaps pointer.  What am I missing?

Right, that looks weird. It's the same pointer though, because it's
the first element. I'll correct that.

Thanks a lot for the sharp eyes,
Kay
