Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab0CSHYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 03:24:06 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54746 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab0CSHYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 03:24:02 -0400
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot
 parameter
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, balbir@linux.vnet.ibm.com,
       KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4B9F49F1.70202@redhat.com>
References: <20100315072214.GA18054@balbir.in.ibm.com>
	 <4B9DE635.8030208@redhat.com> <20100315080726.GB18054@balbir.in.ibm.com>
	 <4B9DEF81.6020802@redhat.com> <20100315091720.GC18054@balbir.in.ibm.com>
	 <4B9DFD9C.8030608@redhat.com> <4B9E810E.9010706@codemonkey.ws>
	 <4B9F49F1.70202@redhat.com>
Content-Type: text/plain
Date: Fri, 19 Mar 2010 00:23:52 -0700
Message-Id: <1268983432.10438.5685.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 11:05 +0200, Avi Kivity wrote:
> > Not really.  In many cloud environments, there's a set of common 
> > images that are instantiated on each node.  Usually this is because 
> > you're running a horizontally scalable application or because you're 
> > supporting an ephemeral storage model.
> 
> But will these servers actually benefit from shared cache?  So the 
> images are shared, they boot up, what then?
> 
> - apache really won't like serving static files from the host pagecache
> - dynamic content (java, cgi) will be mostly in anonymous memory, not 
> pagecache
> - ditto for application servers
> - what else are people doing?

Think of an OpenVZ-style model where you're renting out a bunch of
relatively tiny VMs and they're getting used pretty sporadically.  They
either have relatively little memory, or they've been ballooned down to
a pretty small footprint.

The more you shrink them down, the more similar they become.  You'll end
up having things like init, cron, apache, bash and libc start to
dominate the memory footprint in the VM.

That's *certainly* a case where this makes a lot of sense.

-- Dave

