Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab2KTX7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 18:59:25 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59388 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab2KTX7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 18:59:24 -0500
MIME-Version: 1.0
In-Reply-To: <1353451183-18807-1-git-send-email-elezegarcia@gmail.com>
References: <1353451183-18807-1-git-send-email-elezegarcia@gmail.com>
Date: Wed, 21 Nov 2012 00:59:22 +0100
Message-ID: <CAFLxGvxuRtbvTob0j-YgfK6Ydz9TVCdjD5NOToyyKQb2S7bC9Q@mail.gmail.com>
Subject: Re: [RFC/PATCH 1/1] ubi: Add ubiblock driver
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        michael.opdenacker@free-electrons.com, dwmw2@infradead.org,
        Tim Bird <tim.bird@am.sony.com>,
        Artem Bityutskiy <dedekind1@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 11:39 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> Block device emulation on top of ubi volumes with read/write support.
> Block devices get automatically created for each ubi volume present.
>
> Each ubiblock is fairly cheap since it's based on workqueues
> and not on threads.
>
> Read/write access is expected to work fairly well because the
> request queue at block elevator orders block transfers to be space-effective.
> In other words, it's expected that reads and writes gets ordered
> to point to the same LEB.
>
> To help this and reduce access to the UBI volume, a 1-LEB size
> write-back cache has been implemented.
> Every read and every write, goes through this cache and the write is
> only done when a request arrives to read or write to a different LEB
> or when the device is released, when the last file handle is closed.

Did you also benchmark your driver with two caches?
(One for reading and one for writing.)
By using two caches you can lower the amount of atomic LEB changes.

Maybe it would be also good to ensure that an cache entry becomes not too old.

-- 
Thanks,
//richard
