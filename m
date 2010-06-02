Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab0FBJuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:50:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42730 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939Ab0FBJuF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:50:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eCaFvjsTDMfeAnNVSDNEjzg1QH/IRXZ2fPgfMeLKRgl87XE9vKbH8jVCx0NdzLYLBw
         htM0D3mvTCdYvjgoKgmUQrnR4zRUkmcD0ZqhLCzVZqzjmOQbmkDzV/8+Iu0junQCgl2G
         XcdT924ZYvlKbgqp5YQBwGz4+Qn9za12chrsM=
MIME-Version: 1.0
In-Reply-To: <1275464359-1566-3-git-send-email-v.mayatskih@gmail.com>
References: <1275464359-1566-1-git-send-email-v.mayatskih@gmail.com>
	<1275464359-1566-3-git-send-email-v.mayatskih@gmail.com>
Date: Wed, 2 Jun 2010 12:50:03 +0300
X-Google-Sender-Auth: AZf1F7X7-a2AUJ0n06XkSMHlVyI
Message-ID: <AANLkTinrOEg4b0cc2gKppw6bi4xvz4fveWmqAj6SPlvZ@mail.gmail.com>
Subject: Re: [PATCH 2/5] x86: Split __show_regs()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 10:39 AM, Vitaly Mayatskikh
<v.mayatskih@gmail.com> wrote:
> __show_regs dumps content of pt_regs and does other things beside
> it. This patch moves pt_regs dumping part into separate function:
> __show_main_regs.
>
> Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>

[snip]

> +void __show_regs(struct pt_regs *regs, int all)
> +{
> +       unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
> +       unsigned long d0, d1, d2, d3, d6, d7;
> +
> +

Nitpick: extra newline here.

> +       show_regs_common();
> +
> +       __show_main_regs(regs);
>
>        if (!all)
>                return;
