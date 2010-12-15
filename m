Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab0LOVsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 16:48:36 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:33117 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab0LOVse convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 16:48:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CZPQJ0E4I9RTQ56fUYYwv2BpHhdgbzl7B7dqHF45SHign9guTHYXNXWLBhKUL2C7MS
         /Gh6DpFAJruaDurfi/FptUJ5CZfBr+Z9/8Q+hD/smDBlU14QA+WzUtBeIlHA7PuWYJ15
         KQJaa+4HYAUK77d6Z8G/dGwO2hEfpugHB33J4=
MIME-Version: 1.0
In-Reply-To: <4D093580.9000303@zytor.com>
References: <alpine.DEB.2.00.1012151404070.21102@router.home>
	<20101215125626.25f7d648.akpm@linux-foundation.org>
	<4D092D15.7030700@zytor.com>
	<AANLkTimhdmWGhxW9qnFWYxiVDManH4XG4RqTLJb_Fdbk@mail.gmail.com>
	<4D093580.9000303@zytor.com>
Date: Wed, 15 Dec 2010 22:48:33 +0100
Message-ID: <AANLkTin=GXnLuDZncSL9rWKh5teCQP=3iQB-Rz8zxsnk@mail.gmail.com>
Subject: Re: x86: A fast way to check capabilities of the current cpu
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        Pekka Enbeerg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 10:39 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/15/2010 01:30 PM, Miguel Ojeda wrote:
>>
>> In this case it this_cpu_*_test_bit() return an int, but they act as a
>> bool and are used in if()s; where is the catch?
>>
>
> If they aren't, and are stored in a variable for whatever reason, then
> the || form will generate additional instructions to booleanize the
> value for no good reason.

Thanks! I suppose that is the 't' of being "a fast way" ;-)

>
>        -hpa
>
