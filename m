Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab0HPFJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 01:09:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39482 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab0HPFJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 01:09:52 -0400
X-User-Agent: K-9 Mail for Android
References: <F0CB3B1C601247indou.takao@jp.fujitsu.com> <AANLkTimM0H0ryre3pXsXQ6c0e3=v_36-h0TsXzriMWXe@mail.gmail.com> <faf83501-1e53-459d-88ed-2ac5963a37f2@email.android.com> <AANLkTimtH41djAF5OxXCeVS8cHg_JCBd+wQ1iT1BUWgX@mail.gmail.com>
In-Reply-To: <AANLkTimtH41djAF5OxXCeVS8cHg_JCBd+wQ1iT1BUWgX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][EFI] Run EFI in physical mode
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 15 Aug 2010 22:08:43 -0700
To: huang ying <huang.ying.caritas@gmail.com>
CC: Takao Indoh <indou.takao@jp.fujitsu.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, ebiederm@xmission.com, tglx@linutronix.de,
        mingo@redhat.com, vgoyal@redhat.com, nhorman@tuxdriver.com
Message-ID: <8f5e697c-e9ae-4453-aa7a-7086dd156cc9@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the 1:1 map we probably should make all pages executable; other things need it too, but we shouldn't have it mapped in except when needed.

"huang ying" <huang.ying.caritas@gmail.com> wrote:

>On Mon, Aug 16, 2010 at 11:27 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> No, it should not be dynamic; rather we should unify all the users who need a 1:1 map and just keep that page table set around.
>
>Agree. One known issue of global 1:1 map is that we need to make at
>least part of page table PAGE_KERNEL_EXEC for EFI runtime code, and
>change_page_attr can not be used before page allocator is available.
>
>Best Regards,
>Huang Ying

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
