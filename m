Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab0JLJUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 05:20:08 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46631 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab0JLJUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 05:20:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: RFC: Implement hwpoison on free for soft offlining
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com,
        akpm@linux-foundation.org
In-Reply-To: <87aamj3k6f.fsf@basil.nowhere.org>
References: <1286402951-1881-1-git-send-email-andi@firstfloor.org> <87aamj3k6f.fsf@basil.nowhere.org>
Message-Id: <20101012181439.ADA9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 12 Oct 2010 18:20:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Andi Kleen <andi@firstfloor.org> writes:
> 
> > Here's a somewhat experimental patch to improve soft offlining
> > in hwpoison, but allowing hwpoison on free for not directly
> > freeable page types. It should work for nearly all
> > left over page types that get eventually freed, so this makes
> > soft offlining nearly universal. The only non handleable page
> > types are now pages that never get freed.
> >
> > Drawback: It needs an additional page flag. Cannot set hwpoison
> > directly because that would not be "soft" and cause errors.
> 
> Ping? Any comments on this patch?
> 
> Except for the page flag use I think it's nearly a no brainer. 
> A lot of new soft hwpoison capability for very little additional code.
> 
> Has anyone a problem using up a 64bit page flag for that?

To me, it's no problem if this keep 64bit only. IOW, I only dislike to
add 32bit page flags.

Yeah, memory corruption is very crap and i think your effort has a lot
of worth :)


offtopic, I don't think CONFIG_MEMORY_FAILURE and CONFIG_HWPOISON_ON_FREE
are symmetric nor easy understandable. can you please consider naming change?
(example, CONFIG_HWPOISON/CONFIG_HWPOISON_ON_FREE, 
CONFIG_MEMORY_FAILURE/CONFIG_MEMORY_FAILURE_SOFT_OFFLINE)



