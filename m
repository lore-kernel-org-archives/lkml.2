Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab3ADT5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 14:57:32 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:60739 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab3ADT5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 14:57:30 -0500
MIME-Version: 1.0
In-Reply-To: <20130104160533.GF3334@phenom.dumpdata.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-27-git-send-email-yinghai@kernel.org>
	<20130104160533.GF3334@phenom.dumpdata.com>
Date: Fri, 4 Jan 2013 11:57:28 -0800
X-Google-Sender-Auth: KkXCaeoZeAmvgSCPDUFTuB9EX8A
Message-ID: <CAE9FiQWN6QsFpx7KtiOWZ+g3d3B4nY1wR8etA8XWZiobtYtGcQ@mail.gmail.com>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 8:05 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>> +static bool __init enough_mem_for_swiotlb(void)
>> +{
>> +     /* do we have less than 1M RAM under 4G ? */
>
> And why 1MB? The default size is 64MB.

because kdump scripts will use memmap=exact,.. to add range below 1M
to get realmode data.
