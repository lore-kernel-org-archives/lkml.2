Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab2BHHJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 02:09:34 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43471 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab2BHHJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 02:09:31 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <20120207182926.GD1043@quack.suse.cz>
References: <1328536531-19034-1-git-send-email-jack@suse.cz>
	<4F2FF4EC.1000104@linux.vnet.ibm.com>
	<20120206164732.GH6890@quack.suse.cz>
	<20120206131717.c4346f72.akpm@linux-foundation.org>
	<20120206222517.GD24840@quack.suse.cz>
	<CAOtvUMcWOfkn401qEUgBMV=R-vCbWG3sus6=yV9kQjRhheXV4A@mail.gmail.com>
	<20120207182926.GD1043@quack.suse.cz>
Date: Wed, 8 Feb 2012 09:09:30 +0200
Message-ID: <CAOtvUMet_L9s5+jYF=_kb_N86dNmC6G1rhLQ7JzNfWC0J9UcSw@mail.gmail.com>
Subject: Re: [PATCH] vfs: Avoid IPI storm due to bh LRU invalidation
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        hare@suse.de, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 7, 2012 at 8:29 PM, Jan Kara <jack@suse.cz> wrote:
> On Tue 07-02-12 18:25:18, Gilad Ben-Yossef wrote:
>> On Tue, Feb 7, 2012 at 12:25 AM, Jan Kara <jack@suse.cz> wrote:
...
>> I think its worth a shot since the mutex just delays the IPIs instead
>> of canceling them
>> altogether.
>  Well, mutex will just delay callers but the sequence logic behind the
> mutex will reduce number of IPIs a lot - all waiters for mutex will be
> satisfied by a single signalling of all CPUs while previously they would
> each do the signalling.

Oh, you are right. I've missed that part completely. Note to self: never try to
read LKML email on your smartphone...

Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
