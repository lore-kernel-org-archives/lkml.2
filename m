Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab0EKRbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:31:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33407 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab0EKRbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:31:02 -0400
Date: Tue, 11 May 2010 18:30:36 +0100
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
Message-ID: <20100511173036.GB17868@srcf.ucam.org>
References: <87wrvl5479.fsf@deeprootsystems.com> <87632vhbs8.fsf@deeprootsystems.com> <201005102225.52431.rjw@sisk.pl> <20100511161227.GD13600@atomide.com> <20100511161448.GA16148@srcf.ucam.org> <20100511163632.GE13600@atomide.com> <20100511164554.GA17016@srcf.ucam.org> <20100511165821.GA13931@atomide.com> <20100511170348.GA17443@srcf.ucam.org> <20100511172442.GB13931@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511172442.GB13931@atomide.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 10:24:43AM -0700, Tony Lindgren wrote:

> For the failed suspend path in the kernel, currently the kernel would
> unwind back all the drivers because of the failed driver, but that path
> should be possible to optimize.

If you think it's possible to make this work then feel free to. But at 
the point where you're adding code to every driver's suspend function to 
determine whether or not it's got any pending events that userspace 
hasn't consumed yet, and adding code to every bit of userspace to allow 
it to indicate whether or not it's busy consuming events or just busy 
drawing 3D bouncing cattle, I think you've reinvented suspend blocks.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
