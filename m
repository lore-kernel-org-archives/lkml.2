Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab0LPPjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:39:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42578 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877Ab0LPPjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:39:31 -0500
Message-ID: <4D0A3267.40300@zytor.com>
Date: Thu, 16 Dec 2010 07:38:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Miles Bader <miles@gnu.org>
CC: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        Pekka Enbeerg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: x86: A fast way to check capabilities of the current cpu
References: <alpine.DEB.2.00.1012151404070.21102@router.home>	<20101215125626.25f7d648.akpm@linux-foundation.org>	<4D092D15.7030700@zytor.com>	<AANLkTimhdmWGhxW9qnFWYxiVDManH4XG4RqTLJb_Fdbk@mail.gmail.com>	<4D093580.9000303@zytor.com> <buowrnakze2.fsf@dhlpc061.dev.necel.com>	<AANLkTim+cbxPxgS+13anHQRdN42uLci6z48hbiyWFdaV@mail.gmail.com> <buooc8mko3x.fsf@dhlpc061.dev.necel.com>
In-Reply-To: <buooc8mko3x.fsf@dhlpc061.dev.necel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 02:29 AM, Miles Bader wrote:
> Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> writes:
>>>> If they aren't, and are stored in a variable for whatever reason, then
>>>> the || form will generate additional instructions to booleanize the
>>>> value for no good reason.
>>
>> I think hpa was talking about some code where gcc can not optimize out
>> the assignment (e.g. volatile, complex code, using the int outside
>> conditional expressions, etc.).
> 
> Sure, but that seems to assume that the alternatives are otherwise
> equivalent in the common case, when used in a boolean context.
> 
> If that's not true then one risks pessimizing the common case to make an
> uncommon case more efficient.
> 

The alternatives are equivalent when used in the common context.  Your
examples are bogus, because they don't account for the
__builtin_constant_p().

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

