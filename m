Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab2HFOYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:24:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:58027 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534Ab2HFOXo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:23:44 -0400
Message-ID: <1344263015.27828.58.camel@twins>
Subject: Re: [PATCH v2 2/9] rbtree: optimize fetching of sibling node
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: riel@redhat.com, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Mon, 06 Aug 2012 16:23:35 +0200
In-Reply-To: <1343946858-8170-3-git-send-email-walken@google.com>
References: <1343946858-8170-1-git-send-email-walken@google.com>
	 <1343946858-8170-3-git-send-email-walken@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-02 at 15:34 -0700, Michel Lespinasse wrote:

> +		tmp = gparent->rb_right;
> +		if (parent != tmp) {	/* parent == gparent->rb_left */

> +			tmp = parent->rb_right;
> +			if (node == tmp) {

> +			tmp = parent->rb_left;
> +			if (node == tmp) {

> +		sibling = parent->rb_right;
> +		if (node != sibling) {	/* node == parent->rb_left */


Half of them got a comment, the other half didn't.. is there any
particular reason for that?
