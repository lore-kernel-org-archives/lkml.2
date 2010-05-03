Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075Ab0ECQBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 12:01:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932986Ab0ECQBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 12:01:30 -0400
Message-ID: <4BDEF355.8050504@redhat.com>
Date: Mon, 03 May 2010 12:01:25 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc14 Thunderbird/3.0.3
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: linux-next: April 27 (iscsi_ibft)
References: <80edf231-ef31-4f21-ab1b-1a21fda35809@default> <20100427230121.GA31743@andromeda.dapyr.net>
In-Reply-To: <20100427230121.GA31743@andromeda.dapyr.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 07:01 PM, Konrad Rzeszutek Wilk wrote:
> On Tue, Apr 27, 2010 at 09:13:16AM -0700, Randy Dunlap wrote:
>> when CONFIG_ACPI is not enabled:
>>
>> drivers/firmware/iscsi_ibft_find.c:112: error: dereferencing pointer to incomplete type
>> drivers/firmware/iscsi_ibft_find.c:112: error: dereferencing pointer to incomplete type
>> drivers/firmware/iscsi_ibft_find.c:112: warning: type defaults to 'int' in declaration of 'type name'
>> drivers/firmware/iscsi_ibft_find.c:112: error: dereferencing pointer to incomplete type
>> drivers/firmware/iscsi_ibft_find.c:112: warning: type defaults to 'int' in declaration of 'type name'
> 
> Yikes.
> 
> Randy, thank you for spotting this and sending an e-mail my way.
> 
> It is all b/c we now use the 'struct acpi_table_ibft *ibft_addr' which
> is gone when !CONFIG_ACPI.
> 
> Peter, if we did in an #ifdef !CONFIG_ACPI in iscsi_ibft.h and included
> a copy of the old ibft_struct that should work.
> 
> Or we make the code dependent on CONFIG_ACPI (in the Kconfig
> file).
> 
> Peter, Randy: Which option do you think makes more sense?

Or we make that one structure be defined whether CONFIG_ACPI is enabled
or not.

-- 
        Peter

For some reason it has always seemed to me that the term software 
engineering contains some very optimistic assumptions about the 
nature of reality.
