Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab0GOF30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 01:29:26 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45030 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267Ab0GOF3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 01:29:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V8xbL6OID1/5AOf1rSYhEfeR/lYIaphfM6aUoaxNFIz1zGygRoiRjrObWUnBna1k67
         cyhRTDZ/4O0zari70knBnEdyjvkA8RyQJVz6holXDCMMDi6L1Gmt+KYsmt9OVdMgRomX
         PU8Q7b3lD4XLdrQLk2UFj04R1/v64Sz2e7zfM=
MIME-Version: 1.0
In-Reply-To: <20100714234917.924f420d.billfink@mindspring.com>
References: <4C3E0684.5060409@wildgooses.com>
	<4C3E1B54.40604@hp.com>
	<20100714203919.GD6682@nuttenaction>
	<20100714.145547.102555471.davem@davemloft.net>
	<20100714221301.GI6682@nuttenaction>
	<20100714234917.924f420d.billfink@mindspring.com>
Date: Wed, 14 Jul 2010 22:29:21 -0700
Message-ID: <AANLkTinbtGuMTPNyJqJtx_bqfQDPqbA1XqjhLe_pj1mX@mail.gmail.com>
Subject: Re: Raise initial congestion window size / speedup slow start?
From: "H.K. Jerry Chu" <hkjerry.chu@gmail.com>
To: Bill Fink <billfink@mindspring.com>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>, David Miller <davem@davemloft.net>,
        rick.jones2@hp.com, lists@wildgooses.com, davidsen@tmr.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 8:49 PM, Bill Fink <billfink@mindspring.com> wrote:
> On Thu, 15 Jul 2010, Hagen Paul Pfeifer wrote:
>
>> * David Miller | 2010-07-14 14:55:47 [-0700]:
>>
>> >Although section 3 of RFC 5681 is a great text, it does not say at all
>> >that increasing the initial CWND would lead to fairness issues.
>>
>> Because it is only one side of the medal, probing conservative the available
>> link capacity in conjunction with n simultaneous probing TCP/SCTP/DCCP
>> instances is another.
>>
>> >To be honest, I think google's proposal holds a lot of weight.  If
>> >over time link sizes and speeds are increasing (they are) then nudging
>> >the initial CWND every so often is a legitimate proposal.  Were
>> >someone to claim that utilization is lower than it could be because of
>> >the currenttly specified initial CWND, I would have no problem
>> >believing them.
>> >
>> >And I'm happy to make Linux use an increased value once it has
>> >traction in the standardization community.
>>
>> Currently I know no working link capacity probing approach, without active
>> network feedback, to conservatively probing the available link capacity with a
>> high CWND. I am curious about any future trends.
>
> A long, long time ago, I suggested a Path BW Discovery mechanism
> to the IETF, analogous to the Path MTU Discovery mechanism, but
> it didn't get any traction.  Such information could be extremely
> useful to TCP endpoints, to determine a maximum window size to
> use, to effectively rate limit a much stronger sender from
> overpowering a much weaker receiver (for example 10-GigE -> GigE),
> resulting in abominable performance across large RTT paths
> (as low as 12 Mbps), even in the absence of any real network
> contention.

Unfortunately that is not going to help initcwnd (unless one can invent a
PBWD protocol from just 3WHS), and the web is dominated by short-lived
connections so the small initcwnd becomes a choke point.

Jerry

>
>                                                -Bill
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
