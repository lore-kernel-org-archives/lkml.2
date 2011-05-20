Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab1ETNHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:07:00 -0400
Received: from igw2.watson.ibm.com ([129.34.20.6]:58003 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1ETNG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:06:58 -0400
Subject: Re: [PATCH v5 00/21] EVM
From: David Safford <safford@watson.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1305853626.2528.50.camel@localhost.localdomain>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <20110518172552.6d482c7a.akpm@linux-foundation.org>
	 <1305769890.3304.90.camel@localhost.localdomain>
	 <alpine.LRH.2.00.1105201041000.28923@tundra.namei.org>
	 <1305853626.2528.50.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 20 May 2011 09:06:11 -0400
Message-ID: <1305896771.15245.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 21:07 -0400, Mimi Zohar wrote:
> On Fri, 2011-05-20 at 10:51 +1000, James Morris wrote:
> > On Wed, 18 May 2011, Mimi Zohar wrote:
> > 
> > > > Once we have a better understanding of what the feature does and why it
> > > > does it and how it interfaces with the user, we can start looking at
> > > > the implementation.
> > > 
> > > Much appreciated!
> > 
> > What is the status of potential users of the feature?
> > 
> > I recall that MeeGo were planning to use EVM, but they've since changed 
> > their security plans.  Do they still plan to use it?  Are any other users 
> > committing to use EVM?
> > 
> > Also -- this was raised some time back, but I can't find the discussion -- 
> > what does IMA/EVM provide over disk encryption as a protection against 
> > offline attacks?
> > 
> > - James
> 
> Dave Safford's whitepaper discusses this.
> http://downloads.sf.net/project/linux-ima/linux-ima/Integrity_overview.pdf
> 
> Mimi

The short answer is that encryption provides confidentiality, but does
not provide integrity, authenticity, or immutability. 

The easiest way to think about it is to consider a one time pad, which
provides perfect confidentiality, but is trivially bit-twiddled. Yes,
AES is better in this respect, and encrypted file systems can combine
integrity (as long as you encrypt-then-authenticate), but usually they
don't. 

If you want policy driven integrity, authenticity, and immutability,
(and we have two IBM customers wanting them this year), then you want
the combination IMA, IMA-Appraisal, EVM, and Dmitry's digital signature
extensions.

dave
