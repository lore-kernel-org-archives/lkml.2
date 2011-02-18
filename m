Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab1BRK7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 05:59:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51932 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1BRK7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 05:59:11 -0500
Subject: Re: [PATCH 1/3] perf events: fix WARN_ON_ONCE for 64-bit raw data,
 SW events
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, acme@ghostprotocols.net, paulus@samba.org
In-Reply-To: <1298008433-22911-2-git-send-email-daahern@cisco.com>
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>
	 <1298008433-22911-2-git-send-email-daahern@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 12:00:21 +0100
Message-ID: <1298026821.5226.642.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 22:53 -0700, David Ahern wrote:
> This check does not work out for 64-bit counter:
> 
>     sizeof(u32) + sizeof(u64) = 4 + 8 = 12
> 
> which does not pass the WARN_ON_ONCE test. I'm guessing (hoping
> really) that the intent is that the size of the raw data is a
> multiple of 4 bytes, not 8.

No the data must come in 8bytes strides.

