Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab2JJBIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 21:08:45 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33189 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246Ab2JJBIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 21:08:40 -0400
MIME-Version: 1.0
In-Reply-To: <20121009160438.GG7639@phenom.dumpdata.com>
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
	<1349757558-10856-5-git-send-email-yinghai@kernel.org>
	<20121009160438.GG7639@phenom.dumpdata.com>
Date: Tue, 9 Oct 2012 18:08:39 -0700
X-Google-Sender-Auth: g_yvzuGJ5TWRaHq-6jADp7BZ6c4
Message-ID: <CAE9FiQUEF0_pjjukrf3QW-N4YKe-ORzMa6S5Hs-bgPSd2paydA@mail.gmail.com>
Subject: Re: [PATCH 04/10] x86, mm: Don't clear page table if next range is ram
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

On Tue, Oct 9, 2012 at 9:04 AM, Konrad Rzeszutek Wilk <konrad@kernel.org> wrote:
> How do we clean it wrongly?
>> And it only happens when we are trying to map range one by one range separately.
>>
>> After we add checking before clearing the related page table, that panic will
>> not happen anymore.
>
> So we do not clean the pages anymore. Is the cleaning of the pages
> addressed somewhere?

that is related calling sequence.

old design assume: we should call that several times under 1G.
