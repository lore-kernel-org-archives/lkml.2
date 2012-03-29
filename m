Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204Ab2C2Wmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 18:42:45 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53787 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759508Ab2C2Wmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 18:42:38 -0400
MIME-Version: 1.0
In-Reply-To: <1333020379.1820.58.camel@vkoul-udesk3>
References: <1333020379.1820.58.camel@vkoul-udesk3>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Mar 2012 15:42:16 -0700
X-Google-Sender-Auth: 9YVAIU7YLOK-nw04BJrY5gKHo4k
Message-ID: <CA+55aFweNvB8LM8yp3niQbROSUufF3g7UnE35eCKc25yLNQ64Q@mail.gmail.com>
Subject: Re: [GIT PULL] slave-dmaengine updates for 3.4
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dan <dan.j.williams@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 4:26 AM, Vinod Koul <vinod.koul@linux.intel.com> wrote:
>
> There are few merge conflicts with your tree, so I created a branch on
> todays tip and merged the slave-dma.next. Results are at
> git://git.infradead.org/users/vkoul/slave-dma.git linus_master_merge
> for you to compare while merging.

Hmm. I think your merge is wrong.

You left the "select ARCH_MXC_AUDMUX_V1" in arch/arm/mach-imx/Kconfig
around, even though that was removed elsewhere.

You also lost the changes to the pl330.c driver (DINVALID1 and the fix
for the NULL pointer dereference on thrd), and you've left a duplicate
dev_notice() in atmel-mci.c..

Anyway, I *think* I got my merge right, but people should double-check
and actually test the affected drivers.

I also get the feeling that snd_hwparams_to_dma_slave_config() should
clear the device_fc field, but whatever. I had resolved that
identically to yours as a "minimal change".

                            Linus
