Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab1E0APs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 20:15:48 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:56154 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377Ab1E0APr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 20:15:47 -0400
Subject: Re: [PATCH-v5 07/13] iscsi-target: Add iSCSI Login Negotiation +
	Parameter logic
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, hch@lst.de, hare@suse.de,
        agrover@redhat.com, michaelc@cs.wisc.edu, bharrosh@panasas.com,
        akpm@linux-foundation.org, martin.svec@zoner.cz,
        jxm@risingtidesystems.com
In-Reply-To: <20110527084752T.fujita.tomonori@lab.ntt.co.jp>
References: <1306445587.23461.22.camel@haakon2.linux-iscsi.org>
	 <1306451068.4048.69.camel@mulgrave.site>
	 <1306452490.23461.60.camel@haakon2.linux-iscsi.org>
	 <20110527084752T.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Thu, 26 May 2011 17:07:28 -0700
Message-Id: <1306454848.23461.77.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 08:47 +0900, FUJITA Tomonori wrote:
> On Thu, 26 May 2011 16:28:10 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > As we have discussed at length over the years, the split needs to be all
> > userspace or all kernelspace, and when implementations start doing
> > things in-between they quickly get painful to debug, maintain and
> > extend.  I have no interest in trying to evolve this further when LIO
> 
> Sorry, I disagree. As I explained, once user space passes established nexuses
> to kernel, kernel handles all. I don't think it's painful.
> 
> 

Then we are going to have to agree to disgree on this for an individual
target endpoint context and being able to manage (via configfs) a
complete set of iscsi-target features with native python library code.

As for moving the mainline iscsi-target efforts to a more complex
default direction is something that we (speaking as LIO maintainer and
on behalf of RisingTide userspace) do not have an interest for an
initial merge.  We owe our users a complete set of functional and stable
kernel and userspace library+shell, and not an untested design with
undetermined time-frame for deployment.

> > from the default two cases provided in their series, but lets please,
> > please avoid slipping yet another window here when we still have >= 15K
> > LOC in three other HW target mode fabric drivers in flight for the next
> > round
> 
> Why can't you push other fabric drivers before iSCSI one?

Well, ibmvscsis look pretty reasonable at this point wrt to I/O path,
but that is up to Mr. King, yourself and James, which by the way we
still need to get a proper /var/target/fabric/ibmvscsis.spec feature set
defined.  The default example spec and README are included here btw:

http://www.risingtidesystems.com/git/?p=rtslib.git;a=tree;f=specs;hb=HEAD

--nab

