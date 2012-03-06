Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030520Ab2CFPT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 10:19:59 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38128 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965153Ab2CFPT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 10:19:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of siddhesh.poyarekar@gmail.com designates 10.236.116.66 as permitted sender) smtp.mail=siddhesh.poyarekar@gmail.com; dkim=pass header.i=siddhesh.poyarekar@gmail.com
MIME-Version: 1.0
In-Reply-To: <1331045377.17099.2.camel@deneb.redhat.com>
References: <1331045377.17099.2.camel@deneb.redhat.com>
Date: Tue, 6 Mar 2012 20:49:57 +0530
Message-ID: <CAAHN_R2++cosPPdEsO=7ztfKJt9+Fi+iTje6o34EVvZ9kD1EtQ@mail.gmail.com>
Subject: Re: nommu build failure in linux-next
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Mark Salter <msalter@redhat.com>
Cc: linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 8:19 PM, Mark Salter <msalter@redhat.com> wrote:
> commit b7b2a0afacada237005068294cb0ccc49d32889e
> Author: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
> Date:   Tue Mar 6 11:17:12 2012 +1100
>
>    procfs: mark thread stack correctly in proc/<pid>/maps
>
>
> This patch still breaks nommu builds. The previous syntax issue has been
> resolved, but now I see a link error:
>
> fs/built-in.o: In function `nommu_vma_show':
> task_nommu.c:(.text+0x564a0): undefined reference to `vm_is_stack'
> make[1]: *** [.tmp_vmlinux1] Error 1
>

The function is defined in mm/memory.c and I realized now that it is
not built when !CONFIG_MMU. There needs to be a copy of these
functions in nommu.c as well. I'll test the build and send a patch.


-- 
Siddhesh Poyarekar
http://siddhesh.in
