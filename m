Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab0DIJXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 05:23:22 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:38896 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab0DIJXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 05:23:17 -0400
Message-ID: <4BBEF1FC.6060307@lumino.de>
Date: Fri, 09 Apr 2010 11:23:08 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-2.3 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: linux-kernel@vger.kernel.org, nios2-dev <nios2-dev@sopc.et.ntust.edu.tw>
Subject: Re: atomic RAM ?
References: <4BBD86A5.5030109@lumino.de> <v2u8bd0f97a1004081836na92954bdu4ed473816dc831b9@mail.gmail.com>
In-Reply-To: <v2u8bd0f97a1004081836na92954bdu4ed473816dc831b9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2010 03:36 AM, Mike Frysinger wrote:
> i think you underestimate the task of customizing every userspace
> point that may want atomic instructions.  
I never said this would be easy ;) Maybe it's close to impossible :(

I had hoped modifying the "atomic" macros for the arch in question in a
way that they use a handle instead of a pointer to the "atomic" variable
in a compatible way and then modifying the code that uses these macros
in a way that theses handles are created by additional macros that with
other archs can be uses optionally (in a compatible way: returning the
appropriate pointer) could work. But of course you are correct that a
lot of code would need being inspected.
> and no matter what sized
> atomic region you pick, having it arbitrarily fail at runtime because
> applications have "too many" locks is a poor solution.
>   
Of course you are right, but not being able to allow for SMP is a poor
solution, too.

I suppose it's possible to generate a dedicated system error when an
application runs out of "pthread_mutex" locks (i.e. when the
atomic_malloc() function detects that the atomic RAM is exhausted). You
also can unexpectedly get a normal "out of memory" system in an
application error at any point (e.g. when opening a file) ;) I don't
suppose any "normal" embedded application will use more than some 100.
(In any case, it would be good to have a (of course no-SMP-)
distribution that uses the "atomic region" software workaround, as well,
in case the user does not want to implement the necessary custom
instructions. This would be usable for applications excessively
consuming of "atomic RAM", too.)

-Michael
