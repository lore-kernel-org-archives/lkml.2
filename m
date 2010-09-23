Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab0IWGXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:23:14 -0400
Received: from dion.org.ua ([193.104.35.153]:45525 "EHLO dion.org.ua"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750731Ab0IWGXN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:23:13 -0400
Date: Thu, 23 Sep 2010 06:32:59 +0000
From: Dmitry Nezhevenko <dion@inhex.net>
To: Ryan Castellucci <ryan.castellucci@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: dm-crypt and huge performance penalty
Message-ID: <20100923063259.GA18250@dion.org.ua>
References: <20100920223700.GA20507@laptop.local> <AANLkTimFyorLPWv4px8_7KQRu_L8Ezftdb=0mXAOm76K@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTimFyorLPWv4px8_7KQRu_L8Ezftdb=0mXAOm76K@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 04:52:17PM -0700, Ryan Castellucci wrote:
> On Mon, Sep 20, 2010 at 3:37 PM, Dmitry Nezhevenko <dion@inhex.net> wrote:
> > Firstly I've tried to setup raid5 and then dm-crypt on top of it. After
> > discovering issue I've tried just raid5 and confirmed that mdadm itself
> > works as expected.
> >
> > And the last idea is to setup three dm-crypt partitions and then raid5 on
> > top of independently encrypted drives.
> >
> > So here are my results:
> >
> > š š š š š | šmdadm š | mdadm+dm-crypt | 3 x dm-crypt + mdadm |
> > Seq. read š| 168 Mb/s | 57 Mb/s š š š š| 119 Mb/s š š š š š š |
> > Seq. write | 80 Mb/s š| 36 Mb/s š š š š| 64.4 Mb/s š š š š š š|
> 
> dm-crypt will only use one core per device, so this is expected
> behavior (and I believe an issue that is being worked on). From these
> numbers it looks like you have a dual core or dual cpu system?
> 

Hi, Yes, The machine is home NAS with inexpensive Intel Core i3 CPU that
has two real cores and HT.
 
-- 
WBR, Dmitry
