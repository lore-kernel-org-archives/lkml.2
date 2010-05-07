Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab0EGJzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 05:55:40 -0400
Received: from mail2.shareable.org ([80.68.89.115]:53809 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670Ab0EGJzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 05:55:38 -0400
Date: Fri, 7 May 2010 10:55:37 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Josef Bacik <josef@redhat.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] Btrfs: add basic DIO read support
Message-ID: <20100507095537.GD19699@shareable.org>
References: <20100506190101.GD13974@dhcp231-156.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506190101.GD13974@dhcp231-156.rdu.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josef Bacik wrote:
> 3) Lock the entire range during DIO.  I originally had it so we would lock the
> extents as get_block was called, and then unlock them as the endio function was
> called, which worked great, but if we ever had an error in the submit_io hook,
> we could have locked an extent that would never be submitted for IO, so we
> wouldn't be able to unlock it, so this solution fixed that problem and made it a
> bit cleaner.

Does this prevent concurrent DIOs to overlapping or nearby ranges?

Thanks,
-- Jamie
