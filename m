Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab2DTC7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 22:59:21 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59032 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab2DTC7T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 22:59:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120420025438.GD6871@ZenIV.linux.org.uk>
References: <1334754302.2137.8.camel@falcor> <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org>
 <1334772473.2137.22.camel@falcor> <20120418183938.GH6589@ZenIV.linux.org.uk>
 <1334865448.2429.35.camel@falcor> <20120420004303.GB6871@ZenIV.linux.org.uk>
 <CA+55aFxQR8g3TycW7nOVjjnnsaWWW-Gh74-bV6rUm+7SRTm25g@mail.gmail.com> <20120420025438.GD6871@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Apr 2012 19:58:57 -0700
X-Google-Sender-Auth: PIkrCWgG7UASxy9z-4CIy9UiCes
Message-ID: <CA+55aFzinX_6DVvDTyxrsP6VEHVY2Q+Y=e+qksnAjR+oT3GZew@mail.gmail.com>
Subject: Re: [RFC] situation with fput() locking (was Re: [PULL REQUEST] :
 ima-appraisal patches)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 7:54 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Umm...  I really wonder if we *want* filp_close() under any kind of
> locks.  You are right - it should not be deferred.  I haven't finished
> checking the callers of that puppy, but if we really do it while holding
> any kind of lock, we are asking for trouble.  So I'd rather switch
> filp_close() to use of fput_nodefer() if that turns out to be possible.

Ok, fair enough, looks like a reasonable plan to me.

                  Linus
