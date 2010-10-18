Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103Ab0JRSPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 14:15:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55550 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284Ab0JRSPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 14:15:22 -0400
Message-ID: <4CBC8E3C.2090203@zytor.com>
Date: Mon, 18 Oct 2010 11:13:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Eric Paris <eparis@redhat.com>, Kyle McMartin <kyle@mcmartin.ca>,
        James Morris <jmorris@namei.org>,
        Christoph Hellwig <hch@infradead.org>, kernel@lists.fedoraproject.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Serge Hallyn <serue@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: ima: use of radix tree cache indexing == massive waste of memory?
References: <20101016065206.GO4681@dastard> <20101016192027.GA6883@infradead.org> <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com> <20101017004945.GE1614@infradead.org> <20101017054008.GA16383@elte.hu> <20101017184652.GB28060@infradead.org> <alpine.LRH.2.00.1010181127480.9476@tundra.namei.org> <20101018062530.GD8332@bombadil.infradead.org> <1287420534.2530.67.camel@localhost.localdomain> <4CBC8C98.1090802@zytor.com> <20101018181136.GA12372@elte.hu>
In-Reply-To: <20101018181136.GA12372@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2010 11:11 AM, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> On 10/18/2010 09:48 AM, Eric Paris wrote:
>>
>>> 1) IMA uses radix trees which end up wasting 500 bytes per inode because the key 
>>> is too sparse.  I've got a patch which uses an rbtree instead I'm testing and 
>>> will send along shortly.  I found it funny working on the patch to see that 
>>> Documentation/rbtree.txt says "This differs from radix trees (which are used to 
>>> efficiently store sparse arrays and thus use long integer indexes to 
>>> insert/access/delete nodes)" Which flys in the face of this report.
>>
>> Radix trees can efficiently store data associated with sparse keys *as long as the 
>> keys are clustered*.  For random key distributions, they perform horribly.
> 
> For random key distributions hash and rbtree data structures are pretty good 
> choices.
> 
> But the (much) more fundamental question is to turn the non-trivial allocation 
> overhead of this opt-in feature into truly opt-in overhead.
> 

Yes, and not just the allocation overhead, but apparently locking
overhead, too.

	-hpa
