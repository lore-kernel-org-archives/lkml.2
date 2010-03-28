Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab0C1T7d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 15:59:33 -0400
Received: from mail.perches.com ([173.55.12.10]:1176 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118Ab0C1T7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 15:59:32 -0400
Subject: Re: Checkpatch.pl false positive? "ERROR: return is not a
 function, parentheses are not required"
From: Joe Perches <joe@perches.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>, apw@canonical.com,
       akpm@linux-foundation.org, dwalker@fifo99.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100328200922.GB27351@core2>
References: <1269804493.7079.14.camel@tuxtm-linux>
	 <20100328200922.GB27351@core2>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Mar 2010 12:59:30 -0700
Message-ID: <1269806370.1500.55.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-28 at 23:09 +0300, Alexey Dobriyan wrote:
> On Sun, Mar 28, 2010 at 10:28:13PM +0300, Olimpiu Pascariu wrote:
> >   return (dt3155_fbuffer[m]->ready_head -
> >            dt3155_fbuffer[m]->ready_len +
> >            dt3155_fbuffer[m]->nbuffers)%
> >           (dt3155_fbuffer[m]->nbuffers);
> > IMHO the code is correct, though an auxiliary variable could be used to
> > avoid this error returned by checkpatch.pl. 
> Yes, checkpatch.pl doesn't understand C.

And as currently implemented, can not.

I think this passes checkpatch without warning:

	return (dt3155_fbuffer[m]->ready_head -
		dt3155_fbuffer[m]->ready_len +
		dt3155_fbuffer[m]->nbuffers) %
	       dt3155_fbuffer[m]->nbuffers;

It might be better to use a temporary for dt3155_fbuffer[m]
so the code could look more like:
	return (p->ready_head - p->ready_len + p->nbuffers) % p->nbuffers;
	

