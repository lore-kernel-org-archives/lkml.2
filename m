Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab1HGUgJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 16:36:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40567 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab1HGUgH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 16:36:07 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1108051312090.28580@router.home>
References: <20110805010038.GA18148@redhat.com>
	<20110805084614.GA1588@x4.trippels.de>
	<CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com>
	<alpine.DEB.2.00.1108051131440.28580@router.home>
	<20110805163948.GA11113@redhat.com>
	<alpine.DEB.2.00.1108051146180.28580@router.home>
	<20110805165119.GA11593@redhat.com>
	<alpine.DEB.2.00.1108051158400.28580@router.home>
	<20110805171607.GA11703@redhat.com>
	<alpine.DEB.2.00.1108051312090.28580@router.home>
Date: Sun, 7 Aug 2011 23:36:06 +0300
X-Google-Sender-Auth: oMjCJaU6jxI_JF3x1BNUxvTRMRI
Message-ID: <CAOJsxLH8i8U4v4vFsG66Ju21rgP4=G-LGNWrncchgHOBiaQitg@mail.gmail.com>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Dave Jones <davej@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Aug 2011, Dave Jones wrote:
>>  > Argh another debugging code issue. Anyone who sees this please verify that
>>  > it also occurs with debugging off. I ran this code for 9 months in
>>  > various configs but only sporadically with debugging support since that
>>  > switches the lockless stuff.
>>
>> This started turning up immediately as soon as it got merged to mainline.
>> Which leads me to believe no-one is running -next with debugging on either.
>> Perhaps we should force debugging on for a week once per release cycle.

On Fri, Aug 5, 2011 at 9:14 PM, Christoph Lameter <cl@linux.com> wrote:
> I have run some tests over the last hours with kvm and
> CONFIG_SLUB_DEBUG_ON as well as CONFIG_DEBUG_LIST set but (aside from
> other unrelated backtraces in other subsystems) did not see this issue.
>
> Can I get a .config? Maybe that will help.

I haven't been able to reproduce the problem on hardware either.
However, I don't have CONFIG_PREEMPT enabled like Dave and our RCU
options seem to be different:

$ diff -u adamo.config ../linux/.config | grep RCU
 # RCU Subsystem
-CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_PREEMPT_RCU=y
+CONFIG_TREE_RCU=y
+# CONFIG_PREEMPT_RCU is not set
 # CONFIG_RCU_TRACE is not set
 CONFIG_RCU_FANOUT=64
 # CONFIG_RCU_FANOUT_EXACT is not set
+# CONFIG_RCU_FAST_NO_HZ is not set
 # CONFIG_TREE_RCU_TRACE is not set
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=1
-CONFIG_RCU_BOOST_DELAY=500
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_PROVE_RCU=y
-# CONFIG_PROVE_RCU_REPEATEDLY is not set
-CONFIG_SPARSE_RCU_POINTER=y
+# CONFIG_SPARSE_RCU_POINTER is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_RCU_CPU_STALL_TIMEOUT=60
-CONFIG_RCU_CPU_STALL_VERBOSE=y

                               Pekka
