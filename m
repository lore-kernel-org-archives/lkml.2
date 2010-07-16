Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935105Ab0GPAXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 20:23:43 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36034 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934092Ab0GPAXl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 20:23:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MsN6YxSx5QQMRn+F8BpRUln2j/IMHk8ZD/vr5X+mbj0c2XQY7uiFIXSXbIh/VkkG12
         pIG24gBKiPqYqDBaeiV5UlUqNbhO5QxWDxSzCOGCJ++qRep23AnjJgjGLVe6AQjFEC1n
         udyQk/npbOyjfJL73I4Kutxx8ZtRLux3ttCqk=
MIME-Version: 1.0
In-Reply-To: <20100715134857.38d519c5@nehalam>
References: <4C3E0684.5060409@wildgooses.com>
	<4C3E1B54.40604@hp.com>
	<20100714203919.GD6682@nuttenaction>
	<20100714.145547.102555471.davem@davemloft.net>
	<20100714221301.GI6682@nuttenaction>
	<20100714234917.924f420d.billfink@mindspring.com>
	<AANLkTinbtGuMTPNyJqJtx_bqfQDPqbA1XqjhLe_pj1mX@mail.gmail.com>
	<4C3F66BA.8010002@hp.com>
	<20100715134857.38d519c5@nehalam>
Date: Thu, 15 Jul 2010 17:23:40 -0700
Message-ID: <AANLkTikLBZ7E7iUR8fibVoYPDi5JBgC53tH6FMy1f8yZ@mail.gmail.com>
Subject: Re: Raise initial congestion window size / speedup slow start?
From: "H.K. Jerry Chu" <hkjerry.chu@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Rick Jones <rick.jones2@hp.com>, Bill Fink <billfink@mindspring.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        David Miller <davem@davemloft.net>, lists@wildgooses.com,
        davidsen@tmr.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't even consider a modest IW increase to 10 is aggressive. The scaling
of IW is only adequate IMO given the huge b/w growth in the past
decade. Remember there could be plenty of flows sending large cwnd
bursts at
twice the bottleneck link rate at any point of time in the network anyway so
the "fairness" question may already be ill-defined. In any case we're
trying to conduct some experiment in a private testbed to hopefully
get some insights
with real data.

Jerry

On Thu, Jul 15, 2010 at 1:48 PM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
> On Thu, 15 Jul 2010 12:51:22 -0700
> Rick Jones <rick.jones2@hp.com> wrote:
>
>> I have to wonder if the only heuristic one could employ for divining the initial
>> congestion window is to be either pessimistic/conservative or
>> optimistic/liberal.  Or for that matter the only one one really needs here?
>>
>> That's what it comes down to doesn't it?  At any one point in time, we don't
>> *really* know the state of the network and whether it can handle the load we
>> might wish to put upon it.  We are always reacting to it. Up until now, it has
>> been felt necessary to be pessimistic/conservative at time of connection
>> establishment and not rely as much on the robustness of the "control" part of
>> avoidance and control.
>>
>> Now, the folks at Google have lots of data to suggest we don't need to be so
>> pessimistic/conservative and so we have to decide if we are willing to be more
>> optimistic/liberal.  Broadly handwaving, the "netdev we" seems to be willing to
>> be more optimistic/liberal in at least a few cases, and the question comes down
>> to whether or not the "IETF we" will be similarly willing.
>
> I am not convinced that a host being aggressive with initial cwnd (Linux) would
> not end up unfairly monopolizing available bandwidth compared to older more conservative
> implementations (Windows). Whether fairness is important or not is another debate.
>
>
