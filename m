Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934872Ab1ETI0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 04:26:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44425 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934699Ab1ETI0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 04:26:38 -0400
Date: Fri, 20 May 2011 10:26:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Armando Visconti <armando.visconti@st.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Fixed a crash in hid_report_raw_event() function.
In-Reply-To: <1305834082-14888-1-git-send-email-armando.visconti@st.com>
Message-ID: <alpine.LNX.2.00.1105201026300.28291@pobox.suse.cz>
References: <1305834082-14888-1-git-send-email-armando.visconti@st.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011, Armando Visconti wrote:

> I'm using a Data Modul EasyTouch USB multitouch controller,
> which is issuing a hid report with a size equals to 0. The rsize
> value gets set to 536870912 and Linux is crashing in the memset
> because the value is too big.
> 
> Signed-off-by: Armando Visconti <armando.visconti@st.com>
> ---
>  drivers/hid/hid-core.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index c3d6626..3e972e3 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1045,6 +1045,9 @@ void hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
>  
>  	rsize = ((report->size - 1) >> 3) + 1;
>  
> +	if (rsize > HID_MAX_BUFFER_SIZE)
> +		rsize = HID_MAX_BUFFER_SIZE;
> +
>  	if (csize < rsize) {
>  		dbg_hid("report %d is too short, (%d < %d)\n", report->id,
>  				csize, rsize);

Applied, thank you.

-- 
Jiri Kosina
SUSE Labs
