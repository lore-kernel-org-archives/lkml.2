Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011Ab2BOLDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 06:03:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54786 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab2BOLDR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 06:03:17 -0500
Message-ID: <1329303788.2293.37.camel@twins>
Subject: Re: [PATCHv4 0/9] perf tool: parser generator for events parsing
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Wed, 15 Feb 2012 12:03:08 +0100
In-Reply-To: <20120215090439.GA1664@m.brq.redhat.com>
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
	 <1327674868-10486-1-git-send-email-jolsa@redhat.com>
	 <1329236924.2293.13.camel@twins> <1329237838.2293.20.camel@twins>
	 <1329250830.2293.24.camel@twins> <1329253030.2293.27.camel@twins>
	 <20120215090439.GA1664@m.brq.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 10:04 +0100, Jiri Olsa wrote:
> On Tue, Feb 14, 2012 at 09:57:10PM +0100, Peter Zijlstra wrote:
> > On Tue, 2012-02-14 at 21:20 +0100, Peter Zijlstra wrote:
> > > OK, this one works. the attributes thing wants NULL termination.
> > > Thanks
> > > for mentioning that Jiri. 
> > 
> > OK, it mostly works, except:
> > 
> > perf record -e "cpu/config=0x108000c0/upp" ./loop_1b_locks
> > 
> > doesn't seem to work...
> > 
> > One thing that might be nice is not having to do =1 for single bit
> > fields, so that we can write: inv,edge instead of inv=1,edge=1.
> 
> ok, would you think there's any use for following behaviour:
> whenever field is written without the assignment, all the field defined
> bits are set.. regardless if it's sengle ot multiple bit field..
> 
> looks like this would ease the implementation a little,
> not mentioning the above behaviour could be usefull ;)

I'm not sure that behaviour would be useful for anything other than
this, but sure -- or set the value to 1 when not set, either works.
