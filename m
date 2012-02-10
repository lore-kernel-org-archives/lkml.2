Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab2BJPbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:31:21 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35806 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2BJPbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:31:20 -0500
Message-ID: <4F353840.8050505@polito.it>
Date: Fri, 10 Feb 2012 16:31:12 +0100
From: Roberto Sassu <roberto.sassu@polito.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: initramfs@vger.kernel.org, Harald Hoyer <harald@redhat.com>,
        linux-kernel@vger.kernel.org, systemd-devel@lists.freedesktop.org,
        selinux@lists.fedoraproject.org
Subject: Re: dracut: ordering of modules
References: <1328886121.2472.19.camel@falcor>
In-Reply-To: <1328886121.2472.19.camel@falcor>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mimi

i'm CCing the systemd and Fedora SELinux mailing lists.

Unfortunately, the SELinux policy initialization (at least
in Fedora 16) has been moved to systemd, so, now, loading an
IMA policy cannot be done in the initial ramdisk.

Further, the SELinux policy loading code is not in a unit file
but embedded in the main binary, which means that the new code for
loading IMA policies must be added just after that point.

I already wrote a patch for this. I need some time to test it
and will post in the systemd mailing list at the beginning of
the next week.

Roberto Sassu


On 02/10/2012 04:01 PM, Mimi Zohar wrote:
> Hi Harald,
>
> Originally, 98integrity/ima-policy-load.sh didn't start executing before
> 98selinux/selinux-loadpolicy.sh finished, but unfortunately it now does.
>
> inst_hook pre-pivot 50 "$moddir/selinux-loadpolicy.sh"
> inst_hook pre-pivot 62 "$moddir/ima-policy-load.sh"
>
> As the IMA policy could be dependent on LSM runtime info, this is a
> problem.
>
> [   10.040574] type=1805 audit(1328865524.387:2): action="dont_measure" fsmagic="0x9fa0" res=0
> [   10.040663] type=1805 audit(1328865524.387:3): action="dont_appraise" fsmagic="0x9fa0" res=0
> [   10.040729] type=1805 audit(1328865524.387:4): action="dont_measure" fsmagic="0x62656572" res=0
> [   10.040792] type=1805 audit(1328865524.387:5): action="dont_appraise" fsmagic="0x62656572" res=0
> [   10.040857] type=1805 audit(1328865524.387:6): action="dont_measure" fsmagic="0x64626720" res=0
> [   10.040921] type=1805 audit(1328865524.387:7): action="dont_appraise" fsmagic="0x64626720" res=0
> [   10.040985] type=1805 audit(1328865524.387:8): action="dont_measure" fsmagic="0x01021994" res=0
> [   10.041047] type=1805 audit(1328865524.387:9): action="dont_appraise" fsmagic="0x01021994" res=0
> [   10.041113] type=1805 audit(1328865524.387:10): action="dont_measure" fsmagic="0x73636673" res=0
> [   10.041177] type=1805 audit(1328865524.387:11): action="dont_appraise" fsmagic="0x73636673" res=0
> [   11.898956] SELinux:  Completing initialization.
>
> I've tried adding a depend for selinux, but it doesn't seem to resolve
> the problem, nor does delaying 98integrity to later.  Any suggestions
> would be appreciated.
>
> thanks,
>
> Mimi
>

