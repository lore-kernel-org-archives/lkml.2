Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab1HSTZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 15:25:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20881 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684Ab1HSTZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 15:25:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=q5lQYnUOdNXzQRhPWv55d0RK+A2vB4nhLg6OUgXxBVyTNATbQI3tRQ1yW4TFty4Ip
	Re/lg5lLR0nGB64+JefJw==
Date: Fri, 19 Aug 2011 12:25:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
Subject: Re: 3.1-rc2: CONFIG_NUMA Question
In-Reply-To: <alpine.DEB.2.02.1108180758290.7903@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.1108191223230.20477@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1108180649040.10458@p34.internal.lan> <CAM_iQpWPaavsa7gSURP5CL8+Es2P5rEdtLRmrOx+wQkThX7v9w@mail.gmail.com> <alpine.DEB.2.02.1108180758290.7903@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011, Justin Piszcz wrote:

> > The max of NUMA nodes is specified by CONFIG_NODES_SHIFT,
> > in your case, it is 6, which means it supports up to 2^6 nodes.
> Ok, is there any overhead having more than is needed?
> 

Yeah, try to avoid going above 8 because that causes nodemasks that are 
typically allocated on the stack of kernel text to be dynamically 
allocated through the slab allocator to avoid the possibility of overflow.  
I doubt you have the need for more than 64 nodes, so I'd highly recommend 
leaving it at the default unless you want to debug or test some large 
numa=fake settings.
