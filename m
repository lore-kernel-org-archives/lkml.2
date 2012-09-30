Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab2I3HHK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 03:07:10 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:26973 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab2I3HHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 03:07:07 -0400
Date: Sun, 30 Sep 2012 10:06:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: anish kumar <anish198519851985@gmail.com>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] power: battery: pointer math issue in gab_probe()
Message-ID: <20120930070646.GO4587@mwanda>
References: <20120929071346.GE10993@elgon.mountain>
 <1348978125.7492.2.camel@anish-Inspiron-N5050>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348978125.7492.2.camel@anish-Inspiron-N5050>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2012 at 09:38:45AM +0530, anish kumar wrote:
> On Sat, 2012-09-29 at 10:13 +0300, Dan Carpenter wrote:
> > psy->properties is an enum (32 bit type) so adding sizeof() puts us
> > four times further along than we intended.  It should be cast to a char
> > pointer before doing the math.
> You really read this driver to find out this one.
> Good one.

Nah.  It's a static checker thing with Smatch
(http://smatch.sf.net).  When you add pointer + sizeof(), the
pointer should always be char.

regards,
dan carpenter

