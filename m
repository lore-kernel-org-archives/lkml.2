Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab1FOVtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 17:49:46 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:44083 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab1FOVto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:49:44 -0400
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jun 2011 17:49:44 EDT
Message-ID: <4DF9271E.2060701@codemonkey.ws>
Date: Wed, 15 Jun 2011 16:41:50 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Prasad Joshi <prasadjoshi124@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
References: <1308153214.7566.6.camel@jaguar>
In-Reply-To: <1308153214.7566.6.camel@jaguar>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2011 10:53 AM, Pekka Enberg wrote:
> Hi all,
>
> We’re proud to announce the second version of the Native Linux KVM tool! We’re
> now officially aiming for merging to mainline in 3.1.
>
> Highlights:
>
> - Experimental GUI support using SDL and VNC
>
> - SMP support. tools/kvm/ now has a highly scalable, largely lockless driver
>    interface and the individual drivers are using finegrained locks.
>
> - TAP-based virtio networking
>
> - Fast QCOW2 image read-write support beating Qemu in fio benchmarks. See the
>    following URL for test result details: https://gist.github.com/1026888

What was the commit hash for the QEMU you tested?

The following caused a major regression in qcow2:


commit a16c53b101a9897b0b2be96a1bb3bde7c04380f2
Author: Anthony Liguori <aliguori@us.ibm.com>
Date:   Mon Jun 6 08:25:06 2011 -0500

     Fix regression introduced by -machine accel=

     Commit 85097db6 changed the timing when kvm_allowed is set until after
     kvm is initialized.  During initialization, the ioeventfd 
initialization cod
     checks kvm_enabled() and after this change, ioeventfd is 
effectively disable

If it's not in your tree, it would be useful to rerun the test with the 
latest git.

Regards,

Anthony Liguori
