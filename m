Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab2JVTIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:08:07 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62714 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab2JVTIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:08:06 -0400
MIME-Version: 1.0
In-Reply-To: <20121022150755.GB22780@phenom.dumpdata.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
	<1350593430-24470-11-git-send-email-yinghai@kernel.org>
	<20121022150755.GB22780@phenom.dumpdata.com>
Date: Mon, 22 Oct 2012 12:08:04 -0700
X-Google-Sender-Auth: G5mn4qRMRqpSBh2msYlfpBhsrGI
Message-ID: <CAE9FiQXpauTV9608M-j7VmPyKNGsubnY15NPb1WRnPrczqq+iA@mail.gmail.com>
Subject: Re: [PATCH 07/19] x86, mm: Remove early_memremap workaround for page
 table accessing on 64bit
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 8:07 AM, Konrad Rzeszutek Wilk
<konrad@kernel.org> wrote:
> On Thu, Oct 18, 2012 at 01:50:18PM -0700, Yinghai Lu wrote:
>> We do not need that workaround anymore after patches that pre-map page
>> table buf and do not clear initial page table wrongly.
>
>
> .. and somewhere during the v2 posting we had a discussion about
> why this work-around came about. You should include a bit about
> that and copy-n-paste some of that here please.

Not sure which one that you are referring.

anyway I update the changelog to:

---
We try to put page table high to make room for kdump, and at that time
those ranges are not mapped yet, and have to use ioremap to access it.

Now after patch that pre-map page table top down.
        x86, mm: setup page table in top-down
We do not need that workaround anymore.

Just use __va to return directly mapping address.
---
