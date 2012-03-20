Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317Ab2CTOmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:42:16 -0400
Received: from [89.21.227.130] ([89.21.227.130]:42993 "EHLO
	mail.epsilon.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756463Ab2CTOmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:42:12 -0400
Message-ID: <4F68951E.2020601@itdev.co.uk>
Date: Tue, 20 Mar 2012 07:33:02 -0700
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>,
        "Bowens, Alan" <Alan.Bowens@atmel.com>,
        "Tiwari, Atul" <Atul.Tiwari@atmel.com>
Subject: Re: [PATCH 00/20] cleanup atmel_mxt_ts
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Kurtz wrote:
> This patchset cleans up the atmel_mxt_ts touchscreen driver.
> In particular, it addresses the following issues:

Hi Daniel-

Thanks for your work on this, some of it looks very useful. I will go
through and review each patch in turn.

I have been working on Atmel's version of this driver. You can find most of
that work on our github site: as you know we are intending to push it
upstream as much as possible:
https://github.com/atmel-maxtouch

The main overlap between your changes and ours is in your approach to
writing config from userspace. There is a lot of complexity in these chips
and providing a sysfs node for each function would end up being a
never-ending task.

So we have implemented an interface using a sysfs binary attribute which I
think is considerably more general and flexible than the interface that you
suggest. You can find a set of utilities on the same github that uses our
interface. I would argue that we should try and converge the mainline
driver on our approach rather than inventing something new unless there are
significant advantages.

cheers

-- 
Nick Dyer
Software Engineer, ITDev Ltd
Hardware and Software Development Consultancy
Website: http://www.itdev.co.uk
