Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab2DIR0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:26:44 -0400
Received: from server1.neighborhoods.net ([207.154.13.48]:52757 "EHLO
	server1.neighborhoods.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab2DIR0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:26:43 -0400
Message-ID: <4F831BD0.3010707@meetinghouse.net>
Date: Mon, 09 Apr 2012 13:26:40 -0400
From: Miles Fidelman <mfidelman@meetinghouse.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, peter.chubb@nicta.com.au,
        michael.d.labriola@gmail.com
Subject: Re: reboot via bios on X86_64?
References: <4F8302B4.8040901@meetinghouse.net> <20120409155155.GA22974@srcf.ucam.org>
In-Reply-To: <20120409155155.GA22974@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the quick response.

Matthew Garrett wrote:
> On Mon, Apr 09, 2012 at 11:39:32AM -0400, Miles Fidelman wrote:
>
>> 1. What's the logic behind this?  Why not enable a bios reboot for 64bit
>> kernels?  Is there any reason why the machine_real_restart code wouldn't
>> work just as well in 64bit mode?  Anybody know the history?
> The bios reboot code requires you to reprogram the CPU to real mode. I
> don't think there's any fundamental reason you can't do that from 64-bit
> mode, but nobody's ever written that code.

That would explain it.  I guess there's a little bit of trickiness 
involved in setting things up before
switching to real mode.

>> 2. Anybody know a workaround, short of patching and compiling a custom
>> kernel? Are there other paths through the reboot code that can
>> invoke a bios
>> reboot?  [Note: someone suggested trying a kexec-reboot, but that's also
>> not supported on my configuration (running over a Xen hypervisor).]
> Windows never uses the equivalent of the BIOS reboot method, so the
> assumption is that if you ever need on Linux to it's because there's a
> bug somewhere else. Does the platform reboot if you run the kernel on
> bare metal rather than under Xen?

No.  Tried all the combinations - w/ and w/o hypervisor, all the 
available kernel options.  Seems
like the only thing that will reboot this particular hardware/bios combo 
is via the bios.

Miles

-- 
In theory, there is no difference between theory and practice.
In practice, there is.   .... Yogi Berra


