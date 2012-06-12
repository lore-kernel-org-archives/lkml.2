Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab2FLA2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 20:28:47 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37298 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab2FLA2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 20:28:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAFR8uefCD_WXDM6m+-XwG10+W0UXqOtK7_sxWD3uVckh3pnR-Q@mail.gmail.com>
References: <1338576911-17089-1-git-send-email-merez@codeaurora.org>
	<1338576911-17089-2-git-send-email-merez@codeaurora.org>
	<CAFR8uefCD_WXDM6m+-XwG10+W0UXqOtK7_sxWD3uVckh3pnR-Q@mail.gmail.com>
Date: Mon, 11 Jun 2012 17:28:44 -0700
Message-ID: <CAFR8uee7hWLC-h_abZOCEuqeUeuhDuJp74x3R-3n+c61xyfaPQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mmc: block: Add write packing control
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Maya Erez <merez@codeaurora.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 2:19 PM, Muthu Kumar <muthu.lkml@gmail.com> wrote:
> On Fri, Jun 1, 2012 at 11:55 AM, Maya Erez <merez@codeaurora.org> wrote:
>> The write packing control will ensure that read requests latency is
>> not increased due to long write packed commands.
>>
>> The trigger for enabling the write packing is managing to pack several
>> write requests. The number of potential packed requests that will trigger
>> the packing can be configured via sysfs by writing the required value to:
>> /sys/block/<block_dev_name>/num_wr_reqs_to_start_packing.
>> The trigger for disabling the write packing is fetching a read request.
>>
>
> If it is applicable only to MMC why do we have this sysfs attr for all
> block devices?

Just to be clear, please create a directory, say mmc, under
/sys/block/<dev>/ and create the attr inside that.

You can refer to dm (dm-sysfs.c) for sample implementation.

Regards,
Muthu
