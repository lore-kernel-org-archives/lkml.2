Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab0EEXJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 19:09:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52633 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754686Ab0EEXJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 19:09:19 -0400
Date: Thu, 6 May 2010 00:09:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: tytso@mit.edu, Matthew Garrett <mjg@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Brian Swetland <swetland@google.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve Hj?nnev?g <arve@android.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, rebecca@android.com
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100505230917.GA5269@opensource.wolfsonmicro.com>
References: <20100505185225.GA4411@srcf.ucam.org> <201005052244.03225.rjw@sisk.pl> <20100505215711.GA4838@opensource.wolfsonmicro.com> <201005060005.01215.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005060005.01215.rjw@sisk.pl>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 12:05:01AM +0200, Rafael J. Wysocki wrote:

> So, gnerenally, we may need a mechanism to specify which components of the
> system need to stay powered while the whole system is suspended (in addition to
> wakeup devices, that is).

> That certainly I can agree with.

> I'm not sure, however, in what way this is relevant to the $subject patchset.

The patch set essentially makes using a full system suspend as the
lowest power state for runtime PM part of the standard Linux power
management toolkit which means that it's no longer clear as it used to
be that suspend is an instruction to cease all activity and go into a
minimal power state if the device is not a wake source.  In the primary
existing application this change interoperates very poorly with at least
the current audio subsystem since that handles suspend by ceasing all
activity and powering as much as it can off, which is sensible for
manual only suspends but highly undesirable for opportunistic suspend in
phones.  We should therefore have some idea how this and any other
affected areas are supposed to work.

As I said in my reply to Ted earlier I think we may actually be
converging on not worrying too much about it at the global level and
doing subsystem specific things to discover and handle affected cases,
at least for the time being.  Ideally we'd have something standard to
hook into but no subsystems apart from audio have actually been
identified as being affected so it's not clear to me that a general
solution is going to be worth the effort, if there's no actual users it
may just confuse people by adding yet more power managment stuff to
learn.
