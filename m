Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab2FKOnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:43:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46740 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2FKOn3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:43:29 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1206111014010.1607-100000@iolanthe.rowland.org>
References: <1339391600-17815-1-git-send-email-ming.lei@canonical.com>
	<Pine.LNX.4.44L0.1206111014010.1607-100000@iolanthe.rowland.org>
Date: Mon, 11 Jun 2012 22:43:26 +0800
Message-ID: <CACVXFVNS2U-t7_8WwVNhQprP29y_xiZX25WwoBD5SRpch-p+7A@mail.gmail.com>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove(v2)
From: Ming Lei <ming.lei@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 10:16 PM, Alan Stern <stern@rowland.harvard.edu> wrote:

>> +
>> +             if (nonlocked)
>> +                     dev_err(dev, "can't hold %slock for shutdown\n",
>> +                                     nonlocked == 1 ? "" : "parent ");
>
> Even if the parent can't be locked, you should still try to lock the
> device.

I have considered doing it, but which may consume another 1sec.

Also if the parent lock has been held, it is very possibly that the
device can't be probed or removed at the same time, so just logged
the crazy thing and go ahead.

Thanks,
--
Ming Lei
