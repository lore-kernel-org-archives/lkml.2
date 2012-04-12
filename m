Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934472Ab2DLPmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 11:42:08 -0400
Received: from oyp.chewa.net ([91.121.6.101]:33563 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120Ab2DLPmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 11:42:06 -0400
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC] [PATCH] v4l2: use unsigned rather than enums in ioctl() structs
X-PHP-Originating-Script: 0:func.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 12 Apr 2012 17:41:53 +0200
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Cc: James Courtier-Dutton <james.dutton@gmail.com>, <mchehab@infradead.org>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <4F86ECD0.6060708@redhat.com>
References: <1333648371-24812-1-git-send-email-remi@remlab.net> <4F85B908.4070404@redhat.com> <201204112147.55348.remi@remlab.net> <CAAMvbhHviuwC0ik2ZY91ZgN4hZyqUbuk=qVcAOH0VYMhva4LeA@mail.gmail.com> <4F86ECD0.6060708@redhat.com>
Message-ID: <0c4d0f509a99540d87224c05fd27d322@chewa.net>
User-Agent: RoundCube Webmail/0.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012 11:55:12 -0300, Mauro Carvalho Chehab

<mchehab@redhat.com> wrote:

> I can see only two viable fixes for it:

> 

> 1) add a typedef for the enum, using the sizeof(enum) in order to select

> the

> size of the used integer.

> 

> Pros:

> 	- Patch is easy to write/easy to review;

> 	- Won't change the struct size, so applications compiled without

> 	  strong gcc optimization won't break;

> Cons:

> 	- It will add a typedef, with is ugly;

> 	- struct size on 32 bits will be different thant he size on 64 bits

> 	  (not really an issue, as v4l2-compat32 will handle that;



On which platforms do enums occupy 64-bits? Alpha? More to the point, on

which platform is enum not the same size as unsigned?



At least on x86-64, enum is 32-bits and so is unsigned.



> 	- v4l2-compat32 code may require changes.

> 

> 2) just replace it by a 32 bits integer.

> 

> Pros:

> 	- no typedefs;

> 	- struct size won't change between 32/64 bits (except when they also

> 	  have pointers);

> Cons:

> 	- will break ABI. So, a compat code is required;

> 	- will require a "videodev2.h" fork for the legacy API with the enum's;

> 	- will require a compat code to convert from enum into integer and

> 	  vice-versa.

> 

> Comments/Votes?



-- 

Rémi Denis-Courmont

Sent from my collocated server
