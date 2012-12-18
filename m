Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab2LROYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 09:24:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909Ab2LROYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 09:24:16 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Joe Perches <joe@perches.com>, Marcelo Tosatti <mtosatti@redhat.com>
cc: dhowells@redhat.com, Alexander Graf <agraf@suse.de>,
        linux-kernel@vger.kernel.org
Subject: checkpatch.pl should check UAPI headers don't #include <uapi/...>
Date: Tue, 18 Dec 2012 14:23:30 +0000
Message-ID: <6433.1355840610@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Joe,

Can you make checkpatch.pl check that lines added to UAPI headers don't have
the form:

	#include <uapi/...>

or:

	#include "uapi/..."

Such as these should be regarded as errors as they will likely break userspace
which shouldn't get to see any uapi/ directories.

An example of this is in:

	commit 19bf7f8ac3f8131100027281c495dbbe00cd5ae0
	Merge: 787c57c 35fd3dc
	Author: Marcelo Tosatti <mtosatti@redhat.com>
	Date:   Mon Oct 29 19:15:32 2012 -0200

where during the conflict resolution, the following change was made:

	- #include <asm/epapr_hcalls.h>
	++#include <uapi/asm/epapr_hcalls.h>

I recognise that checkpatch.pl might not have helped in this case since it
isn't normally applied to merged as far as I know.

Thanks,
David
