Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab2DNVBp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 17:01:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41777 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab2DNVBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 17:01:44 -0400
Message-ID: <1334437288.2528.111.camel@twins>
Subject: Re: [RFC 3/3] kernel.h: use new typechecking macros in min()/max()
 and friends
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@elte.hu,
        hpa@zytor.com, tglx@linutronix.de, srivatsa.bhat@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Date: Sat, 14 Apr 2012 23:01:28 +0200
In-Reply-To: <1334441685-4438-4-git-send-email-levinsasha928@gmail.com>
References: <1334441685-4438-1-git-send-email-levinsasha928@gmail.com>
	 <1334441685-4438-4-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-14 at 18:14 -0400, Sasha Levin wrote:
>  #define min(x, y) ({                           \
> -       typeof(x) _min1 = (x);                  \
> -       typeof(y) _min2 = (y);                  \
> -       (void) (&_min1 == &_min2);              \
> -       _min1 < _min2 ? _min1 : _min2; })
> +       typecmp2((x), (y));                             \
> +       (x) < (y) ? (x) : (y); }) 

Problem with this is that it evaluates x and y multiple times.
