Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab1BAIcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 03:32:53 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39807 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab1BAIcw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 03:32:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type:content-transfer-encoding;
        b=iqnizxj9/4UwwjhhOjoRIbi5Tvjq3daiJAxa4BuvzKsrs5i8WHQ50EwAzL4R87HtbK
         xISim5yRrEb5wbsqBHfwflrReZP+Mu4iNXOrGgVv5393cuzQTuzWgytmDqc0RvU8a1/S
         ZfNMxUG3U1ZMOHD+rhlU5M07i+3tx5DSbmtI4=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Tue, 1 Feb 2011 09:32:51 +0100
Message-ID: <AANLkTi=wj05GrQ2r-GAbaX1zSQzMN8FJV_2d7c-kv33L@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IGxpbnV4LW5leHQ6IFRyZWUgZm9yIEZlYnJ1YXJ5IDEgWyBzdGFnaW5nL3VzYnZpZA==?=
	=?UTF-8?B?ZW8vdmljYW0uYzogZXJyb3I6IGV4cGVjdGVkIOKAmDvigJkgYmVmb3JlIOKAmCnigJkgdG9rZW4gXQ==?=
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 5:34 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20110131:
>
> Dropped tree: xen
>
> The tty.current tree lost its conflict.
>
> The slab tree still has its build failure so I used the version from
> next-20110121.
>
> The suspend tree lost its build failure.
>
> The sparc64 defconfig build has been fixed.
>
> The powerpc allyesconfig build has been broken by some obscure bloating
> of the low memory code.
>
> ----------------------------------------------------------------------------

[ CC greg-kh ]

Build error:
...
drivers/staging/usbvideo/vicam.c:222:57: error: expected ‘;’ before ‘)’ token
drivers/staging/usbvideo/vicam.c:222:57: error: expected statement
before ‘)’ token
...

This should be fixed by:

Index: linux-next-20110201/drivers/staging/usbvideo/vicam.c
===================================================================
--- linux-next-20110201.orig/drivers/staging/usbvideo/vicam.c
+++ linux-next-20110201/drivers/staging/usbvideo/vicam.c
@@ -219,7 +219,7 @@ set_camera_power(struct vicam_camera *ca
 {
        int status;

-       status = send_control_msg(cam, 0x50, state, 0, NULL, 0));
+       status = send_control_msg(cam, 0x50, state, 0, NULL, 0);
        if (status < 0)
                return status;

- Sedat -
