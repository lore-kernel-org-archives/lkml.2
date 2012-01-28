Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab2A1PLb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 10:11:31 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36199 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab2A1PLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 10:11:30 -0500
Message-ID: <1327763490.16907.1.camel@lappy>
Subject: Re: BUG: unable to handle kernel paging request at ffffc7ff81000398
 (sys_kexec_load)
From: Sasha Levin <levinsasha928@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Jones <davej@redhat.com>, kexec@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Sat, 28 Jan 2012 10:11:30 -0500
In-Reply-To: <m1lip0s5nt.fsf@fess.ebiederm.org>
References: <1327212367.32115.4.camel@lappy>
	 <m1lip0s5nt.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-01-21 at 20:49 -0800, Eric W. Biederman wrote:
> Interesting.
> 
> The fact that this happens in native_set_pte would suggest that we are
> trying to write to a page table that does not exist.  So this might
> be a layer below kexec_load that has the problem.
> 
> Do you have the kernel you were testing?    A disassembly of the
> native_set_pte, machine_kexec_prepare and sys_kexec_load
> would be interesting, for attempting to trace this back to what went
> wrong.

I did some work into investigating it today, looks like it's simple to trigger it using the following code:

	#include <fcntl.h>
	int main(void)
	{
		char dummy[4096] = {0};
		syscall(246, 0xffffffff81008000, 1, dummy, 2);
		return 0;
	}

I'll continue trying to figure out whats wrong, but hopefully this lead will help in reproducing it easily.

-- 

Sasha.

