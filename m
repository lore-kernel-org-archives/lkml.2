Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab1G1LI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 07:08:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab1G1LIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 07:08:55 -0400
From: Andreas Schwab <schwab@redhat.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        linux-kernel@vger.kernel.org
Subject: Re: [Q] compiler no longer warning about undeclared struct?
References: <Pine.LNX.4.64.1107271947490.7435@axis700.grange>
	<1311847409.3897.23.camel@thorin>
	<Pine.LNX.4.64.1107281211120.20737@axis700.grange>
X-Yow: It's a lot of fun being alive...  I wonder if my bed is made?!?
Date: Thu, 28 Jul 2011 13:08:53 +0200
In-Reply-To: <Pine.LNX.4.64.1107281211120.20737@axis700.grange> (Guennadi
	Liakhovetski's message of "Thu, 28 Jul 2011 12:16:04 +0200 (CEST)")
Message-ID: <m3ipqmek6y.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> I always thought you need forward declarations for those, as in
>
> struct yy;
>
> before declaring struct xx above.

You only need that if you would otherwise introduce the struct tag in a
different scope, like prototype scope (which ends at the end of the
prototype).

>> Otherwise you could not define recursive structures as in
>> ----  snip  ----
>> struct a {
>> 	struct *b;
>> };
>> struct b {
>> 	struct *a;
>> };
>> ----  snip  ----
>
> I would add a "struct b;" forward declaration before "struct a".

You can do that, but since a struct definition doesn't introduce a new
scope it is not necessary.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
