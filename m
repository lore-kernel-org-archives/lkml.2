Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab1IVCwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 22:52:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63313 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab1IVCwI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 22:52:08 -0400
MIME-Version: 1.0
In-Reply-To: <4E7A46C0.6010804@am.sony.com>
References: <4E7A46C0.6010804@am.sony.com>
Date: Thu, 22 Sep 2011 10:52:06 +0800
Message-ID: <CAGn38=3WmX0rORerbCapDSD5Gu4tg-Un3ROKpXtrs1DPyqDeFw@mail.gmail.com>
Subject: Re: [Kgdb-bugreport] [PATCH] kdb: Avoid using dbg_io_ops until it is initialized
From: Dongdong Deng <libfetion@gmail.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 4:19 AM, Tim Bird <tim.bird@am.sony.com> wrote:
> This fixes a bug with setting a breakpoint during kdb initialization
> (from kdb_cmds).  Any call to kdb_printf() before the initialization
> of the kgdboc serial console driver (which happens much later during
> bootup than kdb_init), results in kernel panic due to the use of
> dbg_io_ops before it is initialized.


Did you get the panic for that case?

Dongdong


>
> Signed-off-by: Tim Bird <tim.bird@am.sony.com>
> ---
>  kernel/debug/kdb/kdb_io.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
> index c9b7f4f..3bc995f 100644
> --- a/kernel/debug/kdb/kdb_io.c
> +++ b/kernel/debug/kdb/kdb_io.c
> @@ -675,7 +675,7 @@ kdb_printit:
>        if (!dbg_kdb_mode && kgdb_connected) {
>                gdbstub_msg_write(kdb_buffer, retlen);
>        } else {
> -               if (!dbg_io_ops->is_console) {
> +               if (dbg_io_ops && !dbg_io_ops->is_console) {
>                        len = strlen(kdb_buffer);
>                        cp = kdb_buffer;
>                        while (len--) {
> --
> 1.7.2.3
>
>
>
> ------------------------------------------------------------------------------
> All the data continuously generated in your IT infrastructure contains a
> definitive record of customers, application performance, security
> threats, fraudulent activity and more. Splunk takes this data and makes
> sense of it. Business sense. IT sense. Common sense.
> http://p.sf.net/sfu/splunk-d2dcopy1
> _______________________________________________
> Kgdb-bugreport mailing list
> Kgdb-bugreport@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/kgdb-bugreport
>
