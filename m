Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab0GURjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:39:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52521 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab0GURjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:39:21 -0400
MIME-Version: 1.0
Message-ID: <6433bf44-2a68-485a-b048-a7aca241677d@default>
Date: Wed, 21 Jul 2010 10:37:20 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: ngupta@vflare.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/8] zcache: page cache compression support
References: <1279283870-18549-1-git-send-email-ngupta@vflare.org>
 <4f986c65-c17e-47d8-9c30-60cd17809cbb@default> <4C45A9BA.1090903@vflare.org>
 <9e4cae1f-c102-43ea-9ba0-611c8ad68c9b@default 4C46772E.3000500@vflare.org>
In-Reply-To: <4C46772E.3000500@vflare.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.2.1.2  (406224) [OL
 12.0.6535.5005]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C473067.0218:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Maybe the best solution is to make the threshold a sysfs
> > settable?  Or maybe BOTH the single-page threshold and
> > the average threshold as two different sysfs settables?
> > E.g. throw away a put page if either it compresses poorly
> > or adding it to the pool would push the average over.
> 
> Considering overall compression average instead of bothering about
> individual page compressibility seems like a good point. Still, I think
> storing completely incompressible pages isn't desirable.
> 
> So, I agree with the idea of separate sysfs tunables for average and
> single-page
> compression thresholds with defaults conservatively set to 50% and
> PAGE_SIZE/2
> respectively. I will include these in "v2" patches.

Unless the single-page compression threshold is higher than the
average, the average is useless.  IMHO I'd suggest at least
5*PAGE_SIZE/8 as the single-page threshold, possibly higher.
