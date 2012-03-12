Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab2CLJrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 05:47:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50795 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2CLJrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 05:47:37 -0400
MIME-Version: 1.0
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B6E99@saturn3.aculab.com>
References: <CAOD=uF4Vx581zvpAT0dHKjUkrdsiZo-DTNR352V8tALM_P2roA@mail.gmail.com>
	<AE90C24D6B3A694183C094C60CF0A2F6026B6E99@saturn3.aculab.com>
Date: Mon, 12 Mar 2012 15:17:36 +0530
Message-ID: <CAOD=uF4CisG9QeVoVjcrBHWfrXk4i6aBhYQxwNL=uUVa978RMw@mail.gmail.com>
Subject: Re: [PATCH 3/3] netxen: qlogic ethernet : Fix Endian Bug.
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: David Laight <David.Laight@aculab.com>
Cc: Rajesh Borundia <rajesh.borundia@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

here "mac" is in "u64" and I have casted it to "__le64".
Because its required there.

If you have any better suggestion, please let me know.


regards
santosh

On Mon, Mar 12, 2012 at 3:07 PM, David Laight <David.Laight@aculab.com> wrote:
>
>
>> -----Original Message-----
>> From: netdev-owner@vger.kernel.org
>> [mailto:netdev-owner@vger.kernel.org] On Behalf Of santosh
>> prasad nayak
>> Sent: 11 March 2012 09:17
>> To: Rajesh Borundia
>> Cc: Sony Chacko; netdev; linux-kernel; kernel-janitors@vger.kernel.org
>> Subject: Re: [PATCH 3/3] netxen: qlogic ethernet : Fix Endian Bug.
>>
>> Thanks Rajesh for clarification.
>> Included all your inputs in the following patch.
>> This is for review not a formal one. Once review is done I will send a
>> formal patch.
>
> I'm not sure of the exact nature of the issues here,
> but whenever I see code that casts between the addresses
> of integer types large bells start ringing - such code
> tends to have unwanted dependencies against the sizes
> and endiannesses of the relevant fields.
> This code might be ok, but lines like:
>> +     if (*(__le64 *)mac == cpu_to_le64(~0ULL)) {
> rather give me the willies.
>
>        David
>
>
