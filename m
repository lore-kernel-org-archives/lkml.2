Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab2DOPMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 11:12:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44627 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab2DOPMe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 11:12:34 -0400
Message-ID: <1334502742.28150.13.camel@twins>
Subject: Re: [PATCH] perf tools: Add 'G' and 'H' modifiers to event parsing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: acme@ghostprotocols.net, mingo@redhat.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, avi@redhat.com
Date: Sun, 15 Apr 2012 17:12:22 +0200
In-Reply-To: <20120415145948.GK11918@redhat.com>
References: <20120415145948.GK11918@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-15 at 17:59 +0300, Gleb Natapov wrote:
> -modifier_event [ukhp]{1,5}
> +modifier_event [ukhpGH]{1,5} 

You'd also need to increase the 5 to 7 I think, unless there's a clear
exclusion with some of the other flags.

Hmm, as it stands I think the 5 is already too low: "ukhppp" is 6.

We should really write this as ['u'] ['k'] ['h'] ['G'] ['H'] ['p'{1,3}],
not the combined thing.
