Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab1DOKwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 06:52:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:54272 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740Ab1DOKw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 06:52:29 -0400
Subject: Re: [PATCH] Attempt to clarify "Augmented Trees" section of
 Documentation/rbtree.txt
From: Peter Zijlstra <peterz@infradead.org>
To: Rob Landley <rlandley@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Pallipadi Venkatesh <venkatesh.pallipadi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>
In-Reply-To: <4DA7498C.7080006@parallels.com>
References: <4DA7498C.7080006@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Apr 2011 12:52:10 +0200
Message-ID: <1302864730.2388.237.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-14 at 14:22 -0500, Rob Landley wrote:
> +This function is called when either of a node's children change.  It is not
> +called recursively: the callback function is responsible for traversing parent
> +nodes and updating their information as necessary. 

static void rb_augment_path(struct rb_node *node, rb_augment_f func, void *data)
{
        struct rb_node *parent;

up:
        func(node, data);
        parent = rb_parent(node);
        if (!parent)
                return;

        if (node == parent->rb_left && parent->rb_right)
                func(parent->rb_right, data);
        else if (parent->rb_left)
                func(parent->rb_left, data);

        node = parent;
        goto up;
}

Uhm, what?
