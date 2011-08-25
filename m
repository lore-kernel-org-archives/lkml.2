Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab1HYIUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 04:20:24 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:23612 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab1HYIUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 04:20:21 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Seth Forshee <seth.forshee@canonical.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Huang <aaron_huang@emc.com.tw>,
        Tom Lin <tom_lin@emc.com.tw>,
        =?utf-8?Q?=C3=89ric?= Piel <E.A.B.Piel@tudelft.nl>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH v2 7/7] Input: elantech - add v3 hardware support
In-Reply-To: <20110825070642.GB15655@core.coreip.homeip.net>
References: <1314164686-866-1-git-send-email-jj_ding@emc.com.tw> <1314164686-866-8-git-send-email-jj_ding@emc.com.tw> <20110824143520.GB23868@thinkpad-t410> <87mxeynvpt.fsf@emc.com.tw> <20110825070642.GB15655@core.coreip.homeip.net>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 25 Aug 2011 16:22:14 +0800
Message-ID: <8762llq4sp.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Much cleaner. Thank you.
I will change it.

jj

On Thu, 25 Aug 2011 00:06:42 -0700, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On Thu, Aug 25, 2011 at 09:09:02AM +0800, JJ Ding wrote:
> > Hi Seth,
> > 
> > Thank you. You are right.
> > I think I somehow tested the worng touchpad for this patch.
> > 
> 
> How about we change it thusly:
> 
> Input: elamtech - fix V3 packet checking
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> 
>  drivers/input/mouse/elantech.c |   18 ++++++------------
>  1 files changed, 6 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
> index 1e2b9da..d814bf74 100644
> --- a/drivers/input/mouse/elantech.c
> +++ b/drivers/input/mouse/elantech.c
> @@ -508,24 +508,18 @@ static int elantech_packet_check_v2(struct psmouse *psmouse)
>   */
>  static int elantech_packet_check_v3(struct psmouse *psmouse)
>  {
> +	const u8 debounce_packet[] = { 0xc4, 0xff, 0xff, 0x02, 0xff, 0xff };
>  	unsigned char *packet = psmouse->packet;
>  
> -	if ((packet[0] & 0x0c) == 0x04 &&
> -	    (packet[3] & 0xcf) == 0x02)
> +	if (!memcmp(packet, debounce_packet, sizeof(debounce_packet)))
> +		return PACKET_DEBOUNCE;
> +
> +	if ((packet[0] & 0x0c) == 0x04 && (packet[3] & 0xcf) == 0x02)
>  		return PACKET_V3_HEAD;
>  
> -	if ((packet[0] & 0x0c) == 0x0c &&
> -	    (packet[3] & 0xce) == 0x0c)
> +	if ((packet[0] & 0x0c) == 0x0c && (packet[3] & 0xce) == 0x0c)
>  		return PACKET_V3_TAIL;
>  
> -	if (packet[0] == 0xc4 &&
> -	    packet[1] == 0xff &&
> -	    packet[2] == 0xff &&
> -	    packet[3] == 0x02 &&
> -	    packet[4] == 0xff &&
> -	    packet[5] == 0xff)
> -		return PACKET_DEBOUNCE;
> -
>  	return PACKET_UNKNOWN;
>  }
>  
> Thanks.
> 
> -- 
> Dmitry
