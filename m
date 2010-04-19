Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab0DSTGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 15:06:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44996 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab0DSTGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 15:06:17 -0400
X-Authority-Analysis: v=1.1 cv=4zru/oO1PQpEm2SyzJWQB8cs3WBzsLhxb1x/U/RGpxE= c=1 sm=0 a=DGtQXZEwYRAA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=yPCof4ZbAAAA:8 a=svihKzc3PlRBAlQoR_wA:9 a=kXDCmN3IzMh-127vrT0hjDRJVWEA:4 a=PUjeQqilurYA:10 a=7DSvI1NPTFQA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: trace-cmd: make Makefile rpm-friendly
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: John Kacur <jkacur@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1004191942010.4111@localhost.localdomain>
References: <20100419100058.6f1457dd.randy.dunlap@oracle.com>
	 <alpine.LFD.2.00.1004191942010.4111@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 19 Apr 2010 15:06:12 -0400
Message-ID: <1271703972.10448.5.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 20:11 +0200, John Kacur wrote:
> 
> On Mon, 19 Apr 2010, Randy Dunlap wrote:
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Update Makefile to support rpmbuild DESTDIR usage.
> 
> So, what would happen if you did
> make DESTDIR=/usr/local install ?
> 
> I think you would get /usr/local/usr/local
> So, I think I would NAK this patch.
> 
> I also don't believe there is anything magical about DESTDIR in a spec 
> file. Essentially, prefix in this makefile is equivalent to DESTDIR, so 
> you can replace DESTDIR with prefix in a spec template.
>  

NAK is too strong. I was looking at what perf does, and it basically
makes prefix and DESTDIR the same.

ifndef DESTDIR
prefix = $(HOME)
endif

We could do..

ifndef DESDIR
prefix = /usr/local/bin
endif

and then, if DESTDIR is not set, it would do the right thing.

-- Steve


