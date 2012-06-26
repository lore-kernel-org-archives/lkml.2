Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab2FZGHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 02:07:33 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:51542 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757135Ab2FZGHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 02:07:32 -0400
Message-ID: <4FE951A0.8040900@secunet.com>
Date: Tue, 26 Jun 2012 08:07:28 +0200
From: Torsten Hilbrich <torsten.hilbrich@secunet.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: "Richard W.M. Jones" <rjones@redhat.com>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel 3.3.8 breaks accidental ext3 mount of extended partition
References: <4FDEC3C2.4060909@secunet.com> <20120625113457.GA1289@amd.home.annexia.org> <x49r4t3z6s4.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49r4t3z6s4.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2012 06:07:29.0636 (UTC) FILETIME=[F7B4B240:01CD5361]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.06.2012 18:38, schrieb Jeff Moyer:
> "Richard W.M. Jones" <rjones@redhat.com> writes:
> 
>> On Mon, Jun 18, 2012 at 07:59:30AM +0200, Torsten Hilbrich wrote:
>>> Hello,
>>>
>>> a software that tries to mount each existing partition as ext3 file system started to fail when updating from v3.3.7 to v3.3.8.
>>>
>>> The applications then hangs-up in the mount syscall, here is a snapshot of its stack at this moment:
>>
>> We just ran into what we think is the same problem.
>>
>> Note that ext4 fails like this for any 1024 byte sized filesystem (of
>> zeroes) that you try to mount.  It's really nothing to do with
>> extended partitions.
>>
>> Here is a very simple reproducer + stack trace:
>>
>>   https://bugzilla.redhat.com/show_bug.cgi?id=835019#c4
>>
>> I will try out the patch suggested later on in this thread.
> 
> Please try the attached patch instead.  The patch I had originally
> posted for this allowed marking the first buffer beyond EOD as
> uptodate.  This isn't correct.  The patch I've attached below fixes the
> infinite loop in __getblk_slow.

This patch also fixes the ext3 mount problem on extented partition.

	Torsten
