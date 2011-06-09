Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab1FITC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:02:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37112 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab1FITC6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:02:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oIVs+oFtT0l+yvIErVMpJtRNecm24bMWjSxLvDvnSwIMhDRyAI/Lxd0JStmErG0szK
         hJN1EMZJWjlm9V7MGneK5NTR6TztS+jPY8MdurE+FaYieUueqSEo+GR5474cmGQ7awhg
         S6XthV0FP8D4OYiOclglvY8DnMmNLrQk91hhM=
MIME-Version: 1.0
In-Reply-To: <1307388985-7852-1-git-send-email-mjg@redhat.com>
References: <1307388985-7852-1-git-send-email-mjg@redhat.com>
Date: Thu, 9 Jun 2011 12:02:53 -0700
X-Google-Sender-Auth: V058DmEEO2c86WdRpzFfUQ8mBJY
Message-ID: <BANLkTi=wmubWjiQ3Lw7s_iA11AoE+J3BPQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] efi: Fix argument types for SetVariable()
From: Tony Luck <tony.luck@intel.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: x86@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 12:36 PM, Matthew Garrett <mjg@redhat.com> wrote:
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index e376270..0758753 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -168,7 +168,7 @@ typedef efi_status_t efi_get_variable_t (efi_char16_t *name, efi_guid_t *vendor,
>  typedef efi_status_t efi_get_next_variable_t (unsigned long *name_size, efi_char16_t *name,
>                                              efi_guid_t *vendor);
>  typedef efi_status_t efi_set_variable_t (efi_char16_t *name, efi_guid_t *vendor,
> -                                        unsigned long attr, unsigned long data_size,
> +                                        u32 attr, unsigned long data_size,
>                                         void *data);
>  typedef efi_status_t efi_get_next_high_mono_count_t (u32 *count);
>  typedef void efi_reset_system_t (int reset_type, efi_status_t status,

x86 isn't the only user of <linux/efi.h>

Building next-20110609 I see:

arch/ia64/kernel/efi.c:578: warning: assignment from incompatible pointer type
arch/ia64/kernel/efi.c:701: warning: assignment from incompatible pointer type

-Tony
