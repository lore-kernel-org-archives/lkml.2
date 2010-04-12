Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab0DLIlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 04:41:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53699 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab0DLIlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 04:41:03 -0400
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: tek-life <teklife.kernel@gmail.com>, dhazelton@enter.net,
       oliver@neukum.org, linux-kernel@vger.kernel.org
Subject: Re: Can we remove the Zone_DMA?
From: Andi Kleen <andi@firstfloor.org>
References: <m2mc58e39921004032121hc7ca41f0gacd90ffe2abc6444@mail.gmail.com>
	<k2tc58e39921004032226ze2eb64dev21f8c2d137a49ebc@mail.gmail.com>
	<s2mc58e39921004032233rfd47a83eoa86b37ffe59d2e7@mail.gmail.com>
	<201004040349.28840.dhazelton@enter.net>
	<j2rc58e39921004040128xb502c314u4b6b080a77fee813@mail.gmail.com>
	<m18w93hati.fsf@fess.ebiederm.org>
Date: Mon, 12 Apr 2010 10:41:00 +0200
In-Reply-To: <m18w93hati.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Sun, 04 Apr 2010 01:38:17 -0700")
Message-ID: <871velawrn.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

Revisiting old posts. Sorry for digging up this old thread
from its grave.

> Ultimately I don't see much point in disabling ZONE_DMA.  It is a lot of
> work to track down if it is really needed, and it only costs 16MB.  So
> unless someone shows me that ZONE_DMA triggers the OOM killer unnecessarily
> or otherwise impacts the system what does legacy code hurt?

It has quite a lot of impact on slab for example.

The main users today are mostly some users who need to have less tha 4GB
on 64bit systems. The problem is for those often 16MB is not enough.
So on many systems 16MB is too much and on others it isn't enough.

A long time ago I had a patchkit to replace it with a range allocator,
merge it with softiotlb and replace all the allocations with real masks.

It never got quite merged and still needed some more work.

ftp://firstfloor.org/pub/ak/dma/INTRO

All the issues described in the INTRO are still there.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
