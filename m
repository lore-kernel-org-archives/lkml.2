Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab2HCR70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 13:59:26 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34939 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab2HCR7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 13:59:21 -0400
X-Originating-IP: 217.70.178.144
X-Originating-IP: 173.246.103.110
Date: Fri, 3 Aug 2012 10:59:11 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, paul.gortmaker@windriver.com
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
Message-ID: <20120803175911.GA3737@jtriplet-mobl1>
References: <501A4FC1.8040907@gmail.com>
 <20120802103244.GA23318@leaf>
 <501A633B.3010509@gmail.com>
 <501A7AD3.7000008@gmail.com>
 <20120802161556.GA25572@leaf>
 <501AAF47.3090708@gmail.com>
 <20120802174457.GA6251@jtriplet-mobl1>
 <501ABEE2.10007@gmail.com>
 <20120802204157.GB7916@jtriplet-mobl1>
 <501AF555.3050004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501AF555.3050004@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 11:47:01PM +0200, Sasha Levin wrote:
> On 08/02/2012 10:41 PM, Josh Triplett wrote:
> > On Thu, Aug 02, 2012 at 07:54:42PM +0200, Sasha Levin wrote:
> >> /* I've "preprocessed" the DEFINE macro below */
> >> union {
> >> 	struct hash_table table;
> >> 	struct {
> >> 		size_t bits;
> >> 		struct hlist_head buckets[32];
> >> 	}
> >> } my_hashtable;
> > 
> > That expansion doesn't match the macros.  Using the most recent
> > definitions of DEFINE_HASHTABLE and DEFINE_STATIC_HASHTABLE from above,
> > the definition would look something like this:
> > 
> > static union {
> > 	struct hash_table my_hashtable;
> > 	struct {
> > 		size_t bits;
> > 		struct hlist_head buckets[1 << 5];
> > 	} __my_hashtable;
> > } = { .my_hashtable.bits = 5 };
> 
> It's different because I don't think you can do what you did above with global variables.
> 
> You won't be defining any instances of that anonymous struct, so my_hashtable won't exist anywhere.

...how strange.  The above syntax ought to work, and many other
compilers document it as legal syntax (and I thought that C1x's
anonymous structs and unions allowed it), but indeed GCC doesn't accept
it.

Fair enough; looks like consolidating the macro implementations won't
actually work.

- Josh Triplett
