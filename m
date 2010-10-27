Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab0J0RAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:00:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53774 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab0J0RAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:00:33 -0400
Date: Wed, 27 Oct 2010 19:00:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: fyi: gcc33-hammer crashes when compiling kvm emulate.c
Message-ID: <20101027170023.GA22171@basil.fritz.box>
References: <20101026123828.GA30434@basil.fritz.box>
 <4CC70333.80400@zytor.com>
 <20101026163748.GB29961@basil.fritz.box>
 <4CC705ED.1020105@zytor.com>
 <20101026170142.GD29961@basil.fritz.box>
 <4CC71B94.2010802@zytor.com>
 <20101026202734.GB2603@basil.fritz.box>
 <4CC73C07.3030704@zytor.com>
 <4CC803DD.2010508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC803DD.2010508@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Would be good to have __fastpath and __slowpath function attributes.
> 
> __fastpath would always be optimized for speed, __slowpath always
> for size, and everything else would use the default (determined by
> CONFIG_CC_OPTIMIZE_FOR_SIZE).

> 
> Looks like gcc has support for this, with __attribute__((hot)),
> __attribute__((cold)), and __attribute__((optimize)).

I had patches for a long time, but last time I tried it didn't help too much.
(basically make __init hot/cold and mark a few functions) 
Similar things can be also done with unrolling. The Optimize attribute
is currently quite broken in gcc and shouldn't be used.

The main reason I didn't post them is that I didn't want another
likely/unlikely with people sprinkling them randomly and never
looking at profile logs. I am to blame for likely()/unlikely() originally
 and it got abused so much that I regretted it alot. So I don't
think just exposing that is a good idea right now.

I think there are some other ways to do that better, but they
will need more work.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
