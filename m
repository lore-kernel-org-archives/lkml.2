Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab1DNJQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 05:16:21 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53149 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538Ab1DNJQR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 05:16:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T3xqiEX8QGzP0+uSUgO2yhKZyGn0H1/fUpCPm1pfE6p68l0MdWLyi5kKAAmBRZ6MP2
         2cs/J1qvYxRgcP/G9E/TTI1VLTCaUaMNOSr/3XXgKl1yToAe8X/9LsdKTc1SN24YggiK
         DbwjbPnBOm8IPmoEMeYSh1f7hS4dW8EEJmYpY=
MIME-Version: 1.0
In-Reply-To: <20110413113204.GB6948@albatros>
References: <BANLkTi=ogJg_uJqsJFpnwnnr6LS+SFT3Vg@mail.gmail.com>
	<20110413113204.GB6948@albatros>
Date: Thu, 14 Apr 2011 12:16:15 +0300
Message-ID: <BANLkTinh0cmb0hzpVdm5XemT5NeULeAoHQ@mail.gmail.com>
Subject: Re: [PATCH] net: ipv4: add IPPROTO_ICMP socket kind
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Pavel Kankovsky <peak@argo.troja.mff.cuni.cz>,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Eugene Teo <eugene@redhat.com>, Nelson Elhage <nelhage@ksplice.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Pekka Savola <pekkas@netcore.fi>, James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 2:32 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> On Wed, Apr 13, 2011 at 13:29 +0300, Alexey Dobriyan wrote:
>> On Sat, Apr 9, 2011 at 1:15 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
>> > This patch adds IPPROTO_ICMP socket kind.
>>
>> > +       seq_printf(f, "%5d: %08X:%04X %08X:%04X"
>> > +               " %02X %08X:%08X %02X:%08lX %08X %5d %8d %lu %d %p %d%n",
>> > +               bucket, src, srcp, dest, destp, sp->sk_state,
>> > +               sk_wmem_alloc_get(sp),
>> > +               sk_rmem_alloc_get(sp),
>> > +               0, 0L, 0, sock_i_uid(sp), 0, sock_i_ino(sp),
>>
>> These zeroes can be embedded into format string for slightly faster printing.
>
> Is it really needed?  I mean, it is not a fast path, so such a small
> overhead is not very bad.  But embedding them into the string makes it a
> bit more difficult to read.

In fact, if field is always zero, it can be removed altogether.
Also, there was big discussion re exposing kernel socket pointers,
which this file continue to do.

> +               atomic_read(&sp->sk_refcnt), sp,
> +               atomic_read(&sp->sk_drops), len);
