Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab2ACI6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 03:58:00 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38263 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab2ACI55 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 03:57:57 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Gilad Ben-Yossef" <gilad@benyossef.com>
Cc: linux-kernel@vger.kernel.org, "Chris Metcalf" <cmetcalf@tilera.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Russell King" <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        "Pekka Enberg" <penberg@kernel.org>, "Matt Mackall" <mpm@selenic.com>,
        "Rik van Riel" <riel@redhat.com>, "Andi Kleen" <andi@firstfloor.org>,
        "Sasha Levin" <levinsasha928@gmail.com>, "Mel Gorman" <mel@csn.ul.ie>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Alexander Viro" <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, "Avi Kivity" <avi@redhat.com>
Subject: Re: [PATCH v5 1/8] smp: Introduce a generic on_each_cpu_mask function
References: <1325499859-2262-1-git-send-email-gilad@benyossef.com>
 <1325499859-2262-2-git-send-email-gilad@benyossef.com>
 <op.v7hz3pbc3l0zgt@mpn-glaptop>
 <CAOtvUMdk6DdcHK3Rp8ctwa8BqkF9YLwa09PHTUFCE53VdAY_6A@mail.gmail.com>
Date: Tue, 03 Jan 2012 09:57:35 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v7h259ad3l0zgt@mpn-glaptop>
In-Reply-To: <CAOtvUMdk6DdcHK3Rp8ctwa8BqkF9YLwa09PHTUFCE53VdAY_6A@mail.gmail.com>
User-Agent: Opera Mail/11.60 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2012/1/3 Michal Nazarewicz <mina86@mina86.com>:
>> on_each_cpu() returns an int.  For consistency reasons, would it make sense
>> to make on_each_cpu_maks() to return and int?  I know that the difference
>> is that smp_call_function() returns and int and smp_call_function_many()
>> returns void, but to me it actually seems strange and either I'm missing
>> something important (which is likely) or this needs to get cleaned up at
>> one point as well.

On Tue, 03 Jan 2012 09:12:21 +0100, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> I'd say we should go the other way around - kill the return value on
> on_each_cpu()
>
> The return value is always a hard coded zero and we have some code that tests
> for that return value. Silly...
>
> It looks like it's there for hysterical reasons to me :-)

That might be right.  Of course, this goes deeper then on_each_cpu() since
some of the smp_call_function functions have an int return value, but I
couldn't find an instance when they return non-zero.

I'd offer to volunteer to do the clean-up but I have too little experience
in IPI to say with confidence that we in fact can and want to drop the “int”
return value from all of those functions.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
