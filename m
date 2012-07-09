Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab2GIOYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:24:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60571 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab2GIOYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:24:16 -0400
Message-ID: <1341843844.3462.75.camel@twins>
Subject: Re: perf with precise attribute kills all KVM based VMs
From: Peter Zijlstra <peterz@infradead.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 09 Jul 2012 16:24:04 +0200
In-Reply-To: <20120709141904.GC7298@redhat.com>
References: <4FFAE6D8.5050609@gmail.com> <20120709141904.GC7298@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 17:19 +0300, Gleb Natapov wrote:
> Yes, this is knows problem that I can't find time to fix. The crash is
> cause by CPU using host PEBS virtual address while guest is running
> which causes guest memory corruption. We should disable evens that use
> PEBS at the guest entry. 

Whoops.. so the hardware is reading the DS address as programmed by the
host (host linear address) and using it as a guest linear address?

Quality stuff..

Disabling PEBS events for guests isn't pretty though.. but I guess the
only alternative is mapping the DS into the guest and reprogramming
MSR_IA32_DS_AREA which is all a little involved I suppose?
