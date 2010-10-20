Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab0JTGBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:01:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40322 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877Ab0JTGBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:01:14 -0400
Message-ID: <4CBE8584.10707@zytor.com>
Date: Tue, 19 Oct 2010 23:00:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [PATCH 1/2]percpu: introduce read mostly percpu API
References: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com> <1287551880.2700.79.camel@edumazet-laptop>
In-Reply-To: <1287551880.2700.79.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 10:18 PM, Eric Dumazet wrote:
> 
> Could you precisely describe why grouping together read mostly percpu
> variables is a win ? Especially when you add in your next patch a single
> variable ?
> 

The logic is that those variables are less likely to end up dirty in the
cache.  It is, however, much less of an issue for percpu variables,
since dirty lines there aren't quite so likely to bounce around.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

