Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab2L0Slp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 13:41:45 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:49233 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab2L0Sln convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Thu, 27 Dec 2012 13:41:43 -0500
Message-Id: <50DC9662020000780009210D@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 27 Dec 2012 18:41:38 +0000
From: "Jan Beulich" <jbeulich@suse.com>
To: <eric.dumazet@gmail.com>, <riel@redhat.com>
Cc: <rostedt@goodmis.org>, <therbert@google.com>, <walken@google.com>,
        <jeremy@goop.org>, <tglx@linutronix.de>, <aquini@redhat.com>,
        <lwoodman@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff
 delay factor
References: <20121221184940.103c31ad@annuminas.surriel.com>
 <20121221185147.4ae48ab5@annuminas.surriel.com>
 <20121221185613.1f4c9523@annuminas.surriel.com>
 <20121222033339.GF27621@home.goodmis.org> <50D52E0C.6000103@redhat.com>
 <1356549008.20133.20856.camel@edumazet-glaptop>
 <50DB5531.90500@redhat.com>
 <CANN689HeTk0jNJb4sF_0t714MvFnU0vLw0=JeXYRUwMx8GDnXQ@mail.gmail.com>
 <1356618448.30414.948.camel@edumazet-glaptop>
 <50DC5CC0.6010003@redhat.com>
In-Reply-To: <50DC5CC0.6010003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Rik van Riel <riel@redhat.com> 12/27/12 4:01 PM >>>
>On 12/27/2012 09:27 AM, Eric Dumazet wrote:
>> So the hash sounds good to me, because the hash key could mix both lock
>> address and caller IP ( __builtin_return_address(1) in
>> ticket_spin_lock_wait())
>
>The lock acquisition time depends on the holder of the lock,
>and what the CPUs ahead of us in line will do with the lock,
>not on the caller IP of the spinner.

The lock holder could supply its __builtin_return_address(0) for use
in eventual hashing.

Also, with all of this - did you evaluate the alternative of using
monitor/mwait instead?

Jan

