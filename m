Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab2G0Tb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 15:31:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54062 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab2G0TbZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 15:31:25 -0400
Message-ID: <1343417470.32120.39.camel@twins>
Subject: Re: [PATCH 4/6] rbtree: faster augmented insert
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: riel@redhat.com, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Fri, 27 Jul 2012 21:31:10 +0200
In-Reply-To: <1342787467-5493-5-git-send-email-walken@google.com>
References: <1342787467-5493-1-git-send-email-walken@google.com>
	 <1342787467-5493-5-git-send-email-walken@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 05:31 -0700, Michel Lespinasse wrote:
> 
> rb_insert_color() is now a special case of rb_insert_augmented() with
> a do-nothing callback. I used inlining to optimize out the callback,
> with the intent that this would generate the same code as previously
> for rb_insert_augmented(). This didn't fully work, as my compiler output
> is now *smaller* than before for that function. Speed wise, they seem
> comparable though. 

It might be good to mention which particular GCC you're using.
