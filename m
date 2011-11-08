Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab1KHH6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 02:58:11 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53951 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab1KHH6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 02:58:06 -0500
MIME-Version: 1.0
In-Reply-To: <20111108003622.GM21663@outflux.net>
References: <1320710760-2734-1-git-send-email-bfreed@chromium.org>
	<20111108003622.GM21663@outflux.net>
Date: Tue, 8 Nov 2011 08:58:06 +0100
Message-ID: <CANGUGtCxkK6Ozi8xAdX3rsa+v64wv1Ek5fToaCNd8dWty0jkyw@mail.gmail.com>
Subject: Re: [PATCH] ramoops: Add a device file for ramoops buffer access.
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Bryan Freed <bfreed@chromium.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, msb@chromium.org, seiji.aguchi@hds.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/8 Kees Cook <keescook@chromium.org>:
> Hi Bryan,
>
> On Mon, Nov 07, 2011 at 04:06:00PM -0800, Bryan Freed wrote:
>> Add a /dev/ramoops device file that gives direct access to ramoops buffers.
>> This interface is cleaner than using /dev/mem to access the buffers because
>> we no longer need to lseek() or (for ARM) mmap() to an address specified in
>> the sysfs mem_address file.
>
> This looks pretty good, except that I'd also want to remove all the module
> parameters since this would bypass CONFIG_STRICT_DEVMEM (imagine a
> malicious root user loading this module to spy on RAM via the new
> interface).

First of all my ack for the Bryan's patch.
The behavior about strict /dev/mem should be depends on the
reservation type, I mean if the driver calls request_mem_region
instead of request_mem_region_exclusive. Since ramoops uses the no
exclusive version I think no problems should occurs.

Marco
