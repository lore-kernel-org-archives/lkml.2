Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab1AYBZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:25:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab1AYBZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:25:29 -0500
Subject: Re: [PATCH 14/16] KVM-GST: KVM Steal time registration
From: Glauber Costa <glommer@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>
In-Reply-To: <4D3E0BB9.5070805@redhat.com>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
	 <1295892397-11354-15-git-send-email-glommer@redhat.com>
	 <4D3E0BB9.5070805@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Mon, 24 Jan 2011 23:25:12 -0200
Message-ID: <1295918712.15920.16.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 18:31 -0500, Rik van Riel wrote:
> On 01/24/2011 01:06 PM, Glauber Costa wrote:
> > Register steal time within KVM. Everytime we sample the steal time
> > information, we update a local variable that tells what was the
> > last time read. We then account the difference.
> >
> > Signed-off-by: Glauber Costa<glommer@redhat.com>
> > CC: Rik van Riel<riel@redhat.com>
> > CC: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
> > CC: Peter Zijlstra<peterz@infradead.org>
> > CC: Avi Kivity<avi@redhat.com>
> 
> On second thought - how does this deal with cpu hotplug and
> hot unplug?
> 
> Do you allocate a new one of these structs every time a cpu
> is hot unplugged and then hotplugged, leaking the old one?
> 
> Will leaving the old value around confuse the steal time
> calculation?

If you look closely, there are no allocations happening at all,
it's all static.

