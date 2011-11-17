Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab1KQWyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 17:54:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab1KQWyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 17:54:22 -0500
Date: Thu, 17 Nov 2011 23:53:54 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>, linux-kernel@vger.kernel.org,
        linux-mm@vger.kernel.org, kernel-team@fedoraproject.org
Subject: Re: long sleep_on_page delays writing to slow storage
Message-ID: <20111117225354.GL3306@redhat.com>
References: <20111107045928.GK8927@hexapodia.org>
 <20111109170027.GB7495@quack.suse.cz>
 <20111109175201.GB3083@suse.de>
 <20111109180646.GM5075@redhat.com>
 <20111110093442.GG3153@redhat.com>
 <20111114184717.GA7006@redhat.com>
 <20111115101313.GA28350@suse.de>
 <20111117194719.GA23213@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111117194719.GA23213@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Thu, Nov 17, 2011 at 02:47:20PM -0500, Dave Jones wrote:
> When I build a kernel on my laptop, when it gets to the final link stage,
> and there's a ton of IO, my entire X session wedges for a few seconds.
> This may be unrelated, because this is on an SSD, which shouldn't suffer
> from the slow IO of the USB devices mentioned in this thread.
> 
> (This is even with that patch applied btw, perhaps adding further fuel to
> the idea that it's unrelated).

Agreed, if it happens even with the patch applied it's most certainly
not related to compaction. Maybe more IO scheduler related, or
something like that. You can also try to set
transparent_hugepage/defrag to "never" to be sure, then compaction
won't run.
