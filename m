Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863Ab1EJP4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 11:56:01 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35287 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827Ab1EJP4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 11:56:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=aRadtZrXP6uosqxt3kmoldELsdCUtvOSy7i02H2FRn6JqQePHnAurqFAhW50Ym+9mp
         63Vr5rBB9LkPpCu6L89i323VBs1q+ZeuQ1nPP2RkKByQfjTyfQPs30+ieIuMcBSEwRWo
         cDvFJ0Y2brdHquceoEafG8NqRCStrvh9vwj0s=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=4DNyWaqqjK5sG5O9cNdfpuAqHWA@mail.gmail.com>
References: <BANLkTinr34qmAE8RWVY0Wq_XMfOc0jTUzg@mail.gmail.com>
	<BANLkTi=4DNyWaqqjK5sG5O9cNdfpuAqHWA@mail.gmail.com>
Date: Tue, 10 May 2011 17:55:58 +0200
Message-ID: <BANLkTi=jZ-GA30_54kay3ouoNJvkwbVQ4w@mail.gmail.com>
Subject: Re: Kernel 2.6.38.6 page allocation failure (ixgbe)
From: Stefan Majer <stefan.majer@gmail.com>
To: Yehuda Sadeh Weinraub <yehudasa@gmail.com>
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 10, 2011 at 4:20 PM, Yehuda Sadeh Weinraub
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

No the machine is still running. Even the cosd is still there.

> Are you running both ceph kernel module on the same machine by any
> chance? If not, it can be some other fs bug (e.g., the underlying
> btrfs). Also, the stack here is quite deep, there's a chance for a
> stack overflow.

There is only the cosd running on these machines. We have 3 seperate
mons and clients which uses qemu-rbd.


> Thanks,
> Yehuda
>


Greetings
-- 
Stefan Majer
