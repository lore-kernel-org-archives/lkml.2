Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783Ab1LOXP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 18:15:58 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52609 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab1LOXP4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 18:15:56 -0500
MIME-Version: 1.0
In-Reply-To: <20111215210538.GA12248@konrad-lan>
References: <20111215210538.GA12248@konrad-lan>
Date: Thu, 15 Dec 2011 15:15:55 -0800
X-Google-Sender-Auth: SQV_ZRpj6RGJY8JB20gKIJ5v11E
Message-ID: <CAE9FiQXFgOU3c9Ej-B_sZfhs5sRN87xE93BtZoU2K=M6=_O9YA@mail.gmail.com>
Subject: Re: [GIT PULL] ibft fix for 3.2-rc6
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>, Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 1:05 PM, Konrad Rzeszutek Wilk
<konrad@darnok.org> wrote:
> Hey Linus,
>
> Please git pull the following branch:
>
>  git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft.git linux-next
>
> which has a fix to make the ACPI table called 'iSCSI Boot Format Table'
> (IBFT) be found by the iscsi-ibft driver when booting under UEFI.
>
> The functionality to grab the APCI IBFT was added some time ago, but we
> did not have the UEFI box to test it. Now that it has been tested it was
> uncovered that the ACPI parser code was run way to early - so it did not
> parse the iBFT table at all. This patch fixes it by doing the ACPI parsing later.
> The legacy iBFT searching is not affected (which is to scan 640K->1MB
> for the iBFT signature) and works correctly.
>
> Please pull!
>
> Yinghai Lu (1):
>      ibft: Fix finding IBFT ACPI table on UEFI
>
>  drivers/firmware/iscsi_ibft.c      |   42 ++++++++++++++++++++++++++++++++++-
>  drivers/firmware/iscsi_ibft_find.c |   26 +--------------------
>  2 files changed, 42 insertions(+), 26 deletions(-)

Greg,

Can you please put this one into stable

	935a9fee51c945b8942be2d7b4bae069167b4886

actually,  even still need to apply to 2.6.32 stable

but commit description could be some different:

for 2.6.32, and kernel before memblock is supported in x86:
Even we call reserve_ibft_region() in x86 setup_arch() some late, but
it still in early stage.
at that time, acpi table is mapped for temporal use and will be
unmapped after handler is called
So handler should not store remapped address for late use.

only after init_main()/early_acpi_init(), we can store those remapped
address for acpi tables in handles

Thanks

Yinghai
