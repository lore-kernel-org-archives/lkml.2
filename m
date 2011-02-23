Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1BWIXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 03:23:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:46321 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430Ab1BWIXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 03:23:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,211,1297065600"; 
   d="scan'208";a="712133913"
Subject: Re: [performance bug] kernel building regression on 64 LCPUs
 machine
From: "Alex,Shi" <alex.shi@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "Li, Shaohua" <shaohua.li@intel.com>, Corrado Zoccolo <czoccolo@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, "tytso@mit.edu" <tytso@mit.edu>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <20110221164909.GG6584@quack.suse.cz>
References: <1295402148.4773.143.camel@debian>
	 <1295402606.1949.871.camel@sli10-conroe>
	 <20110120151656.GC18875@redhat.com>
	 <20110126081529.GA28909@sli10-conroe.sh.intel.com>
	 <1297502512.29573.26.camel@debian>
	 <AANLkTi=B6kabp+NvRJC_g-AqQO0ZOvnEDYpVFmScttR6@mail.gmail.com>
	 <1297650318.29573.2482.camel@debian>
	 <1297732201.24560.2.camel@sli10-conroe>
	 <20110221164909.GG6584@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 16:24:47 +0800
Message-ID: <1298449487.14712.1064.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Though these patches can not totally recovered the problem, but they are
quite helpful with ccache enabled situation. It increase 10% performance
on 38-rc1 kernel. 
I have tried to enabled they to latest rc6 kernel but failed. the vmstat output is here: 
with patches:
r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
1.5 24.7 0.0 64316199.8 17240.8 153376.9 0.0 0.0 1777.1 1788.0 6479.0 2605.3 1.7 0.9 89.1 8.2 0.0
original 38-rc1 kernel:
2.4 32.3 0.0 63653302.9 17170.6 153125.3 0.0 0.0 1579.7 1834.1 6016.4 2407.0 1.5 0.7 86.6 10.1 0.0

It reduce write blocks clearly. 

> > can you send a patch with both ext3 and ext4 changes? Our test shows
> > your patch has positive effect, but need confirm with the ext3 change.
>   Sure. Patches for both ext3 & ext4 are attached. Sorry, it took me a
> while to get to this.
> 
> 									Honza


