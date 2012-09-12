Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab2ILIFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:05:52 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51893 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751048Ab2ILIFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:05:45 -0400
Message-ID: <1347437141.2793.2.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without CAP_SYS_RAWIO
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, axboe@kernel.dk,
        linux-scsi@vger.kernel.org
Date: Wed, 12 Sep 2012 09:05:41 +0100
In-Reply-To: <504F7B65.9090603@redhat.com>
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com>
	 <20120911165953.GK7677@google.com> <504F7B65.9090603@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-11 at 19:56 +0200, Paolo Bonzini wrote:
> The set of use cases is so variable that no single filter can accomodate
> all of them: high availability people want persistent reservations, NAS
> people want trim/discard, but these are just two groups.  Someone is
> using a Windows VM to run vendor tools and wants to have access to
> vendor-specific commands.
> 
> You can tell this last group to use root, but not everyone else who is
> already relying on Unix permissions, SELinux and/or device cgroups to
> confine their virtual machines.

This is why the whole filter thing was mutable via sysfs.  That way the
admin could set this up per device.  It sounds like this is what you
want to fix, rather than opening up more holes in an already leaky
security apparatus.  The ideal is that we would be much more restrictive
by default and give root the ability to override this both globally and
per-device to conform to whatever policy it has for the virtual
environments.

The patch which removed all of the sysfs pieces was:

commit 018e0446890661504783f92388ecce7138c1566d
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Fri Jun 26 16:27:10 2009 +0200

    block: get rid of queue-private command filter

So that's probably the place to start for putting it back properly.

James


