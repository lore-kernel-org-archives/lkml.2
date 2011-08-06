Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab1HFOgL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 10:36:11 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:38379 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754846Ab1HFOgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 10:36:08 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18Xc4lWrdEXtzGVJt2pjgYXFTv8JM2M4MZlahEMEr
	rdB/7cCNoPGhFu
Message-ID: <4E3D5154.2040808@gmx.de>
Date: Sat, 06 Aug 2011 14:36:04 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: stufever@gmail.com
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        lethal@linux-sh.org, Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: Re: [PATCH] viafb: fix pointer type missmatch
References: <1312637180-6107-1-git-send-email-wangshaoyan.pt@taobao.com>
In-Reply-To: <1312637180-6107-1-git-send-email-wangshaoyan.pt@taobao.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/06/2011 01:26 PM, stufever@gmail.com wrote:
> From: Wang Shaoyan<wangshaoyan.pt@taobao.com>
>
>    drivers/video/via/via-core.c: In function 'via_pci_probe':
>    drivers/video/via/via-core.c:691: warning: assignment discards qualifiers from pointer target type
>
> Signed-off-by: Wang Shaoyan<wangshaoyan.pt@taobao.com>
> ---
>   drivers/video/via/via-core.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
> index eb112b6..dd58b53 100644
> --- a/drivers/video/via/via-core.c
> +++ b/drivers/video/via/via-core.c
> @@ -35,7 +35,7 @@ static struct via_port_cfg adap_configs[] = {
>    * The OLPC XO-1.5 puts the camera power and reset lines onto
>    * GPIO 2C.
>    */
> -static const struct via_port_cfg olpc_adap_configs[] = {
> +static struct via_port_cfg olpc_adap_configs[] = {

Well the const was there as this object should really not be changed at runtime. 
But as the correct solution is not feasible as it conflicts with the I2C API and 
casting the const away would be evil as well I will accept this patch.
But as I assume you, who sent this email, are not the original author, please 
resent it with your Signed-off-by added. (as keeping track who received the 
patch from whom is one reasons for having those)

>   	[VIA_PORT_26]	= { VIA_PORT_I2C,  VIA_MODE_I2C, VIASR, 0x26 },
>   	[VIA_PORT_31]	= { VIA_PORT_I2C,  VIA_MODE_I2C, VIASR, 0x31 },
>   	[VIA_PORT_25]	= { VIA_PORT_GPIO, VIA_MODE_GPIO, VIASR, 0x25 },

Thanks,

Florian Tobias Schandinat
