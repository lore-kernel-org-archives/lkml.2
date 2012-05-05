Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732Ab2EEC2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 22:28:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61278 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2EEC2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 22:28:05 -0400
Date: Fri, 4 May 2012 19:26:42 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Philip Rakity <prakity@marvell.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] max17042_battery: fix a couple buffer overflows
Message-ID: <20120505022642.GA812@lizard>
References: <20120315113732.GA364@elgon.mountain>
 <4F6224E2.5060006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F6224E2.5060006@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 10:20:34AM -0700, Dirk Brandewie wrote:
> On 03/15/2012 04:37 AM, Dan Carpenter wrote:
> >There are a couple issues here caused by confusion between sizeof()
> >and ARRAY_SIZE().  "table_size" should be the number of elements, but we
> >should allocate it with kcalloc() so that we allocate the correct number
> >of bytes.
> >
> >In max17042_init_model() we don't allocate enough space so we go past
> >the end of the array in max17042_read_model_data() and
> >max17042_model_data_compare().
> >
> >In max17042_verify_model_lock() we allocate the right amount of space
> >but we call max17042_read_model_data() with the wrong number of elements
> >and also in the for loop we go past the end of the array.
> >
> >Signed-off-by: Dan Carpenter<dan.carpenter@oracle.com>
> Acked-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> Typo in first ack :-(

Applied, thanks! :-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
