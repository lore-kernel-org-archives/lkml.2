Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab0IXSAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:00:09 -0400
Received: from claw.goop.org ([74.207.240.146]:48037 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601Ab0IXSAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:00:08 -0400
Message-ID: <4C9CE726.2070204@goop.org>
Date: Fri, 24 Sep 2010 11:00:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: James Dingwall <james.dingwall@amdocs.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Greg KH <gregkh@suse.de>, Stable Kernel <stable@kernel.org>
Subject: Re: PROBLEM: [BISECTED] 2.6.35.5 xen domU panics just after the boot
References: <3B7AEC3C7FCC864282DFAC9A56A7BA363D81475787@UKLNDMAIL1.corp.amdocs.com>
In-Reply-To: <3B7AEC3C7FCC864282DFAC9A56A7BA363D81475787@UKLNDMAIL1.corp.amdocs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 09/23/2010 08:23 AM, James Dingwall wrote:
>> I was experiencing the same immediate crash with a null pointer
>> dereference (log below) on boot with 2.6.35.5.  Reverting
>> fb412a178502dc498430723b082a932f797e4763 also resolved the problem for
>> me.
> Checking the diff from this commit it looks like there is a typo in the patch.  With the following (probably mangled by my client) I get 2.6.35.5 to boot.  Suggest it should be a candidate for .32 and .35 stable trees.

Yes, that would do it.  Upstream is OK, so it looks like this crept in
when being cherry-picked into stable-2.6.32/master and stable-2.6.35/master.

    J

> --- drivers/xen/events.c.orig   2010-09-23 16:10:34.257124313 +0100
> +++ drivers/xen/events.c        2010-09-23 16:10:44.326194462 +0100
> @@ -935,7 +935,7 @@
>  	.retrigger		= retrigger_dynirq,
>  };
>
> -static struct irq_chip en_percpu_chip __read_mostly = {
> +static struct irq_chip xen_percpu_chip __read_mostly = {
>  	.name			= "xen-percpu",
>
>  	.disable		= disable_dynirq,
>
> James
> This message and the information contained herein is proprietary and confidential and subject to the Amdocs policy statement,
> you may review at http://www.amdocs.com/email_disclaimer.asp
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

