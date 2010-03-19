Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab0CSRx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 13:53:28 -0400
Received: from mail-px0-f198.google.com ([209.85.216.198]:46469 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab0CSRx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 13:53:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=IF+xeqpLdisxoTGSHWdibACegMGHk8OM0Jfhb5AXsyKbGCmdSA1QbU602Aet2zYjOG
         5RYCjbTaTojubtoizh/fE17gaEGzmfEKMIJpLB4YYmUFqFrJ9sydYtBdF6o8KU7jgy+s
         O1iqc2dRYu0tcc8UUjc3G/c0eWrKXjNlQbYME=
Subject: Re: [PATCH] Document Linux's circular buffering capabilities
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Mark Rustad <mrustad@gmail.com>
In-Reply-To: <4B9E396E.8050606@s5r6.in-berlin.de>
Date: Fri, 19 Mar 2010 12:53:23 -0500
Cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org,
       akpm@linux-foundation.org, sgruszka@redhat.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <B65E0AB8-31F4-45B2-B519-3BE9566578A5@gmail.com>
References: <4B9B5A37.2010206@s5r6.in-berlin.de> <4B9A6033.8010705@s5r6.in-berlin.de> <20100311172055.7328.51353.stgit@warthog.procyon.org.uk> <18180.1268437268@redhat.com> <30121.1268656565@redhat.com> <4B9E396E.8050606@s5r6.in-berlin.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 15, 2010, at 8:43 AM, Stefan Richter wrote:

> David Howells wrote:
>> How about adding a bit:
>> 
>> Note the use of ACCESS_ONCE() in both algorithms to read the opposition index.
>> This prevents the compiler from discarding and reloading its cached value -
>> -which some compilers will do across smp_read_barrier_depends().
>> +which some compilers will do across smp_read_barrier_depends().  This isn't
>> +strictly needed if you can be sure that the opposition index will _only_ be
>> +used the once.
> 
> Yes, thanks.  (The last "the" is superfluous.)

Maybe it would be clearer to change "the once" to "the one time" or "that one time". "the once" reads too much like an error which may lead to it being "corrected" some day, most likely then losing the intended meaning.

-- 
Mark Rustad, MRustad@gmail.com

