Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab0LTTOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 14:14:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932243Ab0LTTOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 14:14:06 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Slow disks.
References: <20101220141553.GA6088@bitwizard.nl>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 20 Dec 2010 14:09:01 -0500
In-Reply-To: <20101220141553.GA6088@bitwizard.nl> (Rogier Wolff's message of
	"Mon, 20 Dec 2010 15:15:53 +0100")
Message-ID: <x49bp4gw9bm.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rogier Wolff <R.E.Wolff@BitWizard.nl> writes:

> Hi,
>
> A friend of mine has a server in a datacenter somewhere. His machine
> is not working properly: most of his disks take 10-100 times longer
> to process each IO request than normal. 
>
> iostat -kx 10 output: 
> Device: rrqm/s wrqm/s r/s  w/s  rkB/s wkB/s avgrq-sz avgqu-sz await svctm %util
> sdd     0.30   0.00   0.40 1.20 2.80  1.10  4.88     0.43  271.50 271.44  43.43

You are doing ~4KB I/Os and driving a queue depth of <1.  If you are
seeking all over the disk and mixing reads and writes, you may very well
trigger bad behaviour like this for SATA disks.

To further diagnose the issue, I'd recommend running blktrace on one of
the devices.  If you report results here, could you also include more
information about the hardware, the storage layout (including any dm/md
drivers and file systems involved) and the workload?  Also, please let
us know which I/O scheduler you're using.

> These syptoms started when the system was running 2.6.33, but are
> still present now the system has been upgraded to 2.6.36.

Are you sure it was a kernel change that caused the issue?  In other
words, can you run with the 2.6.32 and confirm that the issue is not
present?

Thanks,
Jeff
