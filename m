Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab1J1STn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 14:19:43 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10968 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab1J1STm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 14:19:42 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6513"; a="131812278"
Message-ID: <4EAAF23C.8050102@codeaurora.org>
Date: Fri, 28 Oct 2011 11:19:40 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Miche Baker-Harvey <miche@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, Amit Shah <amit.shah@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] VirtioConsole support.
References: <20111027173527.GA23839@phenom.dumpdata.com>  <1319751802-27013-1-git-send-email-miche@google.com> <1319770558.2529.20.camel@Joe-Laptop>
In-Reply-To: <1319770558.2529.20.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/11 19:55, Joe Perches wrote:
>
> @@ -845,6 +857,19 @@ struct hvc_struct *hvc_alloc(uint32_t vtermno, int data,
>  	kref_init(&hp->kref);
>  
>  	INIT_WORK(&hp->tty_resize, hvc_set_winsz);
> +	/*
> +	 * make each console its own struct console.
> +	 * No need to do allocation and copy under lock.
> +	 */
> +	cp = kzalloc(sizeof(*cp), GFP_KERNEL);
> +	if (!cp) {
> +		kfree(hp);
> +		mutex_unlock(&hvc_ports_mutex);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +	memcpy(cp, &hvc_console, sizeof(*cp));
> The kzalloc should be kmalloc as the allocated
> memory is immediately overwritten.

Even better would be kmemdup().

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

