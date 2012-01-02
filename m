Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab2ABWVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 17:21:52 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37414 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab2ABWVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 17:21:50 -0500
Message-ID: <4F022DFA.1090105@openvz.org>
Date: Tue, 03 Jan 2012 02:21:46 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20111108 Iceape/2.0.14
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tty: rework pty count limiting
References: <20120102172254.11535.2653.stgit@zurg> <20120102172301.11535.10338.stgit@zurg> <20120102172903.GB19782@suse.de>
In-Reply-To: <20120102172903.GB19782@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Jan 02, 2012 at 09:23:01PM +0400, Konstantin Khlebnikov wrote:
>> After adding devpts multiple-insrances sysctl kernel.pty.max limit pty count for
>> each devpts instance independently, while kernel.pty.nr shows total pty count.
>>
>> This patch restores sysctl kernel.pty.max as global limit (4096 by default),
>> adds pty reseve for main devpts (mounted without "newinstance" argument),
>> and new sysctl to tune it: kernel.pty.reserve (1024 by default)
>>
>> Also it adds devpts mount option "max=%d" to limit pty count for each devpts
>> instance independently. (by default NR_UNIX98_PTY_MAX == 2^20)
>>
>> Thus devpts instances in containers cannot eat up all available pty even if we didn't
>> set any limits, while with "max" argument we can adjust limits more precisely.
>>
>> Plus, now open("/dev/ptmx") return -ENOSPC in case lack of pty indexes,
>> this is more informative than -EIO.
>
> That's a userspace api change, why is this going to be allowed?

open() can return -ENOSPC in case normal fs,
meanwhile error codes for /dev/ptmx wasn't documented at all:
there is nothing in manpage pts, pty and ptmx.
manpage posix_openpt and getpt refers to manpage open(2).
I can return EIO back, if this is critical.

>
> greg k-h
