Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab1G1KnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 06:43:25 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:5844 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248Ab1G1KnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 06:43:24 -0400
X-Greylist: delayed 2392 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jul 2011 06:43:24 EDT
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host p6SA3ROE015931
Subject: Re: [Q] compiler no longer warning about undeclared struct?
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 28 Jul 2011 12:03:27 +0200
In-Reply-To: <Pine.LNX.4.64.1107271947490.7435@axis700.grange>
References: <Pine.LNX.4.64.1107271947490.7435@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1311847409.3897.23.camel@thorin>
Mime-Version: 1.0
X-DCC-dcc1-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mit, 2011-07-27 at 19:57 +0200, Guennadi Liakhovetski wrote:
[....]
> I just ran across a driver in the kernel (drivers/media/video/ov2640.c, 
> struct ov2640_priv::info), that does something like
> 
> struct xx {
> 	struct yy *y;
> };
> 
> static void z(void)
> {
> 	struct xx *x;
> 	void *p;
> 
> 	x = ...;
> 	p = ...;
> 	x->y = p;
> }
> 
> where "struct yy" is nowhere declared, and the compiler happily swallows 
> this... Shouldn't it complain? Didn't it complain before?

It's normal C behaviour: As long as the compiler doesn't need the size
or fields of struct yy, it doesn't complain that it doesn't know the
details.

Otherwise you could not define recursive structures as in
----  snip  ----
struct a {
	struct *b;
};
struct b {
	struct *a;
};
----  snip  ----

Kind regards,
	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

