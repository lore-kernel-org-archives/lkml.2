Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab2GYCt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 22:49:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55915 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab2GYCt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 22:49:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120724181044.GC25671@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
	<1343149213-10160-2-git-send-email-ming.lei@canonical.com>
	<20120724181044.GC25671@aftab.osrc.amd.com>
Date: Wed, 25 Jul 2012 10:49:24 +0800
Message-ID: <CACVXFVMftSSvKkrXxV+PNSu2_sXeTTsY8ZMzdOHgK9bAE6z8pg@mail.gmail.com>
Subject: Re: [RFC PATCH 01/13] driver core: firmware loader: simplify pages
 ownership transfer
From: Ming Lei <ming.lei@canonical.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 2:10 AM, Borislav Petkov <bp@amd64.org> wrote:
>>
>> +/* transfer the ownership of pages to firmware */
>> +static void fw_set_page_data(struct firmware_priv *fw_priv)
>> +{
>> +     struct firmware *fw = fw_priv->fw;
>> +
>> +     fw_priv->data = vmap(fw_priv->pages, fw_priv->nr_pages,
>> +                             0, PAGE_KERNEL_RO);
>
> We don't need to check the return value of vmap() here like we do above?

Good catch, it should be handled, otherwise may cause oops inside driver.

If that happens, the pages buffer should be dropped and return failure
from request_firmware or the callback of request_firmware_nowait.

I will fix it against this patch set if cache/uncache firmware can be
accepted.

Thanks,
--
Ming Lei
