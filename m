Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab0JYPzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:55:24 -0400
Received: from web37608.mail.mud.yahoo.com ([209.191.87.91]:45306 "HELO
	web37608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751267Ab0JYPzX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:55:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=OcPMkL7G0W8Wc+JQFvcfmxBG/wMyOjzLLGV5fHTkRbuS9jydEyehVTSNe1QMQsvWH9BCEXBdCHA2UC/WewNIKn3y+xMPwlXRjVVETGA1GX3x/63p5gvGoKzCRo8dmhFfG/e7yMsD+iVLUS54whypd6wPJivSfTv8jUrNYXc6iNw=;
Message-ID: <659114.61656.qm@web37608.mail.mud.yahoo.com>
X-YMail-OSG: HLPhcxAVM1nnvo8CA5Ut4549n9Z8cgerKX6dysJ8jdcSnai
 m0SxWgOa6UX8kt90ui42e3oIhXJuEmSOp0gMLV1NvWGAxVjQSKOCNgUxYLFg
 XPE2kGmWyJgjsw8LBw5w5LS.dkNOeojkj9b6LgWzby90GqNXy82paswF1x3a
 94h4amI8mNm5B_U9PE.iFeUxy7zGQQnVX5jmbWAE8m1_5_yb_C0O22Rt.jIG
 WpdZdY4EkiSMhHFpumdrgop7KEMKCuBH86KQdJoV5l8oJOr8.pxHpBZPzl6a
 ML9fvRtlnuZRcggLWnGgLJTko3kKj5rZrY1.BN6zf5LKe_LzzPqA7p22WFeF
 5N.orGxRcKz9wDwp3qSBAl11Sj3I73fXLjlCHiTwF83PVwWco
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 08:55:22 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 14/29] memstick: remove the memstick_set_rw_addr
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1287791637-10329-15-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 14/29] memstick: remove the memstick_set_rw_addr
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> Received: Friday, 22 October, 2010, 4:53 PM
> Remove this function, what was
> last user that did send the MS_TPC_SET_RW_REG_ADRS
> directly.
> 
> Just invalidate the register window, and next register
> read/write will send that tpc automaticly.
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---

How is an obscure invalidate_reg_window function is any better than
explicit set_rw_addr? Total number of calls to either of them is exactly
the same.

Sony state machine diagrams suggest that doing a precise set_rw_addr when
necessary is a good thing. The feature was originally conceived because
Sony intended to manufacture MSIO and hybrid devices, which might have very
large number of registers (hundreds). It was also supposed to help with
backward compatibility of devices, as well as with DRM functionality

We know, at this point of time, that Sony is sort of loosing the format
war, so MSIO devices these days are very hard to come by. However, some
hybrid (Transfer Jet) and DRM-secured devices still exist and it is wise
to retain functionality which can help to operate those (I don't have full
details on their operation, but it doesn't mean we should forget them
outright).



      
