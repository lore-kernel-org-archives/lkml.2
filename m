Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab1BFA1y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 19:27:54 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:36904
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640Ab1BFA1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 19:27:52 -0500
X-SpamScore: -52
X-BigFish: VPS-52(zzbb2dK1803M1432N98dN4015L9371Pzz1202hzz8275dh1033ILz2fh2a8h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D4DEAE7.1070306@am.sony.com>
Date: Sat, 5 Feb 2011 16:27:19 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Andrew Murray <amurray@mpcdata.com>
CC: "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>
Subject: Re: [PATCH] printk-formats.txt documentation update
References: <AANLkTikj+FU8OF_-KFr2hmTSWqTHMK5JnrnTVyn-XtxQ@mail.gmail.com>
In-Reply-To: <AANLkTikj+FU8OF_-KFr2hmTSWqTHMK5JnrnTVyn-XtxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2011 04:15 PM, Andrew Murray wrote:
> From: Andrew Murray <amurray@mpc-data.co.uk>
> 
> This patch updates the incomplete documentation concerning the printk
> extended format specifiers.
> 
> Signed-off-by: Andrew Murray <amurray@mpc-data.co.uk>
> ---
> diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
> index 1b5a5dd..df14336 100644
> --- a/Documentation/printk-formats.txt
> +++ b/Documentation/printk-formats.txt
> @@ -9,7 +9,42 @@ If variable is of Type,		use printk format specifier:
>  		size_t			%zu or %zx
>  		ssize_t			%zd or %zx
> 
> -Raw pointer value SHOULD be printed with %p.
> +Raw pointer value SHOULD be printed with %p. The kernel supports
> +the following extended format specifiers for pointer types:
> +
> +	General:
> +
> +	%pF	function pointer with offset, e.g. module_start
> +	%pf	function pointer without offset, e.g. module_start+0x0/0x62 [hello]
> +	%pS	text symbol with offset	
> +	%ps	text symbol without offset
> +	%pR	struct resource with decoded flags, e.g. [mem 0x0-0x1f 64 bit pref]
> +	%pr	struct resource with raw flags, e.g. [mem 0x0-0x1f flags 0x201]
> +
> +	MAC/FDDI addresses:
> +	
> +	%pM	colon-seperated 6-byte MAC address in hex notation, e.g. 00:01:02:03:04:05
> +	%pm	non-colon-seperated 6-byte MAC address is hex notation, e.g. 000102030405
> +	%pMF	6-byte dash-separated FDDI hex notation
> +
> +	IPv4 addresses:
> +
> +	%pI4	IPv4 dot-seperated decimal without leading 0's, e.g. 1.2.3.4
> +	%pi4	IPv4 dot-seperated decimal with leading 0's, 001.002.003.004
> +	%p[Ii]4[hl] IPv4 dot-seperated decimal with/without leading 0's for
> +		host (h), little (l) or network/big (default) endian order
> +
> +	IPv6 addresses:
> +	%pI6	IPv6 colon-seperated network-order 16 bit hex with leading 0's,
> +		e.g. 0001:0203:...:0708
> +	%pi6	IPv6 non-colon-seperated network-order 16 bit hex with leading 0's,
> +		e.g. 000102...0f
> +	%pI6c	IPv6 address as described by
> +		http://tools.ietf.org/html/draft-ietf-6man-text-addr-representation-00,
> +		e.g. 1::708
> +
> +	%pU[bBlL] 16 byte UUID/GUID in big or little endian using lower or upper case
> +
> 
>  u64 SHOULD be printed with %llu/%llx, (unsigned long long):

I like this, as it has information that is not documented elsewhere.

Some feedback on the patch:

Some of these lines are longer than 80 chars.  Can you please truncate
things to fit in an 80-column terminal window?

Thanks,
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Network Entertainment
=============================

