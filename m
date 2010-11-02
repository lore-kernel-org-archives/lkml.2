Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0KBRuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 13:50:17 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:36789 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab0KBRuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 13:50:12 -0400
Message-ID: <4CD04F4D.2020403@tilera.com>
Date: Tue, 2 Nov 2010 13:50:05 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: <linux-kernel@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] drivers/i2c: add support for tile architecture "bus"
 for I2C devices
References: <201011021712.oA2HCsMe028141@farm-0010.internal.tilera.com> <20101102101912.3df5012c.rdunlap@xenotime.net>
In-Reply-To: <20101102101912.3df5012c.rdunlap@xenotime.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/2010 1:19 PM, Randy Dunlap wrote:
> On Tue, 2 Nov 2010 13:05:34 -0400 Chris Metcalf wrote:
>> This change enables the Linux driver to access i2c devices via
>> the Tilera hypervisor's virtualized API.
>>
>> Note that the arch/tile/include/hv/ headers are "upstream" headers
>> that likely benefit less from LKML review.
>>
>> [...]
>> +++ b/arch/tile/include/hv/drv_i2cm_intf.h
>> [...]
>> +/**
> In kernel source code, "/**" is used to begin kernel-doc notation blocks.
> Please don't use it for non-kernel-doc comments.
>
> (multiple times...)

These headers are essentially "upstream" for the Linux port; they are owned
by the Tilera hypervisor.  The "/**" comments in those files are Doxygen
comments used to generate standalone API documentation for the hypervisor. 
The same answer applies to your comment later in the file where you pointed
out some brace-positioning issues and the use of typedefs, since the coding
style for those headers is different the Linux coding style.  (Note also
that these headers are using two-space indents rather than tab indents.)

To avoid stylistic clash, we could have released the hypervisor headers as
a separate tarball (somewhere) and required that the kernel build take an
environment variable or some such to locate them, but it seemed simpler to
incorporate them into the Tilera Linux code so that the kernel can build in
a reasonably self-contained way.  The hypervisor header model is that the
client can use any internally consistent set of hypervisor headers and just
register the version number associated with that set of headers when
starting up.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

