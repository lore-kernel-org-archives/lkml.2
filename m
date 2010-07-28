Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab0G1M0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 08:26:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38035 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab0G1M0B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 08:26:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hOx935Fmpazu4af60PM2nYq8okPCTR2+IEFK9SrlEzN4J4cDc/yMtG5dAUSqeDXX+3
         M5dn06xgGb6t7n/eK1mKk5F2FGq6Ojo0kJBTw5GcbA5FwEM7FAAXn6hMpMFVG1XxuiA2
         0bGaxq+vCfUn+oxSAcks8mXsDKOJLVxH2uD5Y=
MIME-Version: 1.0
In-Reply-To: <d7a11c97d1b28c7a0336c747de57a9a17dcc7604.1280316431.git.m.nazarewicz@samsung.com>
References: <38424b23c94ddcff6f1808161912f362c2ccae39.1280316431.git.m.nazarewicz@samsung.com>
	<7b3ddf05e135e8147d1011a81f9069d9cd78aa62.1280316431.git.m.nazarewicz@samsung.com>
	<d7a11c97d1b28c7a0336c747de57a9a17dcc7604.1280316431.git.m.nazarewicz@samsung.com>
Date: Wed, 28 Jul 2010 15:25:59 +0300
Message-ID: <AANLkTikW8eSn3fgRqJsXwp=+ZMjKgojHDP6+DsDMtg4y@mail.gmail.com>
Subject: Re: [PATCHv5 3/3] USB: gadget: storage_common: fixed warning building 
	mass storage function
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 3:13 PM, Michal Nazarewicz
<m.nazarewicz@samsung.com> wrote:
> The "nofua" attribute is used in the File-Storage Gadget but the
> functions handling it are defined in storage_common.c (which may be
> not a bad thing if anyone will want to port tho "nofua" attribute to
> mass storage function) which causes the following warnings:
>
> drivers/usb/gadget/storage_common.c:718: \
>  warning: ‘fsg_show_nofua’ defined but not used
> drivers/usb/gadget/storage_common.c:782: \
>  warning: ‘fsg_store_nofua’ defined but not used
>
> Adding __maybe_unused fixes this issue.
It's a bit odd.

Why the warning happens for those two only?
There are two more parameters (four methods) to handle 'ro' and 'file'
which are done in the same way.

-- 
With Best Regards,
Andy Shevchenko
