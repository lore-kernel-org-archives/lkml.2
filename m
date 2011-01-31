Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab1AaPBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 10:01:48 -0500
Received: from mail.windriver.com ([147.11.1.11]:58382 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab1AaPBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 10:01:47 -0500
Message-ID: <4D46CEBA.6030508@windriver.com>
Date: Mon, 31 Jan 2011 09:01:14 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Kallol Biswas <nucleodyne@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: segmentation fault running under kgdb
References: <AANLkTi=FzQPkt1pogJ7BdEtF_nUgTZU5_u3RBX1v0_R2@mail.gmail.com>
In-Reply-To: <AANLkTi=FzQPkt1pogJ7BdEtF_nUgTZU5_u3RBX1v0_R2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jan 2011 15:01:15.0703 (UTC) FILETIME=[B53AB470:01CBC157]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2011 08:30 PM, Kallol Biswas wrote:
>
> Here is the stack trace:
> (gdb) bt
> #0  kref_put (kref=0xffffffffffffffc9, release=0xffffffff8127b560
> <aa_free_profile_kref>) at lib/kref.c:67
> #1  0xffffffff8127b069 in aa_put_profile (udata=0xffff8801b7600000,
> size=<value optimized out>, add_only=<value optimized out>) at
> security/apparmor/include/policy.h:295

I have no idea about how apparmor works, but this looks like a legitimate kernel crash and kgdb is catching, just as I would expect.  If you want to continue on and pass the signal to the kernel's die notification system at the gdb prompt enter:

signal 9

I would recommend understanding the cause of each crash because because any null dereferences would lead me to wonder about the stability of the kernel you are running.

Jason.
