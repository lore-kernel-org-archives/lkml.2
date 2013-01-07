Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab3AGDsn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 22:48:43 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:55587 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3AGDsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 22:48:41 -0500
Message-ID: <50EA4594.9020309@gmail.com>
Date: Sun, 06 Jan 2013 20:48:36 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: PEBS (in perf) stopped working from 3.6 -> 3.7
References: <20130104234743.GA12331@uio.no> <50E770DB.2050803@gmail.com> <20130105010501.GA5371@uio.no>
In-Reply-To: <20130105010501.GA5371@uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/4/13 6:05 PM, Steinar H. Gunderson wrote:
> On Fri, Jan 04, 2013 at 05:16:27PM -0700, David Ahern wrote:
>> Known problem. Pick one of: update perf to 3.7, add H to the command
>> (-e cycles:ppH) or apply this patch:
>> https://lkml.org/lkml/2012/12/28/384
>
> I spoke too soon. This works for cycles, but not for branch-misses:
>
>    pannekake:~> sudo perf record -e branch-misses:ppH -a
>
>      Error: sys_perf_event_open() syscall returned with 95 (Operation not supported) for event branch-misses:ppH. /bin/dmesg may provide additional information.
>
>    No hardware sampling interrupt available. No APIC? If so then you can boot the kernel with the "lapic" boot parameter to force-enable it.
>
> Why would the two be different?

I will make a guess that is processor dependent. On an E5540 with 
3.4.11-1.fc16.x86_64, 3.6.10-2.fc16.x86_64, and 3.8 I get the same 
failure message.

But on a E5620, it works fine with 3.4 and 3.7 (no intermediate kernels 
on that box).

David
