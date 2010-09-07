Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab0IGQ3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:29:32 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:14295 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757897Ab0IGQ33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:29:29 -0400
Message-ID: <4C866868.6060606@caviumnetworks.com>
Date: Tue, 07 Sep 2010 09:29:28 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: linux-kernel@vger.kernel.org, ralf@linux-mips.org
Subject: Re: commit f6be75d03c88 broke qemu-system-mips64.
References: <201009041754.28716.rob@landley.net>
In-Reply-To: <201009041754.28716.rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Sep 2010 16:29:29.0148 (UTC) FILETIME=[D80ECFC0:01CB4EA9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2010 03:54 PM, Rob Landley wrote:
> linux-2.6.33 booted mips64 to a shell prompt, and 2.6.34 didn't.  The above
> commit is the one that broke it, and if you revert it the result boots again.
>
> To try it yourself, download this mips64 system image:
>
>    http://impactlinux.com/aboriginal/downloads/binaries/system-image-mips64.tar.bz2
>
> Extract it, cd into it, and "./run-emulator.sh".
>
> You'll need QEMU installed.  Note that Ubuntu's qemu package is actually
> kqemu, and doesn't support any non-x86 targets.  You need to install
> "qemu-kvm-extras" to get _actual_ qemu.  I don't know why they broke this.
>
> Once you've confirmed it used to work, replace the zImage-mips64 file with a
> vmlinux built using the attached .config and ./run-emulator.sh again.  If you
> build f6be75d03c88 it fails, but f6be75d03c88^1 works.  If you build 2.6.35
> but revert the f6be75d03c88 patch (all one line of it), it works.  If you don't
> revert it, v2.6.35 is still broken.
>
> Rob

Has anybody tried it on a real 64-bit Malta?  Perhaps the emulator is 
broken.

Rob, did you try to debug it at all?  Where is it going off into the weeds?

David Daney
