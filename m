Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab2CGK7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 05:59:09 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61541 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab2CGK7G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 05:59:06 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: m.szyprowski@samsung.com, "Barry Song" <Barry.Song@csr.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, "Barry Song" <Baohua.Song@csr.com>
Subject: Re: [PATCH v3] MM: CMA: add a simple kernel module as the helper to
 test CMA
References: <1331090098-25097-1-git-send-email-Barry.Song@csr.com>
Date: Wed, 07 Mar 2012 11:59:03 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wasrgptm3l0zgt@mpn-glaptop>
In-Reply-To: <1331090098-25097-1-git-send-email-Barry.Song@csr.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!  Some minor comments, hopefully last ones:

On Wed, 07 Mar 2012 04:14:58 +0100, Barry Song <Barry.Song@csr.com> wrote:
> +static ssize_t
> +cma_test_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
> +{

[...]

> +	_dev_info(cma_dev, "free: CM virt: %p dma: %p size:%uK\n",

This should read: “size: %zuK”.  “z” is the proper modifier to use for size_t type.

> +		alloc->virt, (void *)alloc->dma, alloc->size / SZ_1K);
> +	kfree(alloc);
> +
> +	return 0;
> +}

> +static ssize_t
> +cma_test_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
> +{
> +	struct cma_allocation *alloc;
> +	size_t size;
> +	int ret;
> +
> +	ret = kstrtouint_from_user(buf, count, 0, &size);

kstrtouint_from_user() expects pointer to unsigned int, size_t is not always
unsigned int.  It may be unsigned long.  As such, size should be of type
unsigned long and this line should use kstrtoulong_from_user().

[...]

> +	if (alloc->virt) {
> +		_dev_info(cma_dev, "alloc: virt: %p dma: %p size: %uK\n",
> +			alloc->virt, (void *)alloc->dma, size);

Like previously, this should be “size: %zuK”.

[...]

> +}

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
