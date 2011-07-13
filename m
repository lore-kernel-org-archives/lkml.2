Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab1GMS5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 14:57:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44455 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab1GMS5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 14:57:44 -0400
Message-ID: <4E1DEAA2.80208@zytor.com>
Date: Wed, 13 Jul 2011 11:57:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/2] efi: merge x86 and ia64 code
References: <1310502243-19306-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1310502243-19306-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2011 01:24 PM, Matthew Garrett wrote:
> We currently have two almost entirely independent EFI implementations in
> the kernel, with the x86 code having begun as a modified version of the
> ia64 code. Forthcoming ARM platforms will use EFI and there are
> experimental ports for some MIPS platforms, so continuing this "One EFI
> implementation per architecture" model is likely to result in massive bug
> duplication. This patch merges the common elements of the ia64 and x86
> implementations, which should make adding any future platforms a simple
> matter of adding setup code and the appropriate stubs for accessing EFI
> resources and making calls.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Hi Matt,

I get a build error on x86-32:

/home/hpa/kernel/linux-2.6-tip.efi/arch/x86/platform/efi/efi_32.c:43:
error: conflicting types for ‘efi_call_phys_prelog’
/home/hpa/kernel/linux-2.6-tip.efi/arch/x86/include/asm/efi.h:73: note:
previous declaration of ‘efi_call_phys_prelog’ was here
/home/hpa/kernel/linux-2.6-tip.efi/arch/x86/platform/efi/efi_32.c:85:
error: conflicting types for ‘efi_call_phys_epilog’
/home/hpa/kernel/linux-2.6-tip.efi/arch/x86/include/asm/efi.h:74: note:
previous declaration of ‘efi_call_phys_epilog’ was here
make[5]: *** [arch/x86/platform/efi/efi_32.o] Error 1

	-hpa
