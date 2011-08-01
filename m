Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab1HANWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 09:22:54 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:57581 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab1HANWt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 09:22:49 -0400
MIME-Version: 1.0
In-Reply-To: <20110801131137.GA10508@albatros>
References: <CAOLZvyEQNS3dwQ+6bh2o6kADp7Gd3xOpah8y1_AhqJ2FWSP9VA@mail.gmail.com>
	<20110801131137.GA10508@albatros>
Date: Mon, 1 Aug 2011 15:22:48 +0200
Message-ID: <CAOLZvyHaXcQ0RK8SNX+tTtQ=fJsLq9LxpyszCF82sK985XWQJg@mail.gmail.com>
Subject: Re: shm broken on MIPS in current -git
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, Linux-MIPS <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 3:11 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> On Mon, Aug 01, 2011 at 14:51 +0200, Manuel Lauss wrote:
>> Commits 5774ed014f02120db9a6945a1ecebeb97c2acccb
>> (shm: handle separate PID namespaces case)
>> and 4c677e2eefdba9c5bfc4474e2e91b26ae8458a1d
>> (shm: optimize locking and ipc_namespace getting)
>> break on my MIPS systems.
>
> Can you please identify what commit breaks the system?

Reverting this one fixes the oops for good:

5774ed014f02120db9a6945a1ecebeb97c2acccb
 (shm: handle separate PID namespaces case)


>>  The following oops is
>> printed on boot, and as a result, more than  300 zombie kworker
>> kernel processes are resident.  I don't see this oops on x86 or x64.
>
> Do you have the same configs for x86 and mips?

MIPS is UP, SLAB without preempt, x86 is UP/SMP, SLUB with preempt.
It's not SLAB/SLUB and not preempt, and both MIPS+x86 have all
namespace options enabled.

both configs are temporarily available here:
http://mlau.at/config-mips
http://mlau.at/config-x64

Thanks!
     Manuel Lauss
