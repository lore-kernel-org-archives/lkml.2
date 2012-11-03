Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762037Ab2KCAD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 20:03:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59517 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761912Ab2KCADx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 20:03:53 -0400
MIME-Version: 1.0
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D4138B435F@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D4138B435F@USINDEM103.corp.hds.com>
From: Mike Waychison <mikew@google.com>
Date: Fri, 2 Nov 2012 17:03:32 -0700
Message-ID: <CAGTjWtBvFvx2A9FFpDw+18p_58JiX=zpqHAd0T=JS=r8YkZHiw@mail.gmail.com>
Subject: Re: [RESEND][PATCH v4 0/7] efi_pstore: multiple event logging support
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Series Acked-by: Mike Waychison <mikew@google.com>

Tony: Did you want to pull this?

On Thu, Nov 1, 2012 at 3:59 PM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
> Changelog
>
> v3 -> v4
>    - Rebase to 3.7-rc3
>    - Add ctime to an argument of efi_pstore_erase to build successfully
>      in case where CONFIG_PTORE=n is specified. (Patch 4/7)
>    - Add count to an argument of efi_pstore_erase and efi_pstore_write to
>      build successfully in case where CONFIG_PTORE=n is specified (Patch 5/7)
>    - Fix a white space damage (Patch 6/7)
>    - Modify a logic checking a 3-variable format of a variable name (Patch 7/7)
>
> v2 -> v3
>    - Create patches 6/7 and 7/7 to work with an existing format of variable name
>
> v1 -> v2
>    - Separate into 5 patches in accordance with Mike's comment
>    - Erase an extra line of comment in patch 1/5
>
> [Issue]
>
>     Currently, efi_pstore driver simply overwrites existing panic messages in NVRAM.
>     So, in the following scenario, we will lose 1st panic messages.
>
>     1. kernel panics.
>     2. efi_pstore is kicked and writes panic messages to NVRAM.
>     3. system reboots.
>     4. kernel panics again before a user checks the 1st panic messages in NVRAM.
>
> [Solution]
>
>    Solutions of this problem has been discussed among Tony, Matthew, Don, Mike and me.
>
>    http://marc.info/?l=linux-kernel&m=134273270704586&w=2
>
>    And there are two possible solutions right now.
>      - First one is introducing some policy overwriting existing logs.
>      - Second one is simply holding multiple log without overwriting any entries.
>
>    We haven't decided the overwriting policy which is reasonable to all users yet.
>    But I believe we agree that just holding multiple logs is a reasonable way.
>
>    We may need further discussions to find the possibility of introducing overwriting
>    policy, especially getting critical messages in multiple oops case.
>    But I would like to begin with a simple and reasonable way to everyone.
>    So, this patch takes an approach just holding multiple logs.
>
> [Patch Description]
>
> Seiji Aguchi (7):
>   efi_pstore: Check remaining space with QueryVariableInfo() before
>     writing data
>   efi_pstore: Add a logic erasing entries to an erase callback
>   efi_pstore: Remove a logic erasing entries from a write callback to
>     hold multiple logs
>   efi_pstore: Add ctime to argument of erase callback
>   efi_pstore: Add a sequence counter to a variable name
>   efi_pstore: Add a format check for an existing variable name at
>     reading time
>   Add a format check for an existing variable name at erasing time
>
>  drivers/acpi/apei/erst.c   |   16 ++--
>  drivers/firmware/efivars.c |  163 ++++++++++++++++++++++++++++++-------------
>  fs/pstore/inode.c          |    7 ++-
>  fs/pstore/internal.h       |    2 +-
>  fs/pstore/platform.c       |   11 ++--
>  fs/pstore/ram.c            |    9 +--
>  include/linux/efi.h        |    1 +
>  include/linux/pstore.h     |    6 +-
>  8 files changed, 143 insertions(+), 72 deletions(-)
