Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab0DSKjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 06:39:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39947 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab0DSKjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 06:39:09 -0400
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
In-Reply-To: <4BC8CA52.4090703@goop.org>
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>
	 <1271356648-5108-2-git-send-email-glommer@redhat.com>
	 <4BC8CA52.4090703@goop.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 12:39:05 +0200
Message-ID: <1271673545.1674.743.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-16 at 13:36 -0700, Jeremy Fitzhardinge wrote:
> > +     do {
> > +             last = last_value;
> >   
> Does this need a barrier() to prevent the compiler from re-reading
> last_value for the subsequent lines?  Otherwise "(ret < last)" and
> "return last" could execute with different values for "last".
> 
ACCESS_ONCE() is your friend.

