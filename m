Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab3AEAQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 19:16:34 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59275 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab3AEAQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 19:16:32 -0500
Message-ID: <50E770DB.2050803@gmail.com>
Date: Fri, 04 Jan 2013 17:16:27 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: PEBS (in perf) stopped working from 3.6 -> 3.7
References: <20130104234743.GA12331@uio.no>
In-Reply-To: <20130104234743.GA12331@uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/4/13 4:47 PM, Steinar H. Gunderson wrote:
> [Please Cc me on any replies; I'm not subscribed to lkml]
>
> Hi,
>
> I recently upgraded from 3.6.5 to 3.7.1 to get around some MM issues that
> have been bothering me. However, it appears it broke PEBS:
>
>    pannekake:/usr/src/linux-3.7.1# perf record -a -e cycles:pp
>
>    Error: sys_perf_event_open() syscall returned with 95 (Operation not supported).  /bin/dmesg may provide additional information.
>
>    Fatal: No hardware sampling interrupt available. No APIC? If so then you can boot the kernel with the "lapic" boot parameter to force-enable it.

Known problem. Pick one of: update perf to 3.7, add H to the command (-e 
cycles:ppH) or apply this patch: https://lkml.org/lkml/2012/12/28/384

David
