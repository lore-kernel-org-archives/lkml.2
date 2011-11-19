Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1KSJbh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 04:31:37 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55423 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab1KSJbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 04:31:35 -0500
Message-ID: <4EC77605.5090605@gmail.com>
Date: Sat, 19 Nov 2011 10:25:25 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Chen Gong <gong.chen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 2/2] ramoops: remove module parameters
References: <1321644698-13677-1-git-send-email-keescook@chromium.org> <1321644698-13677-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1321644698-13677-3-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/11/2011 20:31, Kees Cook ha scritto:
> The ramoops driver is intended to be used with platforms that define
> persistent memory regions. If memory regions were configurable with
> module parameters, it would be possible to read some RAM regions via
> the pstore interface without access to /dev/mem (which would result
> in a loss of kernel memory privacy when a system is built with
> STRICT_DEVMEM), so remove this ability completely.
>

I don't like it very much. The loss of module parameters give us less 
flexibility. The main goal of this driver is debug, so I think it should 
be fast to use. I mean it's not more possible reserve a memory region 
and load the module "on-the-fly", it needs a platform device, it's ok 
but I think it's a little bit more complicated, (without talking about 
platforms without a device tree source).
I don't understand the problem of strict devmem. We shouldn't use kernel 
memory region but only reserved ones and the driver doesn't use the 
request_mem_region_exclusive, am I wrong?

Marco
