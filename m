Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab1AEU07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 15:26:59 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41766 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab1AEU05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 15:26:57 -0500
Date: Wed, 5 Jan 2011 20:26:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: mm: Poison freed init memory
Message-ID: <20110105202645.GL8638@n2100.arm.linux.org.uk>
References: <1294256845-29517-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294256845-29517-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 11:47:25AM -0800, Stephen Boyd wrote:
> Poisoning __init marked memory can be useful when tracking down
> obscure memory corruption bugs. When a pointer is 0xCCCCCCCC in an

That's a bad idea for a value.  With a 3GB page offset and 256MB or
more memory, accesses to such an address will always succeed.

There's two things to be considered when selecting a possible poison
value:

1. what value is guaranteed to provoke an undefined instruction exception?
2. what value when used as an address and dereferenced is mostly always
   going to abort?

1 for ARM mode implies an 0xe7fXXXfX value.  For Thumb mode 0xdeXX.  We
use this space for breakpoints.

2 unfortunately depends on the platform. 
