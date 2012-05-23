Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233Ab2EWIXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:23:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33480 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423Ab2EWIX3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:23:29 -0400
Message-ID: <1337761402.9698.62.camel@twins>
Subject: Re: [PATCH 1/2] sched: add virt sched domain for the guest
From: Peter Zijlstra <peterz@infradead.org>
To: Liu ping fan <kernelfans@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>
Date: Wed, 23 May 2012 10:23:22 +0200
In-Reply-To: <CAFgQCTvhVs8-onz3huovYe=StOYJe2pJO-nka_7KogSju6AttQ@mail.gmail.com>
References: <1337754751-9018-1-git-send-email-kernelfans@gmail.com>
	 <1337754751-9018-2-git-send-email-kernelfans@gmail.com>
	 <1337759644.9698.49.camel@twins>
	 <CAFgQCTvhVs8-onz3huovYe=StOYJe2pJO-nka_7KogSju6AttQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 16:10 +0800, Liu ping fan wrote:
> the movement of vcpu
> threads among host nodes will break the topology initialized by -numa
> option. 

You want to remap vcpu to nodes? Are you bloody insane? cpu:node maps
are assumed static, you cannot make that a dynamic map and pray things
keep working.

Also, have you any idea how expensive it is to rebuild the topology vs
migrating the vcpu?


