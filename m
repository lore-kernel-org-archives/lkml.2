Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850Ab1C3Qxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:53:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932707Ab1C3Qxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:53:48 -0400
Date: Wed, 30 Mar 2011 12:53:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com
Subject: Re: [PATCH] blk-throttle: don't call xchg on bool
Message-ID: <20110330165342.GF1291@redhat.com>
References: <1292447255-10698-1-git-send-email-vgoyal@redhat.com>
 <1292447255-10698-3-git-send-email-vgoyal@redhat.com>
 <m21v1ph639.fsf_-_@igel.home>
 <20110330131936.GA1291@redhat.com>
 <m3vcz0ra1l.fsf@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3vcz0ra1l.fsf@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 03:51:34PM +0200, Andreas Schwab wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > Which arch creates the problem and what's the issue here if data type
> > is smaller than 32bit?
> 
> Just look at the various implementations in arch/*/include/asm/system.h:
> 
> - arm: supports only one and 4 byte xchg
> - avr32: supports only 4 byte xchg
> - frv: supports only 4 byte xchg
> - m32r: SMP supports only 4 byte xchg
> - microblaze: supports only one and 4 byte xchg
> 
> etc.
> 
> > Is it a compile time warning?
> 
> Most implementations turn the use of xchg with a bad pointer into a link
> error.

Thanks Andreas. I get it. I did check arm and it is supporting only one
and 4 byte xchg.

Vivek
