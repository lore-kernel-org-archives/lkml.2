Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab0EaRQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 13:16:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23834 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab0EaRQV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 13:16:21 -0400
MIME-Version: 1.0
Message-ID: <a38d5a97-1517-46c4-9b2f-27e16aba58f2@default>
Date: Mon, 31 May 2010 10:14:07 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: ngupta@vflare.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
       hugh.dickins@tiscali.co.uk, JBeulich@novell.com, chris.mason@oracle.com,
       kurt.hackel@oracle.com, dave.mccracken@oracle.com, npiggin@suse.de,
       akpm@linux-foundation.org, riel@redhat.com, avi@redhat.com,
       pavel@ucw.cz, konrad.wilk@oracle.com
Subject: RE: [PATCH V2 0/4] Frontswap (was Transcendent Memory): overview
References: <20100528174020.GA28150@ca-server1.us.oracle.com
 4C02AB5A.5000706@vflare.org>
In-Reply-To: <4C02AB5A.5000706@vflare.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4C03EEA9.0132:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 05/28/2010 11:10 PM, Dan Magenheimer wrote:
> > [PATCH V2 0/4] Frontswap (was Transcendent Memory): overview
> >
> > Changes since V1:
> > - Rebased to 2.6.34 (no functional changes)
> > - Convert to sane types (per Al Viro comment in cleancache thread)
> > - Define some raw constants (Konrad Wilk)
> > - Performance analysis shows significant advantage for frontswap's
> >   synchronous page-at-a-time design (vs batched asynchronous
> speculated
> >   as an alternative design).  See http://lkml.org/lkml/2010/5/20/314
> >
> 
> I think zram (http://lwn.net/Articles/388889/) is a more generic
> solution
> and can also achieve swap-to-hypervisor as a special case.
> 
> zram is a generic in-memory compressed block device. To get frontswap
> functionality, such a device (/dev/zram0) can be exposed to a VM as
> a 'raw disk'. Such a disk can be used for _any_ purpose by the guest,
> including use as a swap disk.

Hi Nitin --

Though I agree zram is cool inside Linux, I don't see that it can
be used to get the critical value of frontswap functionality in a
virtual environment, specifically the 100% dynamic control by the
hypervisor of every single page attempted to be "put" to frontswap.
This is the key to the "intelligent overcommit" discussed in the
previous long thread about frontswap.

Further, by doing "guest-side compression" you are eliminating
possibilities for KSM-style sharing, right?

So while zram may be a great feature, it is NOT a more generic
solution than frontswap, just a different solution that has a
different set of objectives.

Dan
