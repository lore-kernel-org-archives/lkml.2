Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab1EJO0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:26:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62508 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab1EJO0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:26:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=K/aaRFoPD/am5CdJ4Z3Qu2a6c/9WL7RWiNfsYSivADJFMZbl3FESklNAhm3ZQ7gewr
         6SaITWM/WmTlPELlfliervquxjbKVYM1jzWAmBmTJT2Fqc/ICBYMi/CM/t1rZmQ/V2Nc
         wgN+CoslbSKRZs3vgN6bB8nsxiUQ4ljJ0oYqY=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=4DNyWaqqjK5sG5O9cNdfpuAqHWA@mail.gmail.com>
References: <BANLkTinr34qmAE8RWVY0Wq_XMfOc0jTUzg@mail.gmail.com>
	<BANLkTi=4DNyWaqqjK5sG5O9cNdfpuAqHWA@mail.gmail.com>
Date: Tue, 10 May 2011 07:26:13 -0700
Message-ID: <BANLkTimjVsfWg1Anz44ek-Stsgvu=1f36A@mail.gmail.com>
Subject: Re: Kernel 2.6.38.6 page allocation failure (ixgbe)
From: Yehuda Sadeh Weinraub <yehudasa@gmail.com>
To: Stefan Majer <stefan.majer@gmail.com>
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 7:20 AM, Yehuda Sadeh Weinraub
<yehudasa@gmail.com> wrote:
> On Tue, May 10, 2011 at 7:04 AM, Stefan Majer <stefan.majer@gmail.com> wrote:
>> Hi,
>>
>> im running 4 nodes with ceph on top of btrfs with a dualport Intel
>> X520 10Gb Ethernet Card with the latest 3.3.9 ixgbe driver.
>> during benchmarks i get the following stack.
>> I can easily reproduce this by simply running rados bench from a fast
>> machine using this 4 nodes as ceph cluster.
>> We saw this with stock ixgbe driver from 2.6.38.6 and with the latest
>> 3.3.9 ixgbe.
>> This kernel is tainted because we use fusion-io iodrives as journal
>> devices for btrfs.
>>
>> Any hints to nail this down are welcome.
>>
>> Greetings Stefan Majer
>>
>> May 10 15:26:40 os02 kernel: [ 3652.485219] cosd: page allocation
>> failure. order:2, mode:0x4020
>
> It looks like the machine running the cosd is crashing, is that the case?
> Are you running both ceph kernel module on the same machine by any

that should be "both the osd and the kernel module"

> chance? If not, it can be some other fs bug (e.g., the underlying
> btrfs). Also, the stack here is quite deep, there's a chance for a
> stack overflow.
>
> Thanks,
> Yehuda
>
