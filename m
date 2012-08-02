Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab2HBRCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 13:02:23 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44857 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754430Ab2HBRCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 13:02:21 -0400
Message-ID: <1343926940.2011.18.camel@joe2Laptop>
Subject: Re: [PATCH v2] dynamic_debug: Restore dev_dbg functionality,
 optimize stack
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Baron <jbaron@redhat.com>, Jim Cromie <jim.cromie@gmail.com>,
        Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Thu, 02 Aug 2012 10:02:20 -0700
In-Reply-To: <20120731145534.5606e840.akpm@linux-foundation.org>
References: <1343334310.17538.32.camel@joe2Laptop>
	 <333324dcdfdc891ba214d2de8f9a3d056dd7aea9.1343461712.git.joe@perches.com>
	 <20120731145534.5606e840.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-31 at 14:55 -0700, Andrew Morton wrote:
> On Sat, 28 Jul 2012 00:55:07 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > commit c4e00daaa9 ("driver-core: extend dev_printk() to pass structured data")
> > changed __dev_printk and broke dynamic-debug's ability to control the
> > dynamic prefix of dev_dbg(dev,..).
> > 
> > dynamic_emit_prefix() adds "[tid] module:func:line:" to the output and
> > those additions got lost.
> > 
> > In addition, the current dynamic debug code uses up to 3 recursion
> > levels via %pV.  This can consume quite a bit of stack.  Directly
> > call printk_emit to reduce the recursion depth.
[]
> > Changes in v2:
> > 
> > o Fix dynamic_emit_prefix to always initialize output
> > o Call create_syslog_header and emit_printk from__netdev_printk and
> >   eliminate call to dev_printk to remove another recursion via %pV
> 
> This one causes an oops-on-boot
> (http://ozlabs.org/~akpm/stuff/IMG_20120731_144047.jpg).  v1 didn't do
> that.
> 
> config: http://ozlabs.org/~akpm/stuff/config-akpm2
> 

Thanks.  I'll fix it when I can.
Expect a week or so delay though.

I'm a bit busy on other projects and this one seems to
require additional testing.

cheers, Joe

