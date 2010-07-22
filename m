Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab0GVXoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 19:44:37 -0400
Received: from kroah.org ([198.145.64.141]:41490 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526Ab0GVXo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 19:44:28 -0400
Date: Thu, 22 Jul 2010 16:41:41 -0700
From: Greg KH <greg@kroah.com>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH 3/6] Driver core: Fix memory leak on class_register
 error path
Message-ID: <20100722234141.GC674@kroah.com>
References: <1279836546-26913-1-git-send-email-ppannuto@codeaurora.org>
 <1279836546-26913-4-git-send-email-ppannuto@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279836546-26913-4-git-send-email-ppannuto@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 03:09:03PM -0700, Patrick Pannuto wrote:
> This leak is the same as the bus path; cp's kobj name
> is set, but kset_register fails, free'ing cp, but not
> cp->class_subsys.kobj.name

Same objection here, I don't like how you are having to "know" about how
kobject names are handled here.

thanks,

greg k-h
