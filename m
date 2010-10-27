Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760896Ab0J0KuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:50:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab0J0KuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:50:12 -0400
Message-ID: <4CC803DD.2010508@redhat.com>
Date: Wed, 27 Oct 2010 12:50:05 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andi Kleen <andi@firstfloor.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: fyi: gcc33-hammer crashes when compiling kvm emulate.c
References: <20101026123828.GA30434@basil.fritz.box> <4CC70333.80400@zytor.com> <20101026163748.GB29961@basil.fritz.box> <4CC705ED.1020105@zytor.com> <20101026170142.GD29961@basil.fritz.box> <4CC71B94.2010802@zytor.com> <20101026202734.GB2603@basil.fritz.box> <4CC73C07.3030704@zytor.com>
In-Reply-To: <4CC73C07.3030704@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/26/2010 10:37 PM, H. Peter Anvin wrote:
> On 10/26/2010 01:27 PM, Andi Kleen wrote:
> >>  That is an issue too, as 3.x does a lot fewer optimizations than 4.x.
> >
> >  Well to be fair the default -Os build disables most of the fancy stuff
> >  (and the resulting code is often terrible)
> >
> >  I guess it doesn't matter too much, at least not with the
> >  CONFIG_CC_OPTIMIZE_SIZE default.
> >
>
> Yes, it would be nice to have a setting which is "optimize but don't
> bloat excessively."
>

Would be good to have __fastpath and __slowpath function attributes.

__fastpath would always be optimized for speed, __slowpath always for 
size, and everything else would use the default (determined by 
CONFIG_CC_OPTIMIZE_FOR_SIZE).

Looks like gcc has support for this, with __attribute__((hot)), 
__attribute__((cold)), and __attribute__((optimize)).

-- 
error compiling committee.c: too many arguments to function

