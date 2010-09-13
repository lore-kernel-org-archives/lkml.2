Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab0IMUoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:44:14 -0400
Received: from smtp109.sbc.mail.gq1.yahoo.com ([67.195.14.39]:40367 "HELO
	smtp109.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750906Ab0IMUoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:44:12 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: EY8Sl0gVM1l5ghGyu2IXBIy1qHY.BpLML9oiMUi39j7c_mM
 meGXUImKJRi6Q.c3s.If0L9apB_cZwbbn8UpqKwRWiO3uYEKUR0PWeqHwJDk
 5BOyhH7L6k7Qii_RQni_IU099MMIgzTSI_OY7J3h7c_inj_CG5ofYCpDER1t
 8V_F_c68E1zWfdbTf.trgjgiju5xqE052zJTYWtbVnZxj3Jq2nLf9MGZjpTz
 qCwE4MCsLG9AWztBWQu7MxUv0Fr3XTciRPVtV80BFWuZqSq8nyBtPS4carzQ
 WX2LhMuoZfzAuA5KUZHp.NZyEmMRNBH5f8HeY1PpSDzg0W5uE7tZAxwdh
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH 0/2] lio-target: Add support for libcrypto crc32c and
	crc32-intel offload
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        James Bottomley <James.Bottomley@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        Vasu Dev <vasu.dev@linux.intel.com>, Joe Eykholt <jeykholt@cisco.com>
In-Reply-To: <4C8E8AF5.5080205@cs.wisc.edu>
References: <1284201076-22361-1-git-send-email-nab@linux-iscsi.org>
	 <4C8DED17.6080801@suse.de>
	 <1284407432.8171.41.camel@haakon2.linux-iscsi.org>
	 <4C8E8AF5.5080205@cs.wisc.edu>
Content-Type: text/plain
Date: Mon, 13 Sep 2010 13:40:06 -0700
Message-Id: <1284410406.8171.63.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 15:35 -0500, Mike Christie wrote:
> On 09/13/2010 02:50 PM, Nicholas A. Bellinger wrote:
> >> IE the in-kernel crc32c routines apparently weren't able to
> >> calculate the checksum in an endianness-independent manner.
> >> So a CRC calculated on a BE machine would fail to be validated by a
> >> LE machine and vice versa.
> >>
> >> Has this been fixed / verified?
> >>
> >
> >> From taking a look at crypto/crc32c.c it still appears AFAICT to not be
> > big endian safe.  I was planning to test this patch on some powerpc/ppc
> > hardware with v2.6.36-rc4 in the next days, but it looks like
> > lio-core-2.6.git will need a seperate crypto/crc32c.c patch to function
> > properly on big endian arches.
> >
> 
> There was this bug that was fixed a couple years ago:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ef19454bd437b2ba14c9cda1de85debd9f383484
> since then I think we have not had problems.

Hi Mike,

Thanks for the pointer on this, I will give it a shot on powerpc and see
what happens.

FYI, I was under the assumption that for BIG_ENDIAN that crc32c() still
needed an bitshift for the returned value.  This is what we had been
doing with our old internal do_crc() code here:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/lio-target/iscsi_crc.c;hb=83559072b27eb8cd92abb9a3fc9be85018c5db06#l138

AFAICT there is still nothing that makes crypto/crc32c.c big endian
safe, unless I am overlooking something obvious..?

Best,

--nab


