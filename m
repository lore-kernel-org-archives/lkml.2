Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab1AGLXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 06:23:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab1AGLXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 06:23:52 -0500
Date: Fri, 7 Jan 2011 08:48:59 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM TSC trapping / migration 2/2] Add TSC KHZ MSR
Message-ID: <20110107104859.GA12056@amt.cnet>
References: <1294308645-31113-1-git-send-email-zamsden@redhat.com>
 <1294308645-31113-3-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294308645-31113-3-git-send-email-zamsden@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 12:10:45AM -1000, Zachary Amsden wrote:
> Use an MSR to allow "soft" migration to hosts which do not support
> TSC trapping.  Rather than make this a required element of any
> migration protocol, we allow the TSC rate to be exported as a data
> field (useful in its own right), but we also allow a one time write
> of the MSR during VM creation.  The result is that for the common
> use case, no protocol change is required to communicate TSC rate
> to the receiving host.

Migration to hosts which do not support the feature can be achieved by
saving/restoring the TSC rate + flags in a subsection. A subsection
seems more appropriate than an MSR for this.

> This allows administrative tools to configure migration policy
> as they see appropriate.  Rather than dictate this policy with the
> KVM implementation, we properly allow migration to hosts which both
> do and do not support setting of the TSC rate on the receiving end.
> If it is wished to not support migration to a host which lacks
> support for the TSC rate feature, that can be coordinated externally.
> 
> Signed-off-by: Zachary Amsden <zamsden@redhat.com>
