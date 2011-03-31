Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab1CaJR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 05:17:27 -0400
Received: from ist.d-labs.de ([213.239.218.44]:52517 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083Ab1CaJR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 05:17:26 -0400
Date: Thu, 31 Mar 2011 11:16:59 +0200
From: Florian Mickler <florian@mickler.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Manjunatha Halli <manjunatha_halli@ti.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [BUG] NULL pointer dereference in dev_get_drvdata
Message-ID: <20110331111659.0c77abbe@schatten.dmk.lab>
In-Reply-To: <4D93508D.30701@gmail.com>
References: <1301448497.14261.319.camel@gandalf.stny.rr.com>
	<4D93508D.30701@gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011 08:47:25 -0700
"Justin P. Mattock" <justinmattock@gmail.com> wrote:


> 
> strange thing with this, is one instance my screen went black, then 
> something similar showed up on screen but then the screen kind of went 
> back to normal(was able to move the mouse, but most of everything was 
> frozen), another instance was shutting down the system pics are here:
> 
> http://www.flickr.com/photos/44066293@N08/5573957179/
> http://www.flickr.com/photos/44066293@N08/5574543648/
> (not the best camara used)
> 
> this does not fire off all the time, but it does.
> (I will keep my eye out with this one).
> 
> Justin P. Mattock
> 

even with that resolution (240x320, that's a joke, right? do I need to
login or something like that?) I see that your stacktrace is
different. 

The stacktrace is the cascade of function-calls that lead to the
execution of the current code. A null-pointer in the driver-core
normally means that someone on the calling site did something wrong. 
So in order to fix the bug, you have to look at the stack trace and
check how that null pointer got handed down to that function. 

If you have 2 drivers. Both seperately calling the same function with a
nullpointer you have 2 seperate issues that trigger the same thing
(null pointer exception) in the same function. so it is not sufficient
to look at where the bug happened, you also need to check what is the
cause. 

Regards,
Flo
