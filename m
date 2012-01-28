Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab2A1UwL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 15:52:11 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:52624 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2A1UwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 15:52:09 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Dave Jones <davej@redhat.com>, kexec@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG: unable to handle kernel paging request at ffffc7ff81000398 (sys_kexec_load)
References: <1327212367.32115.4.camel@lappy>
	<m1lip0s5nt.fsf@fess.ebiederm.org> <1327763490.16907.1.camel@lappy>
Date: Sat, 28 Jan 2012 12:54:43 -0800
In-Reply-To: <1327763490.16907.1.camel@lappy> (Sasha Levin's message of "Sat,
	28 Jan 2012 10:11:30 -0500")
Message-ID: <m1y5sro8do.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18d8r+UUny4V9dg4SDvYKAUbYKd51dPUb4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <levinsasha928@gmail.com> writes:

> On Sat, 2012-01-21 at 20:49 -0800, Eric W. Biederman wrote:
>> Interesting.
>> 
>> The fact that this happens in native_set_pte would suggest that we are
>> trying to write to a page table that does not exist.  So this might
>> be a layer below kexec_load that has the problem.
>> 
>> Do you have the kernel you were testing?    A disassembly of the
>> native_set_pte, machine_kexec_prepare and sys_kexec_load
>> would be interesting, for attempting to trace this back to what went
>> wrong.
>
> I did some work into investigating it today, looks like it's simple to trigger it using the following code:
>
> 	#include <fcntl.h>
> 	int main(void)
> 	{
> 		char dummy[4096] = {0};
> 		syscall(246, 0xffffffff81008000, 1, dummy, 2);
> 		return 0;
> 	}
>
> I'll continue trying to figure out whats wrong, but hopefully this
> lead will help in reproducing it easily.

Yes that helps, and that matches the backtrace.

So the question becomes why does a strange entry point address cause problems.

Eric
