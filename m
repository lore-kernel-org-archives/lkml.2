Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919Ab0EYRAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 13:00:15 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57832 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab0EYRAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 13:00:12 -0400
Date: Tue, 25 May 2010 12:55:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: iwl3945 dies (oops) in post 2.6.34 kernels
Message-ID: <20100525165524.GD31753@tuxdriver.com>
References: <20100525163920.GA2730@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100525163920.GA2730@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 09:39:20AM -0700, Dmitry Torokhov wrote:
> Hi,
> 
> I am getting the following crashers in iwl3945 after updating to
> post-2.6.34 kernels. This is with the pull from Linus's tree as of last
> night (the taint is from nvidia module):

Linus doesn't have this one yet:

commit 073d5eab6fc85b6c278d507a5633b759a85dc878
Author: Reinette Chatre <reinette.chatre@intel.com>
Date:   Thu May 13 14:49:44 2010 -0700

    iwlwifi: fix internal scan race
    
    It is possible for internal scan to race against itself if the device is
    not returning the scan results from first requests. What happens in this
    case is the cleanup done during the abort of the first internal scan also
    cleans up part of the new scan, causing it to access memory it shouldn't.
...

I suspect it might be related.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
