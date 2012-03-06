Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174Ab2CFFOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 00:14:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38607 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2CFFON convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 00:14:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of therbert@google.com designates 10.50.183.163 as permitted sender) smtp.mail=therbert@google.com; dkim=pass header.i=therbert@google.com
MIME-Version: 1.0
In-Reply-To: <CA+mtBx_vNcPr-q7FSKXCAsVqvjZt=4UpWfv5eAp0=diG0wnbjQ@mail.gmail.com>
References: <alpine.DEB.2.00.1203011505510.6685@router.home>
	<1330698646.2469.28.camel@edumazet-laptop>
	<CA+mtBx_vNcPr-q7FSKXCAsVqvjZt=4UpWfv5eAp0=diG0wnbjQ@mail.gmail.com>
Date: Mon, 5 Mar 2012 21:14:12 -0800
Message-ID: <CA+mtBx8oiDq+k3U705xYaV3xUsi=DnSWwCkymEONRcX3su77Fg@mail.gmail.com>
Subject: Re: 3.3.0-rc5: OOps in dql_completed (Broadcom tg3 driver)
From: Tom Herbert <therbert@google.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@gentwo.org>, mcarlson@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BQL implementation for tg3 does not handle multi queue correctly.
Will have a fix for that momentarily.

Tom

On Fri, Mar 2, 2012 at 9:23 AM, Tom Herbert <therbert@google.com> wrote:
> Hi Christoph, Eric,
>
> Looks like we're hitting BUG_ON(count > dql->num_queued -
> dql->num_completed).  This is indicative of mis-accounting occurring
> between netdev_sent_queue and netdev_completed_queue.  I don't
> immediately see how this could happen here in the tg3_tso_bug path,
> this is still using the same calls to transmit and complete as other
> paths.  I suppose it's possible that skb_gso_segment is somehow
> munging skb->len in segments.
>
> I'll try to reproduce this.
>
>> In case we hit BQL limit in one of the tg3_start_xmit() calls, we should
>> 'abort' the following ones, dont you think ?
>
> I'm not sure what you mean Eric.  It should be okay to exceed the BQL
> limit up to the point that num_queued rolls over (probably should be a
> BUG_ON for that).  This is a much greater number than could ever be
> queued to tg3.
>
> Thanks,
> Tom
>
>>
>> Or maybe thats irrelevant, and only dql_queued() comment is wrong.
>>
>> Thanks
>>
>>
