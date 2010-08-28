Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab0H1SSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 14:18:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40558 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab0H1SSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 14:18:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kFKPCyp7Uymdj5lbELDm5+hpt7DNJkULpSN45xlIcL8TAlkOcPXTHL8kPMjBwTE9qO
         v/kMP114xWFrYXLCPzKrGMiGqscwdkUoGB+9hc8g6WzVbqtTUQJyrLXEz1Z2PMr9cI2o
         qr58XBSs/94TDlSWhYaaVMgh1FyhxqwbLzks4=
Message-ID: <4C7952E9.5030608@gmail.com>
Date: Sat, 28 Aug 2010 20:18:17 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: erazor_de@users.sourceforge.net
CC: Jiri Kosina <jkosina@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: roccat: Fixing race condition on initialization
References: <1283000268.4789.1.camel@neuromancer>
In-Reply-To: <1283000268.4789.1.camel@neuromancer>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2010 02:57 PM, Stefan Achatz wrote:
> Fixed raced condition where event occurs before drvdata is set.
> 
> Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
> ---
>  drivers/hid/hid-roccat-kone.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
> index f776957..cfeab56 100644
> --- a/drivers/hid/hid-roccat-kone.c
> +++ b/drivers/hid/hid-roccat-kone.c
> @@ -966,6 +966,10 @@ static int kone_raw_event(struct hid_device *hdev, struct hid_report *report,
>  	struct kone_device *kone = hid_get_drvdata(hdev);
>  	struct kone_mouse_event *event = (struct kone_mouse_event *)data;
>  
> +	/* possible race condition on initialization */
> +	if (!kone)
> +		return 0;

This kind of "protection" caused much headache in the tty layer in the
past. If there is such a problem, please fix the initialization code
instead.

What sort of problems you are seeing?

thanks,
-- 
js
