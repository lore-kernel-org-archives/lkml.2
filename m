Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab2GOLDA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 07:03:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49270 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab2GOLC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 07:02:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQU9hEvaYMhyE4iCGiOtPDKjjC+Jj-jyCADfpH7btV0dNw@mail.gmail.com>
References: <1342273287-2154-1-git-send-email-penberg@kernel.org>
	<CAE9FiQU9hEvaYMhyE4iCGiOtPDKjjC+Jj-jyCADfpH7btV0dNw@mail.gmail.com>
Date: Sun, 15 Jul 2012 14:02:55 +0300
X-Google-Sender-Auth: N0RiPCP3XjMIVhoP73W-rYxtnlw
Message-ID: <CAOJsxLG7KSJzr-Tb=27jAsBNF1c3Vnedcebpp0kn+XSagXhHZw@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86/mm: Separate paging setup from memory mapping
From: Pekka Enberg <penberg@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 6:41 AM, Pekka Enberg <penberg@kernel.org> wrote:
>> Move PSE and PGE bit twiddling from init_memory_mapping() to a new
>> setup_paging() function to simplify the former function. The
>> init_memory_mapping() function is called later in the boot process by
>> gart_iommu_init(), efi_ioremap(), and arch_add_memory() which have no
>> business whatsover updating the CR4 register.

On Sat, Jul 14, 2012 at 11:47 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> I have one local patch that will only set that one time too. also do
> other page size probe one time.
>
> please check attached one.

Your patch still keeps the same sort of code flow. That is,
init_memory_mapping() does all sorts of things upon first call. I
personally prefer the more explicit approach in this patch. In fact,
you could do the page_size_mask setup in the setup_paging() function.

                        Pekka
