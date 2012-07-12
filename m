Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161376Ab2GLQ6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 12:58:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:54239 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161360Ab2GLQ6g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 12:58:36 -0400
Message-ID: <1342112309.28010.14.camel@twins>
Subject: Re: perf with precise attribute kills all KVM based VMs
From: Peter Zijlstra <peterz@infradead.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 12 Jul 2012 18:58:29 +0200
In-Reply-To: <20120712161359.GJ7298@redhat.com>
References: <4FFAEFF1.9000706@redhat.com> <1341845999.3462.86.camel@twins>
	 <4FFCBD00.1030109@gmail.com> <20120711071006.GF23898@redhat.com>
	 <1342000187.3462.134.camel@twins> <20120711095337.GJ23898@redhat.com>
	 <4FFE4E8D.90606@gmail.com> <20120712042923.GG7298@redhat.com>
	 <4FFEEB55.5070009@gmail.com> <20120712160634.GI7298@redhat.com>
	 <20120712161359.GJ7298@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 19:13 +0300, Gleb Natapov wrote:
> BTW what is you host cpu? My patch works only for those that have global
> control register to disable PMU events, but that should cover most of
> moder cpus. 

That covers everything but core and p4, and I don't think we support
PEBS on either of those.

that said, you might want to also clear EN on the individual counters,
just in case the PEBS clear and DS_AREA clear aren't working.

The SDM is pretty clear on what you _should_ do to enable/disable PEBS,
doing less _might_ work but...
