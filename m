Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518Ab0DHKM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 06:12:29 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:45895 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab0DHKM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 06:12:27 -0400
Message-ID: <4BBDAC02.500@lumino.de>
Date: Thu, 08 Apr 2010 12:12:18 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-2.3 Thunderbird/3.0.4
MIME-Version: 1.0
To: Giuseppe Calderaro <giuseppecalderaro@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       nios2-dev <nios2-dev@sopc.et.ntust.edu.tw>
Subject: Re: atomic RAM ?
References: <4BBD86A5.5030109@lumino.de> <k2gbca41b4c1004080243nc45a10aereaae18557808c943@mail.gmail.com>
In-Reply-To: <k2gbca41b4c1004080243nc45a10aereaae18557808c943@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 11:43 AM, Giuseppe Calderaro wrote:
>
> In the past I used the mutex connected to the avalon bus to get atomic
> test and set instructions:
> http://www.altera.com/literature/hb/nios2/n2cpu_nii51020.pdf
>
Of course I do know the Altera hardware Mutex, but same just implements
a single Mutex. To allow for FUTEX, which is the base of doing threaded
application with the pthread functions provided by libc, the application
programmer can create any number of pthread_mutex'es (of course a decent
restriction by hardware to some 1000 would usually not harm with typical
embedded applications).

Of course a multithreaded application should not be done in an
architecture depending way, but should be compilable for any arch and
thus the count of allowable pthread_mutex'es should not be greatly
restricted by the underlying hardware (be it NIOS or whatever else).

Of course you are right that using custom instructions to do a decent
count of atomic (hardware-) mutex'es necessary for implementing decent
SMP aware FUTEX (or even Kernel Mutex) stuff with NIOS and similar archs
is not strictly necessary, but I think it's handy to use them instead of
I/O-elements, as the MMU would disallow user space access to "normal"
I/O addresses.

Michael
