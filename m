Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab1JMS5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 14:57:12 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46540 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab1JMS5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 14:57:11 -0400
Date: Thu, 13 Oct 2011 20:56:56 +0200
From: Borislav Petkov <bp@amd64.org>
To: Niklas =?iso-8859-1?Q?S=F6derlund?= <niso@kth.se>
Cc: "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i7core_edac: fix erroneous size of static array
Message-ID: <20111013185656.GC3064@aftab>
References: <1318530294-6829-1-git-send-email-niso@kth.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1318530294-6829-1-git-send-email-niso@kth.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 02:24:54PM -0400, Niklas Söderlund wrote:
> Signed-off-by: Niklas Söderlund <niso@kth.se>
> ---
>  drivers/edac/i7core_edac.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
> index 70ad892..e0f6096 100644
> --- a/drivers/edac/i7core_edac.c
> +++ b/drivers/edac/i7core_edac.c
> @@ -441,7 +441,7 @@ static inline int numrow(u32 row)
>  
>  static inline int numcol(u32 col)
>  {
> -	static int cols[8] = {
> +	static int cols[4] = {
>  		1 << 10, 1 << 11, 1 << 12, -EINVAL,
>  	};

Even better,

you could completely remove the number in the [] since the {}
initializer contains all array elements already. In this and the
remaining arrays in those small inline functions.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
