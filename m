Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab0ITTLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:11:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935Ab0ITTLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:11:42 -0400
Date: Mon, 20 Sep 2010 15:35:47 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Tejun Heo <tj@kernel.org>,
        Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: fix irqfd assign/deassign race
Message-ID: <20100920183547.GC27404@amt.cnet>
References: <20100919170231.GA12620@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100919170231.GA12620@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 07:02:31PM +0200, Michael S. Tsirkin wrote:
> I think I see the following (theoretical) race:
> 
> During irqfd assign, we drop irqfds lock before we
> schedule inject work. Therefore, deassign running
> on another CPU could cause shutdown and flush to run
> before inject, causing user after free in inject.
> 
> A simple fix it to schedule inject under the lock.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---

Applied, thanks.

