Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab1FSTJq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 15:09:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56915 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab1FSTJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 15:09:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH 09/19] OpenRISC: IRQ
Date: Sun, 19 Jun 2011 21:09:14 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1308483825-6023-1-git-send-email-jonas@southpole.se> <1308483825-6023-10-git-send-email-jonas@southpole.se>
In-Reply-To: <1308483825-6023-10-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106192109.14874.arnd@arndb.de>
X-Provags-ID: V02:K0:H25Atp7Yf9v+1wA8+6TQtwiqR9ro7IlvBnPg7qKIse8
 F29x1AEPpRMrBIx2kd/W2mmgpTg3aH3unV9sDpacgdpdn1MsNH
 L9c8JxMNYUHx2CQrShJkGx9ynqvyRXYyYV1MmmOmfif84cUX99
 C/ZJGjkzB0LadlNguEckJ0vr64hHr6xWMSAlG0L3heS/T2vnvR
 AW/UVwe0XpyUe4H+G2GwA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 June 2011 13:43:35 Jonas Bonn wrote:
> +
> +/* read interrupt enabled status */
> +unsigned long arch_local_save_flags(void) {
> +       return (mfspr(SPR_SR) & (SPR_SR_IEE|SPR_SR_TEE));
> +}
> +EXPORT_SYMBOL(arch_local_save_flags);
> +
> +/* set interrupt enabled status */
> +void arch_local_irq_restore(unsigned long flags) {
> +       mtspr(SPR_SR, ((mfspr(SPR_SR) & ~(SPR_SR_IEE|SPR_SR_TEE)) | flags));
> +}
> +EXPORT_SYMBOL(arch_local_irq_restore);

These are rather simple but common operations, how about making them inline?

	Arnd
