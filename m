Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab2GJONW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 10:13:22 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:14978 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab2GJONV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 10:13:21 -0400
X-Authority-Analysis: v=2.0 cv=QrvcLCOd c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=Qsx_du5GiBkA:10 a=cgbV5Ep4loIA:10 a=UodPDTrrUR8A:10 a=S1A5HrydsesA:10 a=8nJEP1OIZ-IA:10 a=fxJcL_dCAAAA:8 a=xe8BsctaAAAA:8 a=BbRoe_GFovPOuqIqmbQA:9 a=wPNLvfGTeEIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.78.168.186
Message-ID: <4FFC387F.3070308@ubuntu.com>
Date: Tue, 10 Jul 2012 10:13:19 -0400
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com,
        kzak@redhat.com, maxim.patlasov@gmail.com
Subject: Re: [patch 0/2] [V4] block: Support online resize of disk partitions
References: <20120709213418.799759100@redhat.com> <4FFB5DC3.30803@ubuntu.com> <20120710135759.GE14884@redhat.com>
In-Reply-To: <20120710135759.GE14884@redhat.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 7/10/2012 9:57 AM, Vivek Goyal wrote:
> +static inline sector_t part_nr_sects_read(struct hd_struct *part) 
> +{ +#if BITS_PER_LONG==32 && defined(CONFIG_LBDAF) &&
> defined(CONFIG_SMP) +	sector_t nr_sects; +	unsigned seq; +	do { +
> seq = read_seqcount_begin(&part->nr_sects_seq); +		nr_sects =
> part->nr_sects; +	} while (read_seqcount_retry(&part->nr_sects_seq,
> seq)); +	return nr_sects; +#elif BITS_PER_LONG==32 &&
> defined(CONFIG_PREEMPT)

Shouldn't this be BITS_PER_LONG==32 && defined(CONFIG_LBDAF) &&
defined(CONFIG_PREEMPT)?  No sense disabling preemption when the
sector size is also 32 bits.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJP/Dh/AAoJEJrBOlT6nu75ussIANfCKaObXMJ6JhCNLSeiHUqr
FfBd6p2lJIFd73NSymyigZZ1/rPsy9TpMBlcMwpuFh2erxQ7q3rFnP0O52fEgm2+
20c9+oeUGkzYx62fh0KtfrzBpzhiHOivKR/muAZcfNbb75iKTGrZSZUFrdqAqHci
4zCuu8T37BRo4G9TGdIXD1WT3sltZ7yOk4I7RBhAIDkbt82vVakZ6mlW9hyWmyvD
/sMnXMmkNjwTDdhQj2ho9mn9SFcnDA+aAtJfPXjVAT0W9CKNDYbXw28ud+ARxo5T
rkTjoewdxKffZsBmkkSiNCuLWwpkZng+nTchQjyZbmp/pl4UPlQOfcUb6YxpDX4=
=1tUj
-----END PGP SIGNATURE-----
