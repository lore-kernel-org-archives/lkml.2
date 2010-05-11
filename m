Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab0EKQqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:46:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39282 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab0EKQqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:46:16 -0400
Date: Tue, 11 May 2010 17:45:54 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Tony Lindgren <tony@atomide.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100511164554.GA17016@srcf.ucam.org>
References: <1272667021-21312-1-git-send-email-arve@android.com> <87wrvl5479.fsf@deeprootsystems.com> <87632vhbs8.fsf@deeprootsystems.com> <201005102225.52431.rjw@sisk.pl> <20100511161227.GD13600@atomide.com> <20100511161448.GA16148@srcf.ucam.org> <20100511163632.GE13600@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511163632.GE13600@atomide.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 09:36:33AM -0700, Tony Lindgren wrote:
> OK, so can the suspend blocker then become just:
> 
> # Block suspend while idle, system stays running
> # echo default > /sys/power/policy
> 
> and the when it's OK to suspend:
> 
> # Allow suspend while idle, system suspends when it hits kernel idle loop
> # echo opportunistic > /sys/power/policy
> 
> or do you still need something more to ensure the data gets into your
> app and be handled?

Yes. You still need suspend blocks.

> The part I really don't like is the idea of patching all over the drivers
> and userspace for the wakelocks/suspendblocks.

I don't like the idea either, but given that nobody has actually 
provided any other ideas that would actually work then I don't think 
we've got a great deal of choice.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
