Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab0EET2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 15:28:35 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42492 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757990Ab0EET2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 15:28:33 -0400
Date: Wed, 5 May 2010 20:28:11 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100505192811.GA5468@srcf.ucam.org>
References: <20100505190758.GG7139@rakim.wolfsonmicro.main> <Pine.LNX.4.44L0.1005051515060.1885-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005051515060.1885-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 03:20:40PM -0400, Alan Stern wrote:

> One the face of it, a runtime-PM solution would dictate that the
> codec's driver ought to turn off the codec whenever the driver thinks
> it isn't being used.  Ergo, if the driver didn't know when a call was
> in progress, it would use runtime PM to turn off the codec during a
> call.

Well, part of the problem is that right now most of our beliefs about 
imposed constraints tend to be based on what userspace is doing - "Don't 
power down the audio codec when userspace has it open", for instance. 
But that goes away with opportunistic suspend. In most cases you don't 
want the audio codec to stay awake just because userspace was using it 
to make bouncing cow noises, especially if you've just frozen userspace. 
So the problem becomes more complicated than it would otherwise be.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
