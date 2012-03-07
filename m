Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab2CGQnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 11:43:45 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60991 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab2CGQnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 11:43:42 -0500
MIME-Version: 1.0
In-Reply-To: <1331064994-6693-1-git-send-email-siddhesh.poyarekar@gmail.com>
References: <1331045377.17099.2.camel@deneb.redhat.com>
	<1331064994-6693-1-git-send-email-siddhesh.poyarekar@gmail.com>
Date: Wed, 7 Mar 2012 22:13:41 +0530
Message-ID: <CAAHN_R36vR3cnAVjXnoWfe9o46KuSMQcp92be1DKXmpLSVLVDg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: Fix task_nommu build regression in linux-next
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Mark Salter <msalter@redhat.com>
Cc: linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 1:46 AM, Siddhesh Poyarekar
<siddhesh.poyarekar@gmail.com> wrote:
> Commit b7b2a0afacada237005068294cb0ccc49d32889e resulted in a build
> failure for nommu builds:
>
> fs/built-in.o: In function `nommu_vma_show':
> task_nommu.c:(.text+0x564a0): undefined reference to `vm_is_stack'
> make[1]: *** [.tmp_vmlinux1] Error 1
>
> Fix is to provide definitions of vm_is_stack() and
> vm_is_stack_for_task() for nommu as well. This patch also adds an
> explicit include of sched.h based on observations and patch submission
> by Paul Gortmaker <paul.gortmaker@windriver.com>:
>
> https://lkml.org/lkml/2012/3/5/326
>
> Signed-off-by: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>

Tested-by: Mark Salter <msalter@redhat.com>

for c6x (nommu).

-- 
Siddhesh Poyarekar
http://siddhesh.in
