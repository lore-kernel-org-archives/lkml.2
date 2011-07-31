Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab1GaUn0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 16:43:26 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:39788 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1GaUnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 16:43:19 -0400
MIME-Version: 1.0
In-Reply-To: <4E35B908.6090507@fusionio.com>
References: <1312053553.1187.17.camel@mop> <4E35B908.6090507@fusionio.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sun, 31 Jul 2011 22:42:59 +0200
Message-ID: <CAPXgP11W7dKSAQaemaeN=7desPtK-VonTLvLoW9_i1rUbYjvJg@mail.gmail.com>
Subject: Re: loop: fix deadlock when sysfs and LOOP_CLR_FD race against each other
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Milan Broz <mbroz@redhat.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 22:20, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2011-07-30 21:19, Kay Sievers wrote:
>> Instead of taking the lo_ctl_mutex from sysfs code, take the inner
>> lo->lo_lock, to protect the access to the backing_file data.
>>
>> Thanks to Tejun for help debugging and finding a solution.
>
> Looks good, looks like something that should have a stable tag as well?

Right, I think it makes sense to have that in -stable.

It's pretty hard to trigger, I had multiple threads running, crawling
/sys and adding/binding/unbinding/removing 1000s of loop devices, and
it takes several minutes sometimes until its hit. So I only tested it
on top of the 3 loop-control patches, but the issue should exist in
the current code as well.

Thanks,
Kay
