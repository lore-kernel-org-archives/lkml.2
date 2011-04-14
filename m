Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1DNXji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 19:39:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964Ab1DNXjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 19:39:36 -0400
Date: Fri, 15 Apr 2011 01:38:42 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: raz ben yehuda <raziebe@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        riel@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org
Subject: Re: 2.6.38 page_test regression
Message-ID: <20110414233842.GJ15707@random.random>
References: <1302692638.15225.14.camel@raz.scalemp.com>
 <20110413125146.GR29444@random.random>
 <1302703579.17536.1.camel@raz.scalemp.com>
 <20110413172127.GB5734@random.random>
 <1302781754.5098.13.camel@raz.scalemp.com>
 <20110414150925.GD15707@random.random>
 <1302811643.10051.8.camel@raz.scalemp.com>
 <20110414215327.GI11871@csn.ul.ie>
 <20110414231648.GA30898@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414231648.GA30898@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 12:16:48AM +0100, Mel Gorman wrote:
> Theories better than slightly-different-register-use are welcome.

__pte_alloc_one is now skipped 511 times every 512 page faults, so we
call alloc_pages 512 times less and we take page_table_lock 512 times
less, that explains it I think. We need it...
