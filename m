Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab0EGNlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 09:41:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab0EGNlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 09:41:00 -0400
Date: Fri, 7 May 2010 09:40:37 -0400
From: Josef Bacik <josef@redhat.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 3/3] Btrfs: add basic DIO read support
Message-ID: <20100507134035.GA3360@localhost.localdomain>
References: <20100506190101.GD13974@dhcp231-156.rdu.redhat.com> <20100507095537.GD19699@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507095537.GD19699@shareable.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 10:55:37AM +0100, Jamie Lokier wrote:
> Josef Bacik wrote:
> > 3) Lock the entire range during DIO.  I originally had it so we would lock the
> > extents as get_block was called, and then unlock them as the endio function was
> > called, which worked great, but if we ever had an error in the submit_io hook,
> > we could have locked an extent that would never be submitted for IO, so we
> > wouldn't be able to unlock it, so this solution fixed that problem and made it a
> > bit cleaner.
> 
> Does this prevent concurrent DIOs to overlapping or nearby ranges?
> 

It just prevents them from overlapping areas.  Thanks,

Josef
