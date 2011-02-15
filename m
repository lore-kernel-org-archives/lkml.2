Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab1BOOEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 09:04:14 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51870 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab1BOOEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 09:04:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TjjnrBC3vzO7l8o4PYssWhRcTfNubJlH/i+cJNxO60heU1LUrbfdd91u+QKWKBvzr0
         xk/YU5BBOtK507mtSf24LVaKozzFdGdCs8FulWxnZeiZ6Iy6NEihFVqINcHb+knjc7Ks
         54OvJK4q7Dq0QTucgY7KMGUBLt6SHT9/wrbv4=
MIME-Version: 1.0
In-Reply-To: <4D5A8021.2060001@zytor.com>
References: <1297707868.5226.189.camel@laptop>
	<1297718964.23343.75.camel@gandalf.stny.rr.com>
	<1297719576.23343.80.camel@gandalf.stny.rr.com>
	<20110214.134600.179933733.davem@davemloft.net>
	<20110214223755.436e7cf4@mfleming-mobl1.ger.corp.intel.com>
	<4D59B891.8010300@zytor.com>
	<AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com>
	<4D5A8021.2060001@zytor.com>
Date: Tue, 15 Feb 2011 14:04:08 +0000
Message-ID: <AANLkTikVB6Vf5W-KACdLJOz=FmtU4syQ4z1EWmjunB5o@mail.gmail.com>
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Will Newton <will.newton@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@console-pimps.org>, David Miller <davem@davemloft.net>,
        rostedt@goodmis.org, peterz@infradead.org, jbaron@redhat.com,
        mathieu.desnoyers@polymtl.ca, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 1:31 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/15/2011 03:01 AM, Will Newton wrote:
>>
>> The CPU in question has two sets of instructions:
>>
>>   load/store - these go via the cache (write through)
>>   ll/sc - these operate literally as if there is no cache (they do not
>> hit on read or write)
>>
>> This may or may not be a sensible way to architect a CPU, but I think
>> it is possible to make it work. Making it work efficiently is more of
>> a challenge.
>>
>
> a) What "CPU in question" is this?

http://imgtec.com/meta/meta-technology.asp

> b) Why should we let this particular insane CPU slow ALL OTHER CPUs down?

I didn't propose we do that. I brought it up just to make people aware
that there are these odd architectures out there, and indeed it turns
out Blackfin has some superficially similar issues.
