Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab2H2OxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 10:53:20 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50146 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644Ab2H2OxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 10:53:18 -0400
Message-ID: <1346251975.27020.2.camel@localhost.localdomain>
Subject: Re: [PATCH v7 0/8] Raid: enable talitos xor offload for improving
 performance
From: Dan Williams <djbw@fb.com>
To: Liu Qiang-B32616 <B32616@freescale.com>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>
Date: Wed, 29 Aug 2012 07:52:55 -0700
In-Reply-To: <BCB48C05FCE8BC4D9E61E841ECBE6DB70FC3CA@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1344500375-8457-1-git-send-email-qiang.liu@freescale.com>
	 <20120809170307.GG14264@ovro.caltech.edu>
	 <BCB48C05FCE8BC4D9E61E841ECBE6DB70E3D47@039-SN2MPN1-013.039d.mgd.msft.net>
	 <CAA9_cme4tHrx14JaSaHwgcGq79qQK5bv8E205fbC3ega5OpUiQ@mail.gmail.com>
	 <BCB48C05FCE8BC4D9E61E841ECBE6DB70FC3CA@039-SN2MPN1-011.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-08-29_04:2012-08-29,2012-08-29,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-29 at 11:15 +0000, Liu Qiang-B32616 wrote:
> Hi Dan,
> 
> Ping?
> Can you apply these patches? Thanks.
> 

I'm working my way through them.

The first thing I notice is that xor_chan->desc_lock is taken
inconsistently.  I.e. spin_lock_irqsave() in talitos_process_pending()
and spin_lock_bh() everywhere else.  Have you run these patches with
lockdep?

--
Dan


