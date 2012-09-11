Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169Ab2IKXZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:25:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:34531 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758885Ab2IKXZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:25:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,407,1344236400"; 
   d="scan'208";a="220939139"
Date: Wed, 12 Sep 2012 07:25:37 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Vivek Trivedi <t.vivek@samsung.com>
Subject: Re: [PATCH 1/2] writeback: add dirty_background_time per bdi variable
Message-ID: <20120911232537.GA13210@localhost>
References: <1346083274-3510-1-git-send-email-linkinjeon@gmail.com>
 <20120911014025.GA22077@localhost>
 <CAKYAXd_VucTrf=TeezrU28+Ja+41TAFCY3zfuBGvoMO9FXNB1A@mail.gmail.com>
 <CAKYAXd_Zdb_3rqwgf03To+DPw-wFXUGW-5km7KVaiJSymEuGMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd_Zdb_3rqwgf03To+DPw-wFXUGW-5km7KVaiJSymEuGMg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 08:12:40AM +0900, Namjae Jeon wrote:
> >>
> >> To be frank, no realistic NFS servers will use USB disk as backing
> >> storage. So that rational for reducing "initial" delays is weak.
> >> Continuous write performance to HDD is much more important. Do you
> >> have numbers for that?
> >
> > Actually, we use USB HDD and USB Flash devices at NFS server.
> > There can be other similar users as well. So it might be useful to
> > provide this tuning feature other.
> > As default value is zero, it is disabled by default and it should not
> > impact normal writeback.
> >
> > I will share large file writes test result on NFS client on USB HDD
> > with/without tuning with patch.
> Hi. Wu.
> I share 1GB continous write test result.
> 
> -> create a 1000 MB file
> For continuous write - create 1 GB file
> 
>  RecSize   WriteSpeed
> 10485760   10.47MB/sec
>  1048576   10.35MB/sec
>   524288   10.48MB/sec
>   262144   10.48MB/sec
>   131072   10.52MB/sec
>    65536   10.56MB/sec
>    32768   10.64MB/sec
>    16384   10.31MB/sec
>     8192   10.52MB/sec
>     4096   10.45MB/sec
> 
> I will update changelog in patch.

Thanks! What's the server side setting and can you give a comparison
of different background writeback thresholds? This is this patch's
target use cases, after all.

Thanks,
Fengguang
