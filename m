Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab1EKQ0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:26:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61492 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab1EKQ0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:26:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ctS6wAVc0r5ZNO9atuZfLJtvspOMnToiBwqeKybP4YmbvhU4gM3S8W2PH1VMK4EXnS
         4OGRcHDFiLk74eBnH6BXOx3gndwteZh6SJz8jKxccIYifIavUCMxB9bANHkC4IGXbCbA
         WSWJeDaP7DreXRKS5x3hxQC57Mria9ZY4bSYY=
Date: Wed, 11 May 2011 15:33:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf: Carve out cgroup-related code
Message-ID: <20110511133340.GB1846@nowhere>
References: <1305119816-26280-1-git-send-email-bp@amd64.org>
 <1305119816-26280-2-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305119816-26280-2-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Stephane in Cc)

On Wed, May 11, 2011 at 03:16:55PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Move cgroup perf support into a different compilation module -
> kernel/events/cgroup.c - thus slimming perf_event.c some more.
> 
> While at it,
> 
> * push some oneliners into perf_event.h now that they're used in
> multiple .c files.
> 
> * drop is_cgroup_event() check for perf_cgroup_defer_enabled() at its
> callsite in __perf_event_enable since the latter does the check anyway.
> 
> No functional change.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

BTW, before you do it yourself, I have a patch pending that splits the buffer
part from the core.

Just to avoid effort duplicates... :)
