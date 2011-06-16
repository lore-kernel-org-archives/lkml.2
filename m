Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab1FPMLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:11:54 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:40768 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756224Ab1FPMLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:11:49 -0400
X-IronPort-AV: E=Sophos;i="4.65,375,1304287200"; 
   d="scan'208";a="96872922"
Date: Thu, 16 Jun 2011 14:11:47 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: mingo@elte.hu, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: "Cache" sched domains
Message-ID: <20110616121147.GA4644@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We have an x86 machine whose sockets look like this in hwloc:

┌──────────────────────────────────────────────────────────────────┐
│Socket P#1                                                        │
│┌────────────────────────────────────────────────────────────────┐│
││L3 (16MB)                                                       ││
│└────────────────────────────────────────────────────────────────┘│
│┌────────────────────┐┌────────────────────┐┌────────────────────┐│
││L2 (3072KB)         ││L2 (3072KB)         ││L2 (3072KB)         ││
│└────────────────────┘└────────────────────┘└────────────────────┘│
│┌─────────┐┌─────────┐┌─────────┐┌─────────┐┌─────────┐┌─────────┐│
││L1 (32KB)││L1 (32KB)││L1 (32KB)││L1 (32KB)││L1 (32KB)││L1 (32KB)││
│└─────────┘└─────────┘└─────────┘└─────────┘└─────────┘└─────────┘│
│┌─────────┐┌─────────┐┌─────────┐┌─────────┐┌─────────┐┌─────────┐│
││Core P#0 ││Core P#1 ││Core P#2 ││Core P#3 ││Core P#4 ││Core P#5 ││
││┌───────┐││┌───────┐││┌───────┐││┌───────┐││┌───────┐││┌───────┐││
│││PU P#0 ││││PU P#4 ││││PU P#8 ││││PU P#12││││PU P#16││││PU P#20│││
││└───────┘││└───────┘││└───────┘││└───────┘││└───────┘││└───────┘││
│└─────────┘└─────────┘└─────────┘└─────────┘└─────────┘└─────────┘│
└──────────────────────────────────────────────────────────────────┘

However, Linux does not build sched domains for the pairs of cores
which share an L2 cache. On s390, IBM added sched domains for books,
that is, sets of cores which share an L2 cache. The support should
probably be added in a generic way for all archs thanks to generic cache
information.

Samuel
