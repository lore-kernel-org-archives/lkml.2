Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab2GTQbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 12:31:04 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38234 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab2GTQbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 12:31:01 -0400
MIME-Version: 1.0
In-Reply-To: <1342741421-17956-1-git-send-email-anton.vorontsov@linaro.org>
References: <20120719142856.GA25184@elgon.mountain>
	<1342741421-17956-1-git-send-email-anton.vorontsov@linaro.org>
Date: Fri, 20 Jul 2012 09:31:00 -0700
X-Google-Sender-Auth: PQkDcS_fq2hcg8MGAj2hnlnsID8
Message-ID: <CAGXu5j+8f=MMoit8Bi+36h177haVM19W-0xpGeiO27cu+dL9Hg@mail.gmail.com>
Subject: Re: [PATCH] pstore/ram: Fix possible NULL dereference
From: Kees Cook <keescook@chromium.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 4:43 PM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> We can dereference 'cxt->cprz' if console and dump logging are disabled
> (which is unlikely, but still possible to do). This patch fixes the issue
> by changing the code so that we don't dereference przs at all, we can
> just calculate bufsize from console_size and record_size values.
>
> Plus, while at it, the patch improves the buffer size calculation.
>
> After Kay's printk rework, we know the optimal buffer size for console
> logging -- it is LOG_LINE_MAX (defined privately in printk.c). Previously,
> if only console logging was enabled, we would allocate unnecessary large
> buffer in pstore, while we only need LOG_LINE_MAX. (Pstore console logging
> is still capable of handling buffers > LOG_LINE_MAX, it will just do
> multiple calls to psinfo->write).
>
> Note that I don't export the constant, since we will do even a better
> thing soon: we will switch console logging to a new write_buf API, which
> will eliminate the need for the additional buffer; and so we won't need
> the constant.
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
