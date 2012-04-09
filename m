Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab2DITP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:15:56 -0400
Received: from mga07.intel.com ([143.182.124.22]:5920 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753224Ab2DITPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:15:53 -0400
MIME-Version: 1.0
In-Reply-To: <201204091849.20705.arnd@arndb.de>
References: <20120409182041.317.33360.stgit@dwillia2-linux.jf.intel.com>
	<20120409182203.317.81835.stgit@dwillia2-linux.jf.intel.com>
	<201204091849.20705.arnd@arndb.de>
Date: Mon, 9 Apr 2012 12:15:50 -0700
Message-ID: <CABE8wwszp3MoVxCdUfjUtvMkugL7VzOYTSxFQwqwQ7U9Wr0kbA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] of_serial: add support for setup quirks
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: gregkh@linuxfoundation.org, Stephen Warren <swarren@nvidia.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        linux-serial@vger.kernel.org, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, alan@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 11:49 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 09 April 2012, Dan Williams wrote:
>> Benign conversion of of_serial.c to offer the option of 'setup' quirks
>> similar to how 8250_pci.c houses the pci-serial-device quirks.
>>
>> A setup quirk allows custom uart_port ops to specified in the
>> of_serial_info data fed to each serial of_device_id.
>>
>> Tegra's 'break' quirk is the target consumer.
>>
>> Cc: Colin Cross <ccross@android.com>
>> Cc: Olof Johansson <olof@lixom.net>
>> Cc: Stephen Warren <swarren@nvidia.com>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/tty/serial/of_serial.c |   68 ++++++++++++++++++++++++++++------------
>>  1 files changed, 47 insertions(+), 21 deletions(-)
>
> I don't think this is a good idea. Aside from the bug that you introduce
> (you can no longer have multiple ports of the same type because of overwrite
> the static info->line number),

ah, yes, good catch.

> it seems an unnecessary complication.
> Either just add the quirk to the of_serial file based on the compatible value,
> or do a trivial new driver that has a subset of the existing one you need,
> plus the quirk.

ok.

The open question was where to house tegra_serial_handle_break, I'd
just as soon keep it all in of_serial.c and maintain the temporary
exports for use in the to-be-removed board files in
arch/arm/mach-tegra.

--
Dan
