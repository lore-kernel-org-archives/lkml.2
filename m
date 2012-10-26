Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab2JZG7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 02:59:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:5695 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501Ab2JZG7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 02:59:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,652,1344236400"; 
   d="scan'208";a="160832533"
Date: Fri, 26 Oct 2012 14:58:55 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Ni zhan Chen <nizhan.chen@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, YingHang Zhu <casualfisher@gmail.com>,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: readahead: remove redundant ra_pages in file_ra_state
Message-ID: <20121026065855.GA9179@localhost>
References: <CAA9v8mGjdi9Kj7p-yeLJx-nr8C+u4M=QcP5+WcA+5iDs6-thGw@mail.gmail.com>
 <20121024201921.GX4291@dastard>
 <CAA9v8mExDX1TYgCrRfYuh82SnNmNkqC4HjkmczSnz3Ca4zT_qw@mail.gmail.com>
 <20121025015014.GC29378@dastard>
 <CAA9v8mEULAEHn8qSsFokEue3c0hy8pK8bkYB+6xOtz_Tgbp0vw@mail.gmail.com>
 <50889FF1.9030107@gmail.com>
 <20121025025826.GB23462@localhost>
 <20121026002544.GI29378@dastard>
 <20121026012758.GA6282@localhost>
 <5089F5AD.5040708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5089F5AD.5040708@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static void shrink_readahead_size_eio(struct file *filp,
>                                         struct file_ra_state *ra)
>  {
> -       ra->ra_pages /= 4;
> +       spin_lock(&filp->f_lock);
> +       filp->f_mode |= FMODE_RANDOM;
> +       spin_unlock(&filp->f_lock);
> 
> As the example in comment above this function, the read maybe still
> sequential, and it will waste IO bandwith if modify to FMODE_RANDOM
> directly.

Yes immediately disabling readahead may hurt IO performance, the
original '/ 4' may perform better when there are only 1-3 IO errors
encountered.

Thanks,
Fengguang
