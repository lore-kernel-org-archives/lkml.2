Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760941Ab2DLRWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 13:22:55 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:63905 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751419Ab2DLRWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 13:22:54 -0400
Date: Thu, 12 Apr 2012 13:22:45 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: =?iso-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, mchehab@infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC] [PATCH] v4l2: use unsigned rather than enums in ioctl()
 structs
Message-ID: <20120412172245.GA1721@elliptictech.com>
References: <1333648371-24812-1-git-send-email-remi@remlab.net>
 <201204112147.55348.remi@remlab.net>
 <4F85E133.4030404@redhat.com>
 <201204112332.24353.remi@remlab.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201204112332.24353.remi@remlab.net>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-11 23:32 +0300, Rémi Denis-Courmont wrote:
> From the perspective of the compiler, this is a feature not a bug. In
> C and C++, loading or storing a value in an enumerated variable
> whereby the value is not a member of the enumeration is undefined.

I'm afraid that this is not the case in C, although it may be in C++
(enums are very different in C++ than they are in C).  In C, enum types
are required to be compatible with some integer type capable of storing
the values of all the enum members (see C11§6.7.2.2#4).  Compatibility
is a very strong condition, and implies that the two types are
interchangable without affecting the meaning of the program (see
C11§6.2.7).  Integer types have a number of specific requirements, one
thing that's relevant here is that they do not have "holes" in their
representable values: there is a minimum and maximum representable
value, and all integers between them are representable (C11§6.2.6.2#1).

Thus, while the choice of integer type used may depend on the values of
the corresponding enum constants, storing any value (regardless of
whether or not its a member of the enumeration) is subject to the same
rules as the implementation-defined compatbile integer type.  This is
always well-defined for values within the range of the type.
(C11§6.3.1.3#1 and C11§6.3.1.4#1).

> In other words, the compiler can assume that this does not happen, and
> optimize it away.

No, a conforming C compiler cannot assume such assignments do not
happen, for the reasons outlined above.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

