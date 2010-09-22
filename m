Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab0IVME7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 08:04:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41226 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab0IVME6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 08:04:58 -0400
Message-ID: <589c3dd38437c80704d8224523efbccc.squirrel@www.firstfloor.org>
In-Reply-To: <4a8f3ad8416ed61cba1746883da1f839.squirrel@www.firstfloor.org>
References: <1285150102-5506-1-git-send-email-andi@firstfloor.org>
    <1285150102-5506-2-git-send-email-andi@firstfloor.org>
    <20100922113114.GA14179@Krystal>
    <4a8f3ad8416ed61cba1746883da1f839.squirrel@www.firstfloor.org>
Date: Wed, 22 Sep 2010 14:04:57 +0200
Subject: Re: [PATCH 2/2] Rewrite jump_label.c to use binary search
From: "Andi Kleen" <andi@firstfloor.org>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
        "Andi Kleen" <andi@firstfloor.org>, jbaron@redhat.com,
        rusty@rustcorp.co.au, rostedt@goodmis.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
        tglx@linutronix.de, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, "Andi Kleen" <ak@linux.intel.com>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
>>> +	for (; entry < stop && entry->key == key; entry++)
>>> +		if (kernel_text_address(entry->code))
>>
>> This does not work for modules I'm afraid, only for the core kernel. You
>> should test for __module_text_address() somewhere.
>
> I thought it was shared now, but ok.

Double checked. This is ok because kernel_text_address()
already checks for modules. You were probably thinking
of __kernel_text_address()

-Andi

