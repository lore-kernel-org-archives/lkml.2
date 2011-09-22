Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab1IVF6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 01:58:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1542 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab1IVF61 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 01:58:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=H8V9vRwbVryyyRagZbcu5QRExPlUdM/4ZDmbkOhrbiaOp16hWAbidRvYEo9olPmEK
	McMw7i0P04ZIniuM3smuQ==
MIME-Version: 1.0
In-Reply-To: <1316393805-3005-2-git-send-email-glommer@parallels.com>
References: <1316393805-3005-1-git-send-email-glommer@parallels.com> <1316393805-3005-2-git-send-email-glommer@parallels.com>
From: Greg Thelen <gthelen@google.com>
Date: Wed, 21 Sep 2011 22:58:04 -0700
Message-ID: <CAHH2K0YNUNAr7SVkPYKCsU_9Cp4v=AhQ0RVBgmwNNRHJWFgUBA@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] Basic kernel memory functionality for the Memory Controller
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, netdev@vger.kernel.org, linux-mm@kvack.org,
        kirill@shutemov.name
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 18, 2011 at 5:56 PM, Glauber Costa <glommer@parallels.com> wrote:
> @@ -270,6 +274,10 @@ struct mem_cgroup {
>         */
>        struct res_counter memsw;
>        /*
> +        * the counter to account for kmem usage.
> +        */
> +       struct res_counter kmem;
> +       /*

I don't see this charged, is this used in a later patch in this series?

> @@ -5665,3 +5754,17 @@ static int __init enable_swap_account(char *s)
>  __setup("swapaccount=", enable_swap_account);
>
>  #endif
> +
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> +static int __init disable_kmem_account(char *s)

Minor nit.  To be consistent with the other memcg __setup options, I
think this should be renamed to enable_kmem_account().

> +{
> +       /* consider enabled if no parameter or 1 is given */
> +       if (!strcmp(s, "1"))
> +               do_kmem_account = 1;
> +       else if (!strcmp(s, "0"))
> +               do_kmem_account = 0;
> +       return 1;
> +}
> +__setup("kmemaccount=", disable_kmem_account);
> +
> +#endif
