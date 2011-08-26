Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab1HZMMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 08:12:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34577 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab1HZMMU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 08:12:20 -0400
Subject: Re: [PATCH 2/5] writeback: dirty position control
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 26 Aug 2011 14:11:50 +0200
In-Reply-To: <20110826112637.GA17785@localhost>
References: <1314027488.24275.74.camel@twins>
	 <20110823034042.GC7332@localhost> <1314093660.8002.24.camel@twins>
	 <20110823141504.GA15949@localhost> <20110823174757.GC15820@redhat.com>
	 <20110824001257.GA6349@localhost> <1314202378.6925.48.camel@twins>
	 <20110826001846.GA6118@localhost> <1314349469.26922.24.camel@twins>
	 <20110826100428.GA7996@localhost> <20110826112637.GA17785@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314360710.11049.1.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-26 at 19:26 +0800, Wu Fengguang wrote:
> Now I get 3 figures. Test case is: run 1 dd write task for 300s, with
> a "disturber" dd read task during roughly 120-130s. 

Ah, but ideally the disturber task should run in bursts of 100ms
(<feedback period), otherwise your N is indeed mostly constant.


