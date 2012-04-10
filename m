Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab2DJJWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 05:22:34 -0400
Received: from smtp3.su.se ([130.237.164.77]:38442 "EHLO smtp.su.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751747Ab2DJJWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 05:22:33 -0400
X-Spam-Flag: NO
X-Spam-Score: -4
Message-ID: <4F83FBD6.6030104@debian.org>
Date: Tue, 10 Apr 2012 11:22:30 +0200
From: Per Olofsson <pelle@debian.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Bojan Smojver <bojan@rexursive.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9]: Hibernation: fix the number of pages used for hibernate/thaw
 buffering
References: <1334026047.2103.23.camel@shrek.rexursive.com>  <4F83F202.2080600@debian.org> <1334049554.2178.1.camel@shrek.rexursive.com>
In-Reply-To: <1334049554.2178.1.camel@shrek.rexursive.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-10 11:19, Bojan Smojver wrote:
> On Tue, 2012-04-10 at 10:40 +0200, Per Olofsson wrote:
>> Nitpick: it should be faster to calculate "nr_free_pages() -
>> nr_free_highpages()", at least on systems without high pages. But
>> perhaps it does not matter. 
> 
> Actually, nr_free_highpages() does a loop very similar to the one in the
> patch. So, you would then have that and nr_free_pages() invocation.
> That's why I went with just the loop.
> 
> Make sense?
> 

If you don't have any high pages (e.g. x86_64), then nr_free_highpages()
is defined to be 0 and is optimized away completely.

Still, it seems you are not calculating free pages that often anymore so
it should not matter much.

-- 
Pelle
