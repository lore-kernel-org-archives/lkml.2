Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab2GZC7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 22:59:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32862 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2GZC7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 22:59:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120725160425.GK11152@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
	<1343149213-10160-9-git-send-email-ming.lei@canonical.com>
	<20120725160425.GK11152@aftab.osrc.amd.com>
Date: Thu, 26 Jul 2012 10:59:08 +0800
Message-ID: <CACVXFVO5HHFraBXsV2S_a_KUrBg3ffyO0qqaGCjzq8Rksr9KaA@mail.gmail.com>
Subject: Re: [RFC PATCH 08/13] driver core: firmware loader: fix device lifetime
From: Ming Lei <ming.lei@canonical.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 12:04 AM, Borislav Petkov <bp@amd64.org> wrote:
>> Also this patch holds the reference cound of @device before
>
>                                         count

Good catch, will fix it in -v1.


>> - *   it is not possible to sleep for long time. It can't be called
>> - *   in atomic contexts.
>> + *   it is not possible to sleep for long time.
>
> Let's state it explicitly:
>
>         "it is not allowed to sleep for it is called in atomic context."

Looks you understand it incorrectly, the sentence is below

 *      Asynchronous variant of request_firmware() for user contexts where
 *      it is not possible to sleep for long time.

and maybe it should be changed to below:

 *      Asynchronous variant of request_firmware() for user contexts where
 *      it is not possible to sleep for long time or can't sleep at all.

Thanks,
--
Ming Lei
