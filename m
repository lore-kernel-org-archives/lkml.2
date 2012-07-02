Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab2GBV0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 17:26:22 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:37201 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab2GBV0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 17:26:20 -0400
Date: Mon, 2 Jul 2012 14:26:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Petr Holasek <pholasek@redhat.com>
cc: Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH v2] KSM: numa awareness sysfs knob
In-Reply-To: <20120630114053.GA3036@stainedmachine.redhat.com>
Message-ID: <alpine.DEB.2.00.1207021425110.24806@chino.kir.corp.google.com>
References: <1340970592-25001-1-git-send-email-pholasek@redhat.com> <20120629160510.GA10082@cmpxchg.org> <20120629163033.GA11327@stainedmachine.redhat.com> <20120629164706.GA7831@cmpxchg.org> <alpine.DEB.2.00.1206291526180.15200@chino.kir.corp.google.com>
 <20120630114053.GA3036@stainedmachine.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jun 2012, Petr Holasek wrote:

> The problem of the first patch/RFC was that merging algorithm was unstable
> and could merge pages with distance higher than was set up (described by 
> Nai Xia in RFC thread [1]). Sure, this instability could be solved, but for
> ksm pages shared by many other pages on different nodes we would have to still
> recalculate which page is "in the middle" and in case of change migrate it 
> between nodes every time when ksmd reach new shareable page or when some 
> sharing page is removed.
> 

Or you could simply refuse to ever merge any page that is identical to a 
page on a node with a distance greater than the threshold, i.e. never 
merge pages even under the threshold if a page exists on a node higher 
than the threshold.
