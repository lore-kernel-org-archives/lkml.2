Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0JTPD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 11:03:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:49656 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab0JTPD5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 11:03:57 -0400
Subject: Re: [PATCH v3] Add generic exponentially weighted moving average
 (EWMA) function
From: Peter Zijlstra <peterz@infradead.org>
To: Bruno Randolf <br1@einfach.org>
Cc: randy.dunlap@oracle.com, akpm@linux-foundation.org,
        kevin.granade@gmail.com, Lars_Ericsson@telia.com, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101020082336.28281.77747.stgit@localhost6.localdomain6>
References: <20101020082336.28281.77747.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Oct 2010 17:03:43 +0200
Message-ID: <1287587023.3488.27.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 17:23 +0900, Bruno Randolf wrote:
> +/**
> + * ewma_add() - Exponentially weighted moving average (EWMA)
> + * @avg: Average structure
> + * @val: Current value
> + *
> + * Add a sample to the average.
> + */
> +struct ewma*
> +ewma_add(struct ewma *avg, const unsigned int val)
> +{
> +       avg->internal = avg->internal  ?
> +               (((avg->internal * (avg->weight - 1)) +
> +                       (val * avg->factor)) / avg->weight) :
> +               (val * avg->factor);
> +       return avg;
> +}
> +EXPORT_SYMBOL(ewma_add); 

How can it be a weighted avg if each sample has the same weight?
