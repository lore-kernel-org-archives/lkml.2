Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab2AERwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:52:16 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57863 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2AERwP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:52:15 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1325762519.3635.22.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1325610682-24811-1-git-send-email-olof@lixom.net>
	<1325610682-24811-5-git-send-email-olof@lixom.net>
	<1325762519.3635.22.camel@mfleming-mobl1.ger.corp.intel.com>
Date: Thu, 5 Jan 2012 09:52:14 -0800
Message-ID: <CAOesGMj=EVXGNNY+nj4BvsrFShhvQkSeS2RB8SYtVOXOENwFng@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86: efi: add basic error handling
From: Olof Johansson <olof@lixom.net>
To: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 3:21 AM, Matt Fleming <matt.fleming@intel.com> wrote:
> On Tue, 2012-01-03 at 09:11 -0800, Olof Johansson wrote:
>> It's not perfect, but way better than before. Mark efi_enabled as false in
>> case of error and at least stop dereferencing pointers that are known to
>> be invalid.
>>
>> The only significant missing piece is the lack of undoing the
>> memblock_reserve of the memory that efi marks as in use. On the other
>> hand, it's not a large amount of memory, and leaving it unavailable for
>> system use should be the safer choice anyway.
>>
>> Signed-off-by: Olof Johansson <olof@lixom.net>
>> ---
>>  arch/x86/platform/efi/efi.c |   89 ++++++++++++++++++++++++++++--------------
>>  1 files changed, 59 insertions(+), 30 deletions(-)
>
> Seems straight forward and better than what was there previously. Have
> you tested this error handling?

Not much, since the systems I have won't boot if there's an error
(even if graceful) and I didn't have a console with earlyprintk
support until yesterday. I'll beat on it a bit this afternoon but it
should be OK as it is.

Thanks,


-Olof
