Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab0GOEMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 00:12:39 -0400
Received: from smtp-out.google.com ([74.125.121.35]:54378 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab0GOEMh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 00:12:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=shz58MDtOmBPmPZtJBdmNbUqO6+bbC3RkCo4ZU2fXKU4RyKztkIfGczHSo7XAThdd
	mDhNW5nYreTcXLK3gCUpA==
MIME-Version: 1.0
In-Reply-To: <20100714203919.GD6682@nuttenaction>
References: <4C3D94E3.9080103@wildgooses.com>
	<4C3DD5EB.9070908@tmr.com>
	<20100714.111553.104052157.davem@davemloft.net>
	<4C3E0684.5060409@wildgooses.com>
	<4C3E1B54.40604@hp.com>
	<20100714203919.GD6682@nuttenaction>
Date: Wed, 14 Jul 2010 21:12:33 -0700
Message-ID: <AANLkTikTyZGQWWIBzYSQWpUK30xxbMXLbJXeHahWnlIi@mail.gmail.com>
Subject: Re: Raise initial congestion window size / speedup slow start?
From: Tom Herbert <therbert@google.com>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Rick Jones <rick.jones2@hp.com>, Ed W <lists@wildgooses.com>,
        David Miller <davem@davemloft.net>, davidsen@tmr.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jerry Chu <hkchu@google.com>, Nandita Dukkipati <nanditad@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 1:39 PM, Hagen Paul Pfeifer <hagen@jauu.net> wrote:
> * Rick Jones | 2010-07-14 13:17:24 [-0700]:
>
>>There is an effort under way, lead by some folks at Google and
>>including some others, to get the RFC's enhanced in support of the
>>concept of larger initial congestion windows.  Some of the discussion
>>may be in the "tcpm" mailing list (assuming I've not gotten my
>>mailing lists confused).  There may be some previous discussion of
>>that work in the netdev archives as well.
>
> tcpm is the right mailing list but there is currently no effort to develop
> this topic. Why? Because is not a standardization issue, rather it is a
> technical issue. You cannot rise the initial CWND and expect a fair behavior.
> This was discussed several times and is documented in several documents and
> RFCs.
>
> RFC 5681 Section 3.1. Google employees should start with Section 3. This topic
> pop's of every two months in netdev and until now I _never_ read a
> consolidated contribution.
>

There is an Internet draft
(http://datatracker.ietf.org/doc/draft-hkchu-tcpm-initcwnd/) on
raising the default Initial Congestion window to 10 segments, as well
as a SIGCOMM paper (http://ccr.sigcomm.org/online/?q=node/621).  We
presented this proposal and data supporting it at Anaheim IETF, and
will be following up in Netherlands with more data including some of
which should further address fairness questions.

In terms of Linux implementation, setting ICW via ip route is
sufficient support on the server side.  There is also a proposed patch
which could allow applications to set ICW themselves (in hopes that
application can reduce number of simultaneous connections).  On the
client side we can now adjust the receive window to advertise larger
initial windows.  Among current implementations, Linux advertises the
smallest default receive window of major OSes, so it turns out Linux
clients won't get lower latency benefits currently (so we'll probably
ask to raise the default some day :-)).

Tom

> Partial local issues can already be "fixed" via route specific ip options -
> see initcwnd.
>
> HGN
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
