Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab1LEKku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 05:40:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804Ab1LEKks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 05:40:48 -0500
Date: Mon, 5 Dec 2011 12:40:44 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Liu ping fan <kernelfans@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, aliguori@us.ibm.com, jan.kiszka@web.de
Subject: Re: [PATCH] kvm: make vcpu life cycle separated from kvm instance
Message-ID: <20111205104044.GI12507@redhat.com>
References: <4ED212A1.3060300@redhat.com>
 <1322807192-14147-1-git-send-email-kernelfans@gmail.com>
 <4EDB4A0D.1000609@redhat.com>
 <CAFgQCTujv7Ez23GySc4Bds8x9Pv8Ny59EohpN22de9wicztWrw@mail.gmail.com>
 <4EDC8F4B.7040308@redhat.com>
 <20111205094240.GE12507@redhat.com>
 <4EDC95E0.20503@redhat.com>
 <20111205101842.GH12507@redhat.com>
 <4EDC9B7D.9080209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDC9B7D.9080209@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 12:22:53PM +0200, Avi Kivity wrote:
> On 12/05/2011 12:18 PM, Gleb Natapov wrote:
> > > 
> > > We can, but that's a bigger change.
> > > 
> > Is it? I do not see a lot of accesses to vcpu array except those loops.
> >
> 
> Well actually some of those loops have to go away and be replaced by a
> hash lookup with apic id as key.
> 
Yes, but apic ids are guest controllable, so there should be separate hash that
will hold vcpu to gust configured apic id mapping. Shouldn't prevent us
from moving to rculist now.

--
			Gleb.
