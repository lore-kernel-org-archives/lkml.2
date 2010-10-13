Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab0JMV2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 17:28:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59242 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab0JMV2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 17:28:54 -0400
Message-ID: <4CB6245E.8080007@zytor.com>
Date: Wed, 13 Oct 2010 14:27:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Bob Picco <bpicco@redhat.com>,
        Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        "Horst H. von Brand" <vonbrand@inf.utfsm.cl>,
        linux-kernel@vger.kernel.org, Stefan Becker <chemobejk@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v3 4/6] x86/PCI: allocate space from the end of a region,
 not the beginning
References: <20101013161359.28476.6050.stgit@bob.kio> <20101013161526.28476.42395.stgit@bob.kio>
In-Reply-To: <20101013161526.28476.42395.stgit@bob.kio>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2010 09:15 AM, Bjorn Helgaas wrote:
>  
> +#define ALIGN_DOWN(x, a)	((x) & ~(a - 1))
> -	resource_size_t start = res->start;
> +	resource_size_t start = ALIGN_DOWN(res->end - size + 1, align);
>  

Use round_down() here instead of inventing yet another macro?

In all other respects:

Reviewed-by: H. Peter Anvin <hpa@linux.intel.com>

	-hpa
