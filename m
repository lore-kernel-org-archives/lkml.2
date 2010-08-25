Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab0HYVLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 17:11:33 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:33584 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754282Ab0HYVLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 17:11:31 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: EhALbBwVM1nnFEie6N1bFTAyFfupL5uNyEq5ZJ4ShNyK6cH
 Y0ANt1rRrzXr0tf.TF98tjMmjZpkzqhml0t5elX5D3Dyl9tdxd67bFWD3ckm
 7o88ggkpOpN42jm9Qsy0SfUeXQKyZNXf0S8xrmS2kFnq89BijIT1ZICb9vq1
 YvOhUDZffzM8IrSUXVyR0.zcIEBavpmKo.W33BZuXuQahI6kPEvnaYUVIx7U
 Ye6jwsQG1803eP15JowXQCqsRFFYf
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 25 Aug 2010 16:11:24 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Peter Zijlstra <peterz@infradead.org>, Dave Chinner <david@fromorbit.com>,
        "Ted Ts'o" <tytso@mit.edu>, Jens Axboe <jaxboe@fusionio.com>,
        Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        Alasdair G Kergon <agk@redhat.com>,
        Chris Mason <chris.mason@oracle.com>,
        Steven Whitehouse <swhiteho@redhat.com>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
In-Reply-To: <alpine.DEB.2.00.1008251347550.16484@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1008251604120.24931@router.home>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <1282656558.2605.2742.camel@laptop> <4C73CA24.3060707@fusionio.com> <alpine.DEB.2.00.1008241309170.21242@chino.kir.corp.google.com> <20100825112433.GB4453@thunk.org>
 <1282736132.2605.3563.camel@laptop> <20100825115709.GD4453@thunk.org> <1282740516.2605.3644.camel@laptop> <20100825132417.GQ31488@dastard> <1282743342.2605.3707.camel@laptop> <alpine.DEB.2.00.1008251347550.16484@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have __GFP_NOFAIL behavior for slab allocations since
a __GFP_NOFAIL flag is passed through to the page allocator if no objects
are available.

The page allocator will do the same as when called directly with
__GFP_NOFAIL and so we have consistent behavior regardless of the
allocator used.




