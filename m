Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab2GKJxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 05:53:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab2GKJxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 05:53:19 -0400
Message-ID: <4FFD4D0A.2000202@redhat.com>
Date: Wed, 11 Jul 2012 12:53:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: mst@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v3 0/2] kvm: level irqfd and new eoifd
References: <20120703191106.6735.78272.stgit@bling.home>
In-Reply-To: <20120703191106.6735.78272.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2012 10:21 PM, Alex Williamson wrote:
> Here's the latest iteration of adding an interface to assert and
> de-assert level interrupts from external drivers like vfio.  These
> apply on top of the previous argument cleanup, documentation, and
> sanitization patches for irqfd.  It would be great to get this queued
> in next for linux 3.6.
> 
> I believe I've addressed all the previous comments, including fixing
> the locking problems in eoifd.  I've run this with lockdep adding
> and removing level irqfd/eoifd pairs without any problems.  Please
> let me know if there are any further comments.  Thanks,

Is there any performance justification for level irqfd?  Don't all
new/high bandwidth devices support msi, and this is just a legacy path?

eoifd does add new functionality (which parallels the existing ack
notifier usage in kvm device assignment); it's not just an optimization.

-- 
error compiling committee.c: too many arguments to function


