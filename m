Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab2HCIev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 04:34:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41020 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab2HCIer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 04:34:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120725143750.GE11152@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
	<1343149213-10160-7-git-send-email-ming.lei@canonical.com>
	<20120725143750.GE11152@aftab.osrc.amd.com>
Date: Fri, 3 Aug 2012 16:34:45 +0800
Message-ID: <CACVXFVOyfotorQFMirv9kMeT0SDmxzo_MLAk8uvWf8wK=x3YpA@mail.gmail.com>
Subject: Re: [RFC PATCH 06/13] driver core: firmware loader: always let
 firmware_buf own the pages buffer
From: Ming Lei <ming.lei@canonical.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 10:37 PM, Borislav Petkov <bp@amd64.org> wrote:
> On Wed, Jul 25, 2012 at 01:00:06AM +0800, Ming Lei wrote:

>> @@ -213,13 +291,8 @@ static ssize_t firmware_loading_show(struct device *dev,
>>  /* firmware holds the ownership of pages */
>>  static void firmware_free_data(const struct firmware *fw)
>>  {
>> -     int i;
>> -     vunmap(fw->data);
>> -     if (fw->pages) {
>> -             for (i = 0; i < PFN_UP(fw->size); i++)
>> -                     __free_page(fw->pages[i]);
>> -             kfree(fw->pages);
>> -     }
>> +     WARN_ON(!fw->priv);
>> +     fw_free_buf(fw->priv);
>
> Why the WARN_ON?

Because the 'struct firmware' instance is exposed to drivers, it is
better to warn if some drivers clear it during request&release.

Thanks,
--
Ming Lei
