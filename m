Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935416Ab1JEVwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 17:52:12 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50834 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab1JEVwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 17:52:10 -0400
MIME-Version: 1.0
In-Reply-To: <4E898284.7060906@linux.vnet.ibm.com>
References: <CAG1a4rvdYnOSWu3DJ+DL+Q_bfsfTv_px20vP06fBKRm6B8cwMw@mail.gmail.com>
 <4E898284.7060906@linux.vnet.ibm.com>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Wed, 5 Oct 2011 17:51:39 -0400
Message-ID: <CAG1a4rtzAOBQPrOjyeyrfMZOBdC58WeVytJJ--K=i-ikLQeqQQ@mail.gmail.com>
Subject: Re: Full lockup when compiling kernel with "optimal" number of threads
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 3, 2011 at 5:38 AM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 09/03/2011 09:04 AM, Pavel Ivanov wrote:
>> Hi,
>>
>> I can reliably reproduce a complete machine lockup when compiling
>> kernel sources with "make -j". After making some progress machine
>> stops responding to anything (including CapsLock/NumLock switching or
>> mouse moving) and after hard reboot nothing is left in kern.log or
>> syslog. Only attaching a serial console gives me the following clues
>> to what happens:
>>
>
> [...]
>
>> After that only doing "make distclean" allows me to compile kernel
>> again. And note that when I build with "make -j 10" everything works
>> fine (I have 2 CPUs with 4 cores each without hyper-threading).
>
> How much memory does your system have? Doing so many fork()s could cause
> a lot of resource conflict and memory pressure leading to heavy swapping
> etc., which can ultimately hang your system, especially when your RAM
> size is small. It is advisable to use make -j only on systems with lot
> of RAM (> 3 or 4GB).

I have 8GB of RAM. And it looks like you are at least partially right.
As I turn my swap off I don't see warnings about hung tasks anymore.
Lots of OOM killer messages pile up instead of that. But still even
when messages from OOM killer stop coming my machine remains
completely unusable. It doesn't react to key presses (NumLock and
CapsLock indicators don't work), display has no signal, and there's no
disk activity at all. Is it considered acceptable?


Pavel
