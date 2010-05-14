Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab0ENHr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 03:47:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:52243 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768Ab0ENHrZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 03:47:25 -0400
Subject: Re: [PATCH RFC] perf: fix find_swevent_head() RCU lockdep splat
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       acme@redhat.com
In-Reply-To: <20100513204855.GD5377@nowhere>
References: <20100513182556.GA14326@linux.vnet.ibm.com>
	 <20100513190325.GB5377@nowhere> <20100513194605.GG2879@linux.vnet.ibm.com>
	 <20100513204855.GD5377@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 14 May 2010 09:47:05 +0200
Message-ID: <1273823225.5605.3604.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 22:48 +0200, Frederic Weisbecker wrote:
> +       head = find_swevent_head(cpuctx, event->attr.type,
> +                                event->attr.config, event); 

might as well only pass event and have the function do those derefs.
