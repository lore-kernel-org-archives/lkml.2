Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2AZTQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 14:16:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061Ab2AZTQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 14:16:37 -0500
Date: Thu, 26 Jan 2012 14:01:14 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Maxim Patlasov <maxim.patlasov@gmail.com>, joe@perches.com,
        kzak@redhat.com, linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
Message-ID: <20120126190114.GG1891@redhat.com>
References: <CA+X1aCQRpJ_NwJBSBp+vDN37p+oipJNz=6T5LdJdqzxTiSWWWA@mail.gmail.com>
 <4EFD012D.7040602@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EFD012D.7040602@cfl.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 07:09:17PM -0500, Phillip Susi wrote:

[..]
> > Btw, do we really need both part_nr_sects_write_begin and
> > part_nr_sects_write_end? What about:
> 
> Good points.  I also noticed that the read/write functions were only being called when not holding the mutex.  If anyone is touching nr_sects without the mutex, then everyone must use the read/write functions, whether they hold the mutex or not.  Otherwise, a mutex holder that touches it directly will race with a non mutex holder using the seqcounter.

Sorry for a very late reply. I was on vacation.

I thought update will always happen with mutex lock held. That's what
sequence counter expects so that two updaters don't race. Just that while
updating under mutex lock, we still need to use sequence counter mecahinsm
to update values so that any readers out there not holding mutex don't
get confused.

Did I miss some code where nr_sects is being read without mutex and I
have not use sequence counter version to read it?

> Vivek, rather than fix the rest of the references to nr_sects to use the read/write functions, why not just fix the few sites that were accessing it without the mutex to take the mutex fist instead of using a seqcounter?

Right now readers can afford not to take lock. Introducing mutex on read
side with just add to the cost. Especially IO submission path where we
map IO to a partitiona and we wouldn't want to take mutexes there?

Are you still pursuing this pathset? Sounds like a useful functionality
to have.

Thanks
Vivek
