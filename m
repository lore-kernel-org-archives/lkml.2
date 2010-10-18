Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab0JRL6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 07:58:10 -0400
Received: from canuck.infradead.org ([134.117.69.58]:57795 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab0JRL6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 07:58:08 -0400
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org, hpa@zytor.com,
        devel@lists.fedoraprojet.org
In-Reply-To: <1287324983.2530.35.camel@localhost.localdomain>
References: <20101016065206.GO4681@dastard>
	 <20101016192027.GA6883@infradead.org>
	 <1287295077.3020.83.camel@localhost.localdomain>
	 <1287313332.1998.172.camel@laptop>
	 <AANLkTinNbF9=5Ojn8kKEvSkGbpqQw+DGKyRWhAD1AYZK@mail.gmail.com>
	 <1287323960.1998.360.camel@laptop>
	 <1287324983.2530.35.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Oct 2010 13:57:28 +0200
Message-ID: <1287403048.29097.1553.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-17 at 10:16 -0400, Eric Paris wrote:
> If instead you attack the problem from the other side and start with all
> of the files we'd need some kind of freezer to so we could get the
> atomicity required.  We'd have to review every single file on the system
> before we could be certain that the inode was correct.  Maybe I'm wrong
> and someone else can help me see how to solve it this way.... 

Well, you could use the actual freezer to freeze luserspace and then
simply iterate all open files, I mean, those few sods who actually want
this enabled can either pass a boot option to enable from boot or suffer
the overhead on enable, right?


