Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657Ab0ERN4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 09:56:01 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:33678 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562Ab0ERNz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 09:55:59 -0400
Date: Tue, 18 May 2010 08:55:12 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Haicheng Li <haicheng.li@linux.intel.com>
cc: Wu Fengguang <fengguang.wu@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [RESEND][PATCH 3/3] mem-hotplug: fix potential race while building
 zonelist for new populated zone
In-Reply-To: <4BF257BA.7020507@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1005180853400.15028@router.home>
References: <4BF0FC4C.4060306@linux.intel.com> <alpine.DEB.2.00.1005171108070.20764@router.home> <20100518021923.GA6595@localhost> <4BF257BA.7020507@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010, Haicheng Li wrote:

> +extern struct mutex zonelists_pageset_mutex;

The mutext is used for multiple serializations having to do with zones.
"pageset" suggests its only for pagesets.

So

	zones_mutex?

or

	zonelists_mutex?

