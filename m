Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab1LKMoK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 07:44:10 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64348 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab1LKMoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 07:44:07 -0500
MIME-Version: 1.0
In-Reply-To: <m2y5uknqjk.fsf@firstfloor.org>
References: <CAE04G=Bu4WnU9SYU9u3-ap6OrBEjWONK8TA8bYBy5OSCCzzDqg@mail.gmail.com>
	<m2y5uknqjk.fsf@firstfloor.org>
Date: Sun, 11 Dec 2011 20:44:05 +0800
Message-ID: <CAE04G=Bq+tyPnM+SVHUm+AQH4nLOy-KH7foRVNFs6GNdzpiX_Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] x86: Add process memory layout to coredump file
From: t cheney <cdmalord@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/11, Andi Kleen <andi@firstfloor.org> wrote:
> t cheney <cdmalord@gmail.com> writes:
>
>> This patch just add memory layout(same as /proc/pid/maps) to
>> coredump file. The layout is appended to corenote segment with
>> flag NT_MAPS=7.
>
> Seems like a reasonable idea, but can you please share code with
> the proc implementation?
Yes, I will post it in following mail.
>
> It's a bit unusal to have ASCII in a coredump, but I suppose expressing
> this in binary would be somewhat ugly.
>
>> +	char *buf = notes->data;
>> +	size_t core_limit = notes->datasz;
>> +	gate_vma = get_gate_vma(current->mm);
>> +
The maps info is appended to core notes segment in which there are all
ASCII text such as regs,signal and thread info.
>
> It seems a bit dubious to do this without locking even in a core dump.
>
>> +	for (vma = first_vma(current, gate_vma); vma != NULL;
>> +		vma = next_vma(vma, gate_vma)) {
>> +		flags = vma->vm_flags;
>> +		maps_size += len;
>> +		if (file) {
>> +			if (maps_size > core_limit)
>> +				break;
>
> You have a one-off bug here. Also below.
>
>> +			DUMP_WRITE(buf, len, foffset);
>> +		}
>
Because proceses that could change vma pages are blocked in do_exit,
here vma pages are safe.
>
> -Andi
> --
> ak@linux.intel.com -- Speaking for myself only
>
