Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab0IWS1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 14:27:37 -0400
Received: from mail.perches.com ([173.55.12.10]:2290 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab0IWS1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 14:27:36 -0400
Subject: Re: checkpatch problem
From: Joe Perches <joe@perches.com>
To: David Howells <dhowells@redhat.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
In-Reply-To: <22516.1285265739@redhat.com>
References: <4013.1285177436@redhat.com> <25759.1285169592@redhat.com>
	 <1283888517.23280.241.camel@Joe-Laptop> <23323.1283864982@redhat.com>
	 <20100907180025.GD2662@shadowen.org>  <22516.1285265739@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 11:27:34 -0700
Message-ID: <1285266454.31572.29.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-23 at 19:15 +0100, David Howells wrote:
> The problem is that the second matcher (looking for " to \\n) matches on more
> than just the logfunction line.  Instrumenting the code supplied by your patch
> thusly:
[]
> I suspect checkpatch doesn't handle #defines correctly, and goes beyond their
> end looking for a semicolon.

Hi David.

Exactly right.  Andy has a version in his testing directory
that fixes this #define run-on block and speeds up checkpatch
runtime rather a lot for certain files like .h files that have
nothing but #defines.

Try applying my patch to this newer version:

http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

