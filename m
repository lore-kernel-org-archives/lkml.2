Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab2IZLjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 07:39:17 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34793 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab2IZLjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 07:39:12 -0400
MIME-Version: 1.0
In-Reply-To: <506243FB.8010408@synaptics.com>
References: <1345241877-16200-1-git-send-email-cheiny@synaptics.com>
	<1345241877-16200-3-git-send-email-cheiny@synaptics.com>
	<CACRpkdbxJ0=SLuw+av4xxkABWR2MbXrS_T=HYzfCaZdXVLeTjw@mail.gmail.com>
	<506243FB.8010408@synaptics.com>
Date: Wed, 26 Sep 2012 13:39:10 +0200
Message-ID: <CACRpkdbQ4PMVbLuKT-i1dt2oYUYadJ6iw7X-xvAiXjveHAn-Hw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/17] input: RMI4 core bus and sensor drivers.
From: Linus Walleij <linus.walleij@linaro.org>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 1:53 AM, Christopher Heiny <cheiny@synaptics.com> wrote:

>>> >+/* Remove access to raw format string versions */
>>> >+/*#undef simple_show_union_struct
>>> >+#undef show_union_struct_unsigned
>>> >+#undef show_store_union_struct
>>> >+#undef show_repeated_union_struct
>>> >+#undef show_store_repeated_union_struct*/
>>
>> This looks like trying to reimplement ioctl() in sysfs.
>>
>> If what you want is to send big structs in/out of the kernel,
>> use either ioctl() on device nodes (should be trivial since input
>> is using real device nodes) or use configfs.
>
> I'm a little confused.  There's repeated emphasis in the kernel doc that you
> shouldn't use ioctl() anymore - use sysfs instead.  So we've been using
> sysfs, though it seems somewhat klutzy.  If it's actually OK to use ioctl(),
> that could simplify things.  On the other hand, using configfs might be more
> appropriate.

OK yes configfs is said to be ideal for large configuration chunks,
I haven't really used it.

sysfs has this concept of one value per file, and that turns into the
above serialization/marshalling code if followed, so it doesn't look
good. Maybe configfs is the silver bullet.

Yours,
Linus Walleij
