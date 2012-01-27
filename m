Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab2A0Hi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 02:38:27 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:32930 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754332Ab2A0Hi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 02:38:26 -0500
Message-ID: <1327649890.12089.20.camel@joe2Laptop>
Subject: Re: [PATCH next V2] drivers: Use NULL not zero pointer assignments
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Jiri Kosina <trivial@kernel.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 26 Jan 2012 23:38:10 -0800
In-Reply-To: <4F22421A.5020501@gmail.com>
References: <20120126061330.GA15856@elgon.mountain>
	 <1327559803.28707.6.camel@joe2Laptop> <1327642391.4846.36.camel@joe2Laptop>
	 <4F22421A.5020501@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 17:20 +1100, Ryan Mallon wrote:
> On 27/01/12 16:33, Joe Perches wrote:
> > Using NULL pointer assignments is more kernel-style standard.
> > Uncompiled, untested.
> > Done via cocinelle script:
> > @@
> > type T;
> > T *pointer;
> > @@
> > -pointer = 0
> > +pointer = NULL
> Hi Joe,

Hi Ryan.

> I think you can drop a lot of the initialisations completely rather than
> convert them. I've pointed some out below. I'm just scanning through for
> likely candidates and I didn't bother looking at the staging drivers, so
> this list is not comprehensive.

I'll try a more generic solution.
Here's a possible cocci script that looks for declarations with
initializations that are later overwritten.
$ cat multi_set.cocci
@@
type T;
identifier x;
expression y;
expression z;
@@
-T x = y;
+T x;
...
x = z
$

This script has a defect because expression z may
use identifier x.

Anyway, if the script can be tweaked appropriately,
it might be useful to remove these unnecessary
initializations.

cheers, Joe

