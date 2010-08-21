Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121Ab0HUJL5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 05:11:57 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:46221 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750875Ab0HUJL4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 05:11:56 -0400
Date: Sat, 21 Aug 2010 05:11:42 -0400 (EDT)
From: Miloslav Trmac <mitr@redhat.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
Message-ID: <88057790.1047131282381902365.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4C6E79B2.1040309@s5r6.in-berlin.de>
Subject: Re: [PATCH 01/19] User-space API definition
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Stefan Richter" <stefanr@s5r6.in-berlin.de> wrote:
> Miloslav Trmač wrote:
> > --- /dev/null
> > +++ b/include/linux/ncr.h
> [...]
> > +struct ncr_session_input_data {
> > +	const void __user *data;
> > +	__kernel_size_t data_size;
> > +};
> 
> Why not using fixed-size fit-all members?
> 
> struct ncr_session_input_data {
> 	__u64 data;		/* user pointer, cast to/from u64 */
> 	__u32 data_size;	/* or __u64? */
> };
> 
> And then get rid of all the COMAPT code paths.
That would make the interface less natural, and any architecture that wanted to have larger pointers (I understand IBM did this back the '80s, so it can happen again) would result in a significantly worse mess than the widely used compat_ioctl mechanism.
    Mirek
