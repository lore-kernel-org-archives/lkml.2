Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab2FLLB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 07:01:56 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43457 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab2FLLBy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 07:01:54 -0400
MIME-Version: 1.0
In-Reply-To: <1339183331-4108-1-git-send-email-devendra.aaru@gmail.com>
References: <1339183331-4108-1-git-send-email-devendra.aaru@gmail.com>
Date: Tue, 12 Jun 2012 13:01:53 +0200
Message-ID: <CACRpkdb0TefNMcXyTRkz6Kv5FifJMmSoXzFTQgKhCt6B0T5sDA@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: pinctrl-imx: free allocated pinctrl_map
 structure only once and use kernel facilities for IMX_PMX_DUMP
From: Linus Walleij <linus.walleij@linaro.org>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Dong Aisheng <aisheng.dong@freescale.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 9:22 PM, Devendra Naga <devendra.aaru@gmail.com> wrote:

> a) as we allocate the pinctrl_map structure at imx_dt_node_to_map at  line 167, anyway
>   if its an element, or a num_elements * (sizeof(type)) elements allocated to one single
>   pointer must be freed only once.
>
> CASE. A)
>
> as new_map is not moved and allocated like,
>
> for (i = 0; i < MAX_ELEMS; i++) {
>    new_map[i] = kmalloc(numelems * size, GFP_KERNEL);
> }
>
> its freed as
>
> for (i = 0; i < MAX_ELEMS; i++) {
>    kfree(new_map[i]);
> }
>
> CASE. B)
> and its allocated like
>        new_map = kmalloc(numelems * size, GFP_KERNEL);
>
> it just needs kfree not as case A's.
>
> b) use KERN_DEBUG facility for the IMX_PMX_DUMP macro.
>
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

OK I applied this, which I *think* is the last version of the patch,
please double-check that the right one is in my git.

This was send the 9th but not tagged v3 so I was a bit confused...

Yours,
Linus Walleij
