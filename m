Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934766Ab2DLVbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:31:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64577 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2DLVbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:31:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120412.160040.1086391259430365718.davem@davemloft.net>
References: <CABe5r8Kygjg0O21Y5z-F=RRQCqT7ReNya+EohAJU1jauaK536Q@mail.gmail.com>
	<1333811774-3219-1-git-send-email-eldad@fogrefinery.com>
	<20120412.160040.1086391259430365718.davem@davemloft.net>
Date: Thu, 12 Apr 2012 23:31:47 +0200
Message-ID: <CABe5r8JJPuhq3r=JnfLA=_U46-SFmK+g3XqC3MaRdLxwVXx9Qw@mail.gmail.com>
Subject: Re: [PATCH] net/ipv6/exthdrs.c et al: Optional strict PadN option checking
From: Eldad Zack <eldad@fogrefinery.com>
To: David Miller <davem@davemloft.net>
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 April 2012 22:00, David Miller <davem@davemloft.net> wrote:
>> Added strict checking of PadN. PadN can be used to increase header
>> size and thus push the protocol header into the 2nd fragment.
>>
>> PadN is used to align the options within the Hop-by-Hop or
>> Destination Options header to 64-bit boundaries. The maximum valid
>> size is thus 7 bytes.
>> RFC 4942 recommends to actively check the "payload" itself and
>> ensure that it contains only zeroes.
> I think you should do away with the sysctl and always perform these
> checks.
>
> At the very leat, the optlen > 7 check should always be performed.
> And frankly the pad byte being zero check makes sense to do all the
> time as far as I can tell too.

That's the way I see it, as was my initial intent. Then I got
concerned with the possibility that a communication with
slightly-broken stack implementation (e.g., unsanitized buffers) would
fail without the user being able to control it at runtime.
Do you consider this a non-issue?

If not, please apply the (soon to be sent) patch.

Thanks,
Eldad
