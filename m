Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab2KZDTw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 22:19:52 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:58504 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab2KZDTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 22:19:51 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        "Luck, Tony" <tony.luck@intel.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: RE: linux-next: manual merge of the ia64 tree with Linus' tree
Thread-Topic: linux-next: manual merge of the ia64 tree with Linus' tree
Thread-Index: AQHNy21y/tfMRaRlHkqGBpYN+Cpnzpf7cq/g
Date: Mon, 26 Nov 2012 03:19:38 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4149F993D@USINDEM103.corp.hds.com>
References: <20121126113141.3b624dc9e729039b54c51881@canb.auug.org.au>
In-Reply-To: <20121126113141.3b624dc9e729039b54c51881@canb.auug.org.au>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-11-25_07:2012-11-23,2012-11-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1211250362
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This fix is reasonable to me.

Thanks,

Seiji

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Sunday, November 25, 2012 7:32 PM
> To: Luck, Tony
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Colin Ian King; Anton Vorontsov; Seiji Aguchi
> Subject: linux-next: manual merge of the ia64 tree with Linus' tree
> 
> Hi all,
> 
> Today's linux-next merge of the ia64 tree got a conflict in fs/pstore/platform.c between commit 70a6f46d7b0e ("pstore: Fix NULL
> pointer dereference in console writes") from Linus' tree and commit
> faa338315985 ("efi_pstore: Add a sequence counter to a variable name") from the ia64 tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc fs/pstore/platform.c
> index 947fbe0,e518f43..0000000
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@@ -173,7 -172,7 +173,7 @@@ static void pstore_console_write(struc
>   			spin_lock_irqsave(&psinfo->buf_lock, flags);
>   		}
>   		memcpy(psinfo->buf, s, c);
> - 		psinfo->write(PSTORE_TYPE_CONSOLE, 0, &id, 0, c, psinfo);
>  -		psinfo->write(PSTORE_TYPE_CONSOLE, 0, NULL, 0, 0, c, psinfo);
> ++		psinfo->write(PSTORE_TYPE_CONSOLE, 0, &id, 0, 0, c, psinfo);
>   		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
>   		s += c;
>   		c = e - s;
