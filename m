Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1ASSv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 13:51:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab1ASSv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 13:51:28 -0500
Date: Wed, 19 Jan 2011 13:51:21 -0500
From: Josef Bacik <josef@redhat.com>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>,
        Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: remove unneeded allocation in
	load_free_space_cache()
Message-ID: <20110119185120.GA4050@localhost.localdomain>
References: <20110119153436.GA1358@kwango.lan.net> <20110119165836.GB1358@kwango.lan.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119165836.GB1358@kwango.lan.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 06:58:37PM +0200, Ilya Dryomov wrote:
> I messed up size argument of kzalloc() and consequently memcpy().  Here
> is an updated version.
> 
> 
> The checksums array is unused, remove it.  We only need disk_crcs array
> to verify checksums.
> 
> There is no need to allocate first_page_offset bytes for disk_crcs
> array.  It's enough to allocate (sizeof(u32) * num_checksums) bytes
> because disk_crcs should only hold checksums.  gen is fetched
> directly from the page.
> 
> cur_crc is initialized later in the code.  Don't initialize it in a
> declaration.
> 
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
