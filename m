Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2BPXPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 18:15:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098Ab2BPXPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 18:15:37 -0500
Date: Thu, 16 Feb 2012 18:15:34 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: soft lockup detector & virtualisation
Message-ID: <20120216231533.GA7392@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lately I've noticed quite a few soft lockup bugs being reported.
In many of them, they're coming from inside virtual guests.

Is the softlockup detector fundamentally broken in this situation ?

If the host doesn't schedule the guest for whatever reason,
or the user suspends the VM and resumes it later ?

Here's the most recent example:
https://bugzilla.redhat.com/attachment.cgi?id=563767

In many of these, the code where it's "stuck" isn't anything
special, which is why I think the guest just hasn't had a
timeslice in 185 seconds.

Is there some way we can perhaps detect we're running virtualised,
and disable the detector automatically ?

thoughts ?

	Dave

